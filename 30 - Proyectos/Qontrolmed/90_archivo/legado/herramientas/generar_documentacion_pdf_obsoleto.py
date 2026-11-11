from pathlib import Path
import html
import re

from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.lib.units import cm
from reportlab.platypus import (
    SimpleDocTemplate,
    Paragraph,
    Spacer,
    Preformatted,
    PageBreak,
)


ROOT = Path(__file__).resolve().parent
SRC = ROOT / "documentacion_tecnica_compras_quirofanos.md"
OUT = ROOT / "documentacion_tecnica_compras_quirofanos.pdf"


def _footer(canvas, doc):
    canvas.saveState()
    canvas.setFont("Helvetica", 8)
    canvas.setFillColor(colors.grey)
    canvas.drawString(1.8 * cm, 1.1 * cm, "Documentacion tecnica - Compras y Quirofanos")
    canvas.drawRightString(A4[0] - 1.8 * cm, 1.1 * cm, f"Pagina {doc.page}")
    canvas.restoreState()


def _inline(text: str) -> str:
    escaped = html.escape(text)
    escaped = re.sub(r"`([^`]+)`", r"<font face='Courier'>\1</font>", escaped)
    escaped = re.sub(r"\*\*([^*]+)\*\*", r"<b>\1</b>", escaped)
    return escaped


def build_story(markdown: str):
    styles = getSampleStyleSheet()
    styles.add(
        ParagraphStyle(
            name="DocTitle",
            parent=styles["Title"],
            fontName="Helvetica-Bold",
            fontSize=20,
            leading=24,
            spaceAfter=14,
            textColor=colors.HexColor("#1f3b5b"),
        )
    )
    styles.add(
        ParagraphStyle(
            name="H1Custom",
            parent=styles["Heading1"],
            fontName="Helvetica-Bold",
            fontSize=15,
            leading=18,
            spaceBefore=12,
            spaceAfter=7,
            textColor=colors.HexColor("#1f3b5b"),
        )
    )
    styles.add(
        ParagraphStyle(
            name="H2Custom",
            parent=styles["Heading2"],
            fontName="Helvetica-Bold",
            fontSize=12,
            leading=15,
            spaceBefore=8,
            spaceAfter=5,
            textColor=colors.HexColor("#2c587f"),
        )
    )
    styles.add(
        ParagraphStyle(
            name="BodyCustom",
            parent=styles["BodyText"],
            fontName="Helvetica",
            fontSize=9,
            leading=12,
            spaceAfter=5,
        )
    )
    styles.add(
        ParagraphStyle(
            name="BulletCustom",
            parent=styles["BodyText"],
            fontName="Helvetica",
            fontSize=9,
            leading=12,
            leftIndent=14,
            firstLineIndent=-8,
            spaceAfter=3,
        )
    )
    styles.add(
        ParagraphStyle(
            name="Meta",
            parent=styles["BodyText"],
            fontName="Helvetica",
            fontSize=9,
            leading=12,
            textColor=colors.HexColor("#444444"),
            spaceAfter=3,
        )
    )

    story = []
    in_code = False
    code_lines = []

    def flush_code():
        nonlocal code_lines
        if code_lines:
            story.append(
                Preformatted(
                    "\n".join(code_lines),
                    ParagraphStyle(
                        name="CodeBlock",
                        fontName="Courier",
                        fontSize=7,
                        leading=9,
                        backColor=colors.HexColor("#f4f6f8"),
                        borderColor=colors.HexColor("#d9dee4"),
                        borderWidth=0.5,
                        borderPadding=5,
                        spaceBefore=4,
                        spaceAfter=7,
                    ),
                )
            )
            code_lines = []

    for raw in markdown.splitlines():
        line = raw.rstrip()

        if line.startswith("```"):
            if in_code:
                flush_code()
                in_code = False
            else:
                in_code = True
            continue

        if in_code:
            code_lines.append(line)
            continue

        if not line:
            story.append(Spacer(1, 3))
            continue

        if line.startswith("# "):
            story.append(Paragraph(_inline(line[2:]), styles["DocTitle"]))
            continue

        if line.startswith("## "):
            title = line[3:]
            if title.startswith("7. "):
                story.append(PageBreak())
            story.append(Paragraph(_inline(title), styles["H1Custom"]))
            continue

        if line.startswith("### "):
            story.append(Paragraph(_inline(line[4:]), styles["H2Custom"]))
            continue

        if line.startswith("- "):
            story.append(Paragraph("• " + _inline(line[2:]), styles["BulletCustom"]))
            continue

        match = re.match(r"^(\d+)\.\s+(.*)$", line)
        if match:
            story.append(
                Paragraph(f"{match.group(1)}. {_inline(match.group(2))}", styles["BulletCustom"])
            )
            continue

        if line.startswith("Fecha de revision:") or line.startswith("Proyecto:") or line.startswith("Alcance:"):
            story.append(Paragraph(_inline(line), styles["Meta"]))
            continue

        story.append(Paragraph(_inline(line), styles["BodyCustom"]))

    flush_code()
    return story


def main():
    markdown = SRC.read_text(encoding="utf-8")
    doc = SimpleDocTemplate(
        str(OUT),
        pagesize=A4,
        rightMargin=1.7 * cm,
        leftMargin=1.7 * cm,
        topMargin=1.6 * cm,
        bottomMargin=1.7 * cm,
        title="Documentacion tecnica Compras y Quirofanos",
        author="Codex",
    )
    doc.build(build_story(markdown), onFirstPage=_footer, onLaterPages=_footer)
    print(OUT)


if __name__ == "__main__":
    main()
