#!/usr/bin/env python
"""Validacion suave de la capa curada de la boveda Obsidian."""

from __future__ import annotations

import datetime as dt
import pathlib
import re
import sys
from dataclasses import dataclass


ROOT = pathlib.Path(__file__).resolve().parents[2]

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8")

REQUIRED_PATHS = [
    "AGENTS.md",
    "00 - Sistema/Indice.md",
    "00 - Sistema/log.md",
    "00 - Sistema/meta/modelo-operativo.md",
    "00 - Sistema/meta/taxonomia.md",
    "00 - Sistema/meta/checklist-calidad.md",
    "00 - Sistema/meta/registro-fuentes.csv",
    "20 - Notas enlazadas/Fuentes",
    "20 - Notas enlazadas/Conceptos",
    "20 - Notas enlazadas/Entidades",
    "20 - Notas enlazadas/Sintesis",
    "20 - Notas enlazadas/Analisis",
    "20 - Notas enlazadas/Procesos",
    "raw/sources",
]

CURATED_ROOTS = [
    "00 - Sistema",
    "20 - Notas enlazadas/Fuentes",
    "20 - Notas enlazadas/Conceptos",
    "20 - Notas enlazadas/Entidades",
    "20 - Notas enlazadas/Sintesis",
    "20 - Notas enlazadas/Analisis",
    "20 - Notas enlazadas/Procesos",
]

FRONTMATTER_REQUIRED = {"title", "type", "status", "created", "updated", "sources", "tags"}
LOG_HEADING = re.compile(r"^## \[(\d{4}-\d{2}-\d{2})\] ([a-z-]+) \| .+")
WIKILINK = re.compile(r"\[\[([^\]|#]+)(?:#[^\]|]+)?(?:\|[^\]]+)?\]\]")
MDLINK = re.compile(r"\[[^\]]+\]\(([^)]+)\)")


@dataclass
class Finding:
    level: str
    path: str
    message: str


def rel(path: pathlib.Path) -> str:
    return path.relative_to(ROOT).as_posix()


def read_text(path: pathlib.Path) -> str:
    return path.read_text(encoding="utf-8")


def parse_frontmatter(text: str) -> dict[str, str] | None:
    if not text.startswith("---\n"):
        return None
    end = text.find("\n---\n", 4)
    if end == -1:
        return None
    data: dict[str, str] = {}
    for line in text[4:end].splitlines():
        if not line.strip() or line.lstrip().startswith("#") or ":" not in line:
            continue
        key, value = line.split(":", 1)
        data[key.strip()] = value.strip()
    return data


def curated_markdown_pages() -> list[pathlib.Path]:
    pages: list[pathlib.Path] = []
    for folder in CURATED_ROOTS:
        root = ROOT / folder
        if root.exists():
            pages.extend(path for path in root.rglob("*.md") if ".obsidian" not in path.parts)
    return sorted(set(pages))


def all_markdown_pages() -> list[pathlib.Path]:
    ignored = {".git", ".obsidian"}
    return [
        path
        for path in ROOT.rglob("*.md")
        if not any(part in ignored for part in path.parts)
    ]


def markdown_target_exists(source_path: pathlib.Path, target: str) -> bool:
    if target.startswith(("http://", "https://", "mailto:", "#")):
        return True
    clean = target.split("#", 1)[0].strip()
    if not clean:
        return True
    candidate = (source_path.parent / clean).resolve()
    try:
        candidate.relative_to(ROOT)
    except ValueError:
        return True
    return candidate.exists()


def wikilink_target_exists(target: str, page_stems: dict[str, list[pathlib.Path]]) -> bool:
    normalized = target.strip().strip("/")
    if not normalized:
        return True
    if normalized.endswith(".md"):
        return (ROOT / normalized).exists()
    return pathlib.Path(normalized).stem in page_stems


def check_required_paths(findings: list[Finding]) -> None:
    for item in REQUIRED_PATHS:
        if not (ROOT / item).exists():
            findings.append(Finding("ERROR", item, "ruta obligatoria ausente"))


def check_frontmatter(findings: list[Finding]) -> None:
    for path in curated_markdown_pages():
        if path.name == "README.md":
            continue
        text = read_text(path)
        data = parse_frontmatter(text)
        if data is None:
            findings.append(Finding("WARN", rel(path), "sin frontmatter YAML"))
            continue
        missing = sorted(FRONTMATTER_REQUIRED - set(data))
        if missing:
            findings.append(Finding("WARN", rel(path), f"faltan claves: {', '.join(missing)}"))
        review_after = data.get("review_after", "").strip().strip('"')
        if review_after:
            try:
                review_date = dt.date.fromisoformat(review_after)
            except ValueError:
                findings.append(Finding("WARN", rel(path), f"review_after invalido: {review_after}"))
            else:
                if review_date < dt.date.today():
                    findings.append(Finding("WARN", rel(path), f"review_after vencido: {review_after}"))


def check_links(findings: list[Finding]) -> None:
    pages = all_markdown_pages()
    page_stems: dict[str, list[pathlib.Path]] = {}
    for path in pages:
        page_stems.setdefault(path.stem, []).append(path)

    for path in curated_markdown_pages():
        text = read_text(path)
        for match in WIKILINK.finditer(text):
            target = match.group(1)
            if not wikilink_target_exists(target, page_stems):
                findings.append(Finding("WARN", rel(path), f"wikilink no resuelto: [[{target}]]"))
        for match in MDLINK.finditer(text):
            target = match.group(1).strip()
            if not markdown_target_exists(path, target):
                findings.append(Finding("WARN", rel(path), f"enlace markdown no resuelto: {target}"))


def check_duplicate_curated_stems(findings: list[Finding]) -> None:
    stems: dict[str, list[pathlib.Path]] = {}
    for path in curated_markdown_pages():
        if path.name == "README.md":
            continue
        stems.setdefault(path.stem.lower(), []).append(path)
    for stem, paths in sorted(stems.items()):
        if len(paths) > 1:
            joined = ", ".join(rel(path) for path in paths)
            findings.append(Finding("WARN", "20 - Notas enlazadas", f"nombre ambiguo '{stem}': {joined}"))


def check_log(findings: list[Finding]) -> None:
    path = ROOT / "00 - Sistema" / "log.md"
    if not path.exists():
        return
    headings = [line for line in read_text(path).splitlines() if line.startswith("## ")]
    dated = [line for line in headings if LOG_HEADING.match(line)]
    if not dated:
        findings.append(Finding("WARN", rel(path), "no hay entradas de log parseables"))
    for line in headings:
        if "YYYY-MM-DD" in line:
            continue
        if line.startswith("## [") and not LOG_HEADING.match(line):
            findings.append(Finding("WARN", rel(path), f"cabecera de log no estandar: {line}"))


def main() -> int:
    findings: list[Finding] = []
    check_required_paths(findings)
    check_frontmatter(findings)
    check_links(findings)
    check_duplicate_curated_stems(findings)
    check_log(findings)

    if not findings:
        print("obsidian_lint: OK")
        return 0

    errors = [item for item in findings if item.level == "ERROR"]
    warnings = [item for item in findings if item.level == "WARN"]
    for finding in findings:
        print(f"{finding.level}: {finding.path}: {finding.message}")
    print(f"\nResumen: {len(errors)} error(es), {len(warnings)} aviso(s)")
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
