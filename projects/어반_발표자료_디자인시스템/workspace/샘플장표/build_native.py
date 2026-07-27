#!/usr/bin/env python3
"""Sample data slide, built natively (editable shapes/text/table).

Content source: 공간바이오마커_중간보고회_v0.5 (2026-07-27)
Layout source:  output/design.md §5 grid, §6.7 kpi-tile, §6.8 data-table, §10.1 골격
"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[4] / "scripts"))
from pptx.enum.text import MSO_ANCHOR, PP_ALIGN  # noqa: E402
from udl_pptx import Deck, T, CANVAS_W  # noqa: E402

L, R = 78, 70                      # design.md §5 safe area
CONTENT_W = CANVAS_W - L - R       # 1452
GAP = 24
COL = (CONTENT_W - GAP * 2) / 3    # three span-4 tiles

KPIS = [
    ("수집 이미지", "6,122", "건", "계약 요건 3,000건 대비 204% · 3개 조직 각 1,000건 충족", False),
    ("1차 어노테이션", "5,959", "건", "수집 대비 97.3% 완료", False),
    ("전문의 정밀 리뷰", "1,624", "건", "어노테이션 대비 27.3% · 하반기 최우선 과제", True),
]

TABLE = [
    ["구분", "위암 (STOP)", "전립선암 (PROP)", "난소암 (OVCA)", "계"],
    ["수집 이미지", "1,037", "3,556", "1,529", "6,122"],
    ["1차 어노테이션", "1,024", "3,556", "1,379", "5,959"],
    ["전문의 리뷰", "207", "852", "565", "1,624"],
]


def build(s):
    c = s.c

    # left edge — brand gradient (design.md §6 edge)
    s.gradient(0, 0, 6, 900, [(0.0, T.MINT), (1.0, T.PURPLE)], angle=90)

    # meta bar — y=54, h=24
    s.text(L, 54, 700, 24, "URBAN DATA LAB", T.META, color=c["text2"],
           weight=700, secondary=True)
    s.text(L, 54, CONTENT_W, 24, "2026 질병관리청 공간전사체 · 2차년도 중간보고",
           T.META, color=c["text3"], align=PP_ALIGN.RIGHT, secondary=True)

    # title band — y=126
    s.text(L, 126, CONTENT_W, 22, "DATA COLLECTION & ANNOTATION",
           T.EYEBROW, color=T.BLUE)
    s.text(L, 160, CONTENT_W, 56, [
        ("계약 기준 3,000건의 ", None, None),
        ("2배", T.MINT, None),
        ("를 확보했고, 1차 가공은 97% 완료했습니다", None, None),
    ], T.H2, color=c["text"])

    # KPI tiles — y=286, h=180
    for i, (label, value, unit, note, watch) in enumerate(KPIS):
        x = L + i * (COL + GAP)
        s.rect(x, 286, COL, 180, fill=c["surface"],
               line=T.ACCENT if watch else c["border"],
               line_w=2 if watch else 1, radius=14)
        s.text(x + 24, 310, COL - 48, 20, label, T.CAPTION,
               color=c["text2"], secondary=True)
        s.text(x + 24, 348, COL - 48, 62, [
            (value, None, None),
            (unit, T.ACCENT if watch else T.MINT, None),
        ], T.KPI, color=c["text"])
        if watch:                                   # accent underline on the bottleneck
            s.line(x + 24, 414, 168, T.ACCENT, thickness=5)
        s.text(x + 24, 424, COL - 48, 34, note, T.CAPTION, color=c["text3"])

    # data table — y=490, 4 rows x 64px
    s.table(L, 490, CONTENT_W, 256, TABLE,
            col_widths=[CONTENT_W * 0.28] + [CONTENT_W * 0.18] * 4)

    # footer — y=816
    s.line(L, 816, CONTENT_W, c["grid"])
    s.text(L, 830, 1100, 20,
           "출처: 공간바이오마커_중간보고회_v0.5 (2026-07-27) · 계약 기준은 제안요청서",
           T.META, color=c["text3"], secondary=True)
    s.text(L, 830, CONTENT_W, 20, "03", T.META, color=c["text3"],
           align=PP_ALIGN.RIGHT, secondary=True)


if __name__ == "__main__":
    deck = Deck()
    for theme in ("dark", "light"):
        build(deck.slide(theme))
    out = deck.save("샘플장표_데이터_네이티브_v1.pptx")
    print("생성 완료:", out)
