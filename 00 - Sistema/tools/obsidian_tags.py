#!/usr/bin/env python
"""Inventario, validacion y normalizacion conservadora de tags de Obsidian."""

from __future__ import annotations

import argparse
import collections
import csv
import json
import pathlib
import re
import sys
import unicodedata
from dataclasses import dataclass


ROOT = pathlib.Path(__file__).resolve().parents[2]
DEFAULT_POLICY = ROOT / "00 - Sistema" / "meta" / "tags-controlados.json"

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")


@dataclass
class TagBlock:
    path: pathlib.Path
    text: str
    newline: str
    line_start: int
    line_end: int
    indent: str
    style: str
    tags: list[str]


def normalized_key(value: str) -> str:
    value = unicodedata.normalize("NFKD", value.strip())
    value = "".join(char for char in value if not unicodedata.combining(char))
    value = value.lower().replace("_", "-").replace(" ", "-")
    return re.sub(r"-+", "-", value).strip("-")


def load_policy(path: pathlib.Path) -> dict:
    data = json.loads(path.read_text(encoding="utf-8"))
    canonical = data.get("canonical_tags", [])
    if len(canonical) != len(set(canonical)):
        raise ValueError("canonical_tags contiene duplicados")
    invalid = [tag for tag in canonical if tag != normalized_key(tag)]
    if invalid:
        raise ValueError(f"tags canonicos no normalizados: {', '.join(invalid)}")
    data["canonical_set"] = set(canonical)
    data["domain_set"] = set(data.get("domains", []))
    data["alias_map"] = {
        normalized_key(alias): target
        for alias, target in data.get("aliases", {}).items()
    }
    return data


def relative(path: pathlib.Path) -> str:
    return path.relative_to(ROOT).as_posix()


def in_scope(path: pathlib.Path, policy: dict) -> bool:
    rel = relative(path)
    return not any(rel.startswith(prefix) for prefix in policy.get("exclude_prefixes", []))


def markdown_files(policy: dict) -> list[pathlib.Path]:
    return sorted(
        path
        for path in ROOT.rglob("*.md")
        if in_scope(path, policy)
    )


def parse_inline_list(value: str) -> list[str]:
    inner = value[1:-1].strip()
    if not inner:
        return []
    return [item.strip().strip('"\'') for item in inner.split(",") if item.strip()]


def find_tag_block(path: pathlib.Path) -> TagBlock | None:
    text = path.read_text(encoding="utf-8")
    newline = "\r\n" if "\r\n" in text else "\n"
    lines = text.splitlines(keepends=True)
    if not lines or lines[0].lstrip("\ufeff").strip() != "---":
        return None

    frontmatter_end = None
    for index in range(1, len(lines)):
        if lines[index].strip() == "---":
            frontmatter_end = index
            break
    if frontmatter_end is None:
        return None

    tag_line = re.compile(r"^(\s*)tags\s*:\s*(.*?)\s*(?:\r?\n)?$")
    item_line = re.compile(r"^\s+-\s+(.*?)\s*(?:\r?\n)?$")
    for index in range(1, frontmatter_end):
        match = tag_line.match(lines[index])
        if not match:
            continue
        indent, value = match.groups()
        if value.startswith("[") and value.endswith("]"):
            return TagBlock(path, text, newline, index, index + 1, indent, "inline", parse_inline_list(value))
        if value:
            return TagBlock(path, text, newline, index, index + 1, indent, "scalar", [value.strip('"\'')])

        tags: list[str] = []
        end = index + 1
        while end < frontmatter_end:
            item_match = item_line.match(lines[end])
            if not item_match:
                break
            tags.append(item_match.group(1).strip().strip('"\''))
            end += 1
        return TagBlock(path, text, newline, index, end, indent, "block", tags)
    return None


def normalize_tags(tags: list[str], policy: dict) -> tuple[list[str], list[str]]:
    canonical = policy["canonical_set"]
    aliases = policy["alias_map"]
    normalized: list[str] = []
    unknown: list[str] = []
    for original in tags:
        key = normalized_key(original)
        if not key:
            continue
        if key in aliases:
            target = aliases[key]
            if target is None:
                continue
            key = target
        if key not in canonical:
            unknown.append(original)
            key = original
        if key not in normalized:
            normalized.append(key)
    return normalized, unknown


def render_tag_block(block: TagBlock, tags: list[str]) -> str:
    if not tags:
        return f"{block.indent}tags: []{block.newline}"
    if block.style == "block":
        rendered = f"{block.indent}tags:{block.newline}"
        rendered += "".join(f"{block.indent}  - {tag}{block.newline}" for tag in tags)
        return rendered
    return f"{block.indent}tags: [{', '.join(tags)}]{block.newline}"


def replace_tag_block(block: TagBlock, tags: list[str]) -> str:
    lines = block.text.splitlines(keepends=True)
    lines[block.line_start:block.line_end] = [render_tag_block(block, tags)]
    return "".join(lines)


def collect(policy: dict) -> list[TagBlock]:
    blocks: list[TagBlock] = []
    for path in markdown_files(policy):
        block = find_tag_block(path)
        if block is not None:
            blocks.append(block)
    return blocks


def command_report(policy: dict) -> int:
    counts: collections.Counter[str] = collections.Counter()
    normalized_counts: collections.Counter[str] = collections.Counter()
    note_count = 0
    for block in collect(policy):
        note_count += 1
        counts.update(block.tags)
        normalized, _ = normalize_tags(block.tags, policy)
        normalized_counts.update(normalized)

    print(f"Notas con tags en alcance: {note_count}")
    print(f"Formas actuales distintas: {len(counts)}")
    print(f"Formas tras normalizacion: {len(normalized_counts)}")
    print("\nUso tras normalizacion:")
    for tag, count in sorted(normalized_counts.items(), key=lambda item: (-item[1], item[0])):
        print(f"{count:4}  {tag}")
    return 0


def command_check(policy: dict) -> int:
    warnings: list[str] = []
    max_tags = policy.get("max_tags_per_note", 5)
    max_domains = policy.get("max_domain_tags_per_note", 2)
    domains = policy["domain_set"]

    for block in collect(policy):
        normalized, unknown = normalize_tags(block.tags, policy)
        if unknown:
            warnings.append(f"{relative(block.path)}: tags no controlados: {', '.join(unknown)}")
        if block.tags != normalized:
            warnings.append(
                f"{relative(block.path)}: requiere normalizacion: {block.tags} -> {normalized}"
            )
        if len(normalized) > max_tags:
            warnings.append(
                f"{relative(block.path)}: {len(normalized)} tags; maximo {max_tags}: {normalized}"
            )
        domain_tags = [tag for tag in normalized if tag in domains]
        if len(domain_tags) > max_domains:
            warnings.append(
                f"{relative(block.path)}: demasiados dominios ({len(domain_tags)}): {domain_tags}"
            )

    if not warnings:
        print("obsidian_tags: OK")
        return 0
    for warning in warnings:
        print(f"WARN: {warning}")
    print(f"\nResumen: {len(warnings)} aviso(s)")
    return 1


def command_normalize(policy: dict, apply: bool, audit_path: pathlib.Path | None) -> int:
    changed = 0
    unknown_total = 0
    audit_rows: list[tuple[str, str, str]] = []
    for block in collect(policy):
        normalized, unknown = normalize_tags(block.tags, policy)
        unknown_total += len(unknown)
        if normalized == block.tags:
            continue
        changed += 1
        marker = "APPLY" if apply else "DRY-RUN"
        print(f"{marker}: {relative(block.path)}: {block.tags} -> {normalized}")
        audit_rows.append(
            (relative(block.path), " | ".join(block.tags), " | ".join(normalized))
        )
        if apply:
            block.path.write_text(replace_tag_block(block, normalized), encoding="utf-8", newline="")
    if audit_path and audit_rows:
        resolved_audit = audit_path if audit_path.is_absolute() else ROOT / audit_path
        resolved_audit.parent.mkdir(parents=True, exist_ok=True)
        with resolved_audit.open("w", encoding="utf-8", newline="") as handle:
            writer = csv.writer(handle)
            writer.writerow(["path", "tags_before", "tags_after"])
            writer.writerows(audit_rows)
        print(f"Auditoria: {relative(resolved_audit)}")
    label = "Archivos cambiados" if apply else "Archivos a cambiar"
    print(f"\n{label}: {changed}")
    print(f"Tags no controlados conservados: {unknown_total}")
    if not apply and changed:
        print("Use `normalize --apply` para escribir los cambios.")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--policy", type=pathlib.Path, default=DEFAULT_POLICY)
    subparsers = parser.add_subparsers(dest="command", required=True)
    subparsers.add_parser("report")
    subparsers.add_parser("check")
    normalize = subparsers.add_parser("normalize")
    normalize.add_argument("--apply", action="store_true")
    normalize.add_argument("--audit", type=pathlib.Path)
    args = parser.parse_args()

    policy = load_policy(args.policy)
    if args.command == "report":
        return command_report(policy)
    if args.command == "check":
        return command_check(policy)
    return command_normalize(policy, args.apply, args.audit)


if __name__ == "__main__":
    sys.exit(main())
