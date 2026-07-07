#!/usr/bin/env python3
# ==============================================================================
# B:Essential Agentic Harness v4.1 - graph_export.py
# ==============================================================================
# 목적: Urban_vault의 frontmatter(CLAUDE.md v3.0 Tier 4)를 온톨로지 그래프로 추출한다.
#   노드 = entityClass 있는 노트(엔티티) + about/관계로 참조된 대상
#   엣지 = 관계 키(participatesIn, fundedBy, partnerOf, employedBy, allocatedTo,
#           managesProject, hasPI, hasContact, settledBy, usesSystem) + about
# 출력: docs/model_runs 밖의 안정 경로 → Urban_vault/02. Areas/어반데이터랩_전사_온톨로지/_graph/
#   graph.json (노드/엣지) + graph_summary.md (통계·dangling 리포트)
# Data Foundry(AGE/Neo4j) 적재의 결정적 소스. 민감 클래스는 스키마·린터가 이미 배제.
# 사용: python3 graph_export.py [--write]   (기본 stdout 요약만)
# ==============================================================================

import json
import re
import sys
from collections import Counter, defaultdict
from datetime import date
from pathlib import Path

VAULT = Path(__file__).resolve().parents[2] / "vault"  # AX_Infra
OUT_DIR = VAULT / "02. Areas" / "어반데이터랩_전사_온톨로지" / "_graph"
SKIP = {".obsidian", ".smart-env", ".trash", "04. Archive", "_Templates"}
RELATIONS = ["employedBy", "allocatedTo", "managesProject", "hasPI", "hasContact",
             "participatesIn", "fundedBy", "settledBy", "usesSystem", "partnerOf"]
WIKILINK = re.compile(r"\[\[([^\]|#^]+)")


def parse_fm(text: str):
    if not text.startswith("---"):
        return None, None
    end = text.find("\n---", 3)
    if end == -1:
        return None, None
    return text[4:end], end


def collect_list(block: str, key: str):
    """frontmatter 블록에서 key: 의 인라인/리스트 wikilink 값을 모은다."""
    vals, capture = [], False
    for line in block.splitlines():
        m = re.match(r"^([A-Za-z_][\w ]*?):(.*)$", line)
        if m:
            k = m.group(1).strip()
            if k == key:
                capture = True
                inline = m.group(2).strip()
                if inline:
                    vals += [w.strip() for w in WIKILINK.findall(inline)]
                continue
            capture = False
        if capture and line.lstrip().startswith("-"):
            vals += [w.strip() for w in WIKILINK.findall(line)]
    return vals


def scalar(block: str, key: str) -> str:
    for line in block.splitlines():
        m = re.match(rf"^{re.escape(key)}:\s*(.*)$", line)
        if m:
            return m.group(1).strip().strip('"').strip("'")
    return ""


def main() -> None:
    write = "--write" in sys.argv
    nodes = {}          # name -> {class, businessKey, path}
    edges = []          # {from, to, rel}
    referenced = set()

    for p in sorted(VAULT.rglob("*.md")):
        rel = p.relative_to(VAULT)
        if any(part in SKIP for part in rel.parts):
            continue
        block, _ = parse_fm(p.read_text(encoding="utf-8", errors="replace"))
        if block is None:
            continue
        name = p.stem
        ec = scalar(block, "entityClass")
        if ec:
            nodes[name] = {"class": ec, "businessKey": scalar(block, "businessKey"),
                           "path": str(rel)}
        # about (문서→엔티티)
        for tgt in collect_list(block, "about"):
            edges.append({"from": name, "to": tgt, "rel": "about"})
            referenced.add(tgt)
        # 온톨로지 관계
        for r in RELATIONS:
            for tgt in collect_list(block, r):
                edges.append({"from": name, "to": tgt, "rel": r})
                referenced.add(tgt)

    dangling = sorted(t for t in referenced if t not in nodes)
    cls_count = Counter(n["class"] for n in nodes.values())
    rel_count = Counter(e["rel"] for e in edges)
    deg = defaultdict(int)
    for e in edges:
        deg[e["from"]] += 1
        if e["to"] in nodes:
            deg[e["to"]] += 1

    print(f"📊 [graph_export] 노드 {len(nodes)} · 엣지 {len(edges)} · dangling {len(dangling)}")
    print("  클래스:", dict(cls_count))
    print("  관계:", dict(rel_count))
    if dangling:
        print(f"  ⚠️ 노드 없는 참조 대상 {len(dangling)}건 (엔티티 승격 후보):")
        for d in dangling:
            print(f"     - {d}")

    if write:
        OUT_DIR.mkdir(parents=True, exist_ok=True)
        graph = {"generated": date.today().isoformat(),
                 "nodes": [{"id": k, **v} for k, v in sorted(nodes.items())],
                 "edges": edges}
        (OUT_DIR / "graph.json").write_text(
            json.dumps(graph, ensure_ascii=False, indent=2), encoding="utf-8")
        top = sorted(deg.items(), key=lambda x: -x[1])[:10]
        lines = [
            "---", "type: query-result", "subtype: dashboard",
            "aliases:", "  - 온톨로지 그래프 요약",
            'description: "Auto-generated ontology graph summary from vault frontmatter (Tier 4 binding). Do not edit by hand — regenerate via graph_export.py."',
            "author:", "  - graph_export",
            f"date created: {date.today()}", f"date modified: {date.today()}",
            "tags:", "  - ontology", "  - graph", "  - generated",
            "status: active", "---", "",
            "# 온톨로지 그래프 요약 (자동 생성)", "",
            f"- 생성일: {date.today()}  ·  노드 **{len(nodes)}**  ·  엣지 **{len(edges)}**  ·  dangling **{len(dangling)}**",
            "", "## 클래스 분포",
            *[f"- `{c}`: {n}" for c, n in cls_count.most_common()],
            "", "## 관계 분포",
            *[f"- `{r}`: {n}" for r, n in rel_count.most_common()],
            "", "## 연결 상위 노드",
            *[f"- [[{k}]] — degree {d}" for k, d in top],
        ]
        if dangling:
            lines += ["", "## ⚠️ 엔티티 승격 후보 (참조되나 노드 없음)",
                      *[f"- {d}" for d in dangling]]
        lines += ["", "## Related", "- [[00_온톨로지_스키마]] · [[60_관계_그래프]]"]
        (OUT_DIR / "graph_summary.md").write_text("\n".join(lines), encoding="utf-8")
        print(f"✅ 저장: {OUT_DIR.relative_to(VAULT)}/graph.json, graph_summary.md")


if __name__ == "__main__":
    main()
