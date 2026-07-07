#!/usr/bin/env python3
# ==============================================================================
# B:Essential Agentic Harness v4.0 - vault_linter.py
# ==============================================================================
# 목적: Urban_vault(PARA LLM Wiki)의 무결성을 현행 스키마(Urban_vault/CLAUDE.md v2.0)
#       기준으로 기계적으로 검사합니다. 정본 규범: _Policies/00_CONSTITUTION.md
#
# 검사 항목:
#   [ERROR — exit 1]
#     E1. frontmatter 필수 7키 누락 (03. Resources/Wiki, 02. Areas/시스템, 볼트 루트 시스템 문서)
#     E2. log.md 엔트리 포맷 위반 (## [YYYY-MM-DD] <작성자> <유형> | <제목>)
#     E3. index.md에 없는 01. Projects 하위 프로젝트 폴더
#     E4. 볼트 내 비밀 파일 패턴 (token/credential/.auth 등)
#   [WARN — exit 0]
#     W1. 01. Projects frontmatter 필수키 누락 (레거시 다수 → 경고만)
#     W2. 깨진 [[wikilink]] (Wiki/Areas/루트 시스템 문서 범위)
#     W3. Wiki orphan 페이지 (다른 문서에서 한 번도 링크되지 않음)
#     W4. Core Context snapshot_date 30일 초과
# ==============================================================================

import re
import sys
from datetime import date, datetime
from pathlib import Path

VAULT_NAME = "Urban_vault"
REQUIRED_KEYS = ["type", "aliases", "description", "author", "date created", "date modified", "tags"]
TYPE_VOCAB = {"raw-source", "wiki-page", "query-result", "moc", "system", "project-index"}
STATUS_VOCAB = {"active", "draft", "review", "final", "superseded", "archived", "ingested"}
TIER3_KEYS = ["program", "role", "stage", "owner", "deadline", "priority"]
STAGE_VOCAB = {"공고", "파싱", "분석", "원고", "검증", "제출", "종료"}
FORBIDDEN_KEYS = {"created", "modified", "title"}
ENTITY_CLASS_VOCAB = {"Organization", "Person", "GovProject", "SubProject", "Consortium",
                      "System", "Product", "Dataset", "Domain"}
RELATION_KEYS = {"employedBy", "allocatedTo", "managesProject", "hasPI", "hasContact",
                 "participatesIn", "fundedBy", "settledBy", "usesSystem", "partnerOf"}
SENSITIVE_FM_PAT = re.compile(r"(카드번호|계좌번호|password|passwd|주민등록)", re.I)
SKIP_PARTS = {".obsidian", ".smart-env", ".trash", "_Templates", "04. Archive",
              "00. Inbox", "Raw Sources", "TaskNotes", "Clippings", "codexx", ".auth"}
ROOT_SYSTEM_DOCS = {"CLAUDE.md", "Core Context.md", "index.md", "00_의료데이터_검색_운영원칙.md"}
SECRET_PATTERNS = [re.compile(p, re.I) for p in
                   [r"^credentials.*\.json$", r"^token.*\.json$", r".*_token\.json$",
                    r"^oauth.*\.json$", r".*\.pem$", r"^id_rsa.*"]]
LOG_PATTERN = re.compile(r"^## \[\d{4}-\d{2}-\d{2}\] \S+ \S+ \| .+")
WIKILINK = re.compile(r"!?\[\[([^\]|#^]+)")
MAX_SHOW = 25


def skippable(rel: Path) -> bool:
    return any(part in SKIP_PARTS for part in rel.parts)


def parse_frontmatter(text: str) -> dict | None:
    if not text.startswith("---"):
        return None
    end = text.find("\n---", 3)
    if end == -1:
        return None
    fm = {}
    for line in text[3:end].splitlines():
        m = re.match(r"^([A-Za-z_][\w ]*?):", line)
        if m:
            fm[m.group(1).strip()] = line.split(":", 1)[1].strip()
    return fm


def main() -> None:
    project_root = Path(__file__).resolve().parents[2]
    vault = project_root / VAULT_NAME
    if not vault.exists():
        print(f"❌ [Vault Linter] {vault} 가 없습니다. 헌법 §1의 볼트 경로를 확인하세요.")
        sys.exit(1)

    print("🔍 [Vault Linter v4.0] Urban_vault 무결성 검증 시작...")
    errors: list[str] = []
    warns: list[str] = []

    md_files = [p for p in vault.rglob("*.md") if not skippable(p.relative_to(vault))]
    all_md = list(vault.rglob("*.md"))
    all_nodes = {p.stem for p in all_md}

    texts: dict[Path, str] = {}
    for p in md_files:
        try:
            texts[p] = p.read_text(encoding="utf-8", errors="replace")
        except OSError as e:
            warns.append(f"{p.relative_to(vault)}: 읽기 실패 ({e})")

    # E1/W1 frontmatter + W2 broken links
    # log.md: frontmatter 면제(append-only 로그). CLAUDE.md: 링크 검사 면제(스키마 예시 [[link]] 포함).
    linked_targets: set[str] = set()
    for p, text in texts.items():
        rel = p.relative_to(vault)
        strict = (rel.parts[0] in ("02. Areas", "03. Resources") or p.name in ROOT_SYSTEM_DOCS)
        if p.name != "log.md":
            fm = parse_frontmatter(text)
            missing = REQUIRED_KEYS if fm is None else [k for k in REQUIRED_KEYS if k not in fm]
            if missing:
                msg = f"{rel}: frontmatter 누락 {missing}" if fm is not None else f"{rel}: frontmatter 없음"
                (errors if strict else warns).append(("E1 " if strict else "W1 ") + msg)
            if fm is not None:
                # Tier 2 통제 어휘 (CLAUDE.md §Frontmatter v2.1)
                t = fm.get("type", "").strip('"').strip()
                if t and t not in TYPE_VOCAB:
                    (errors if strict else warns).append(
                        (f"E5 " if strict else "W5 ") + f"{rel}: type '{t}' 미허용 — 6종 고정, 세분류는 subtype")
                s = fm.get("status", "").strip('"').strip()
                if s and s not in STATUS_VOCAB:
                    warns.append(f"W6 {rel}: status '{s}' 통제 어휘 위반 (버전은 version 키로)")
                bad = FORBIDDEN_KEYS & fm.keys()
                if bad:
                    warns.append(f"W8 {rel}: 금지 키 {sorted(bad)} (created/modified→date *, title→aliases)")
                # Tier 4 온톨로지 바인딩 (CLAUDE.md v3.0)
                ec = fm.get("entityClass", "").strip('"').strip()
                if ec and ec not in ENTITY_CLASS_VOCAB:
                    warns.append(f"W9 {rel}: entityClass '{ec}' 미허용 (온톨로지 스키마 §1)")
                if "22. Entities" in rel.parts and not ec:
                    warns.append(f"W9 {rel}: 엔티티 노트에 entityClass 없음")
                if SENSITIVE_FM_PAT.search("\n".join(f"{k}: {v}" for k, v in fm.items())):
                    errors.append(f"E6 {rel}: frontmatter에 민감정보 의심 키/값 (Tier4 ⑤ 금지)")
                # Tier 3 워크플로우 계약 (project-index)
                if t == "project-index":
                    t3_missing = [k for k in TIER3_KEYS if not fm.get(k, "").strip('"').strip()]
                    if t3_missing:
                        warns.append(f"W7 {rel}: Tier3 미기입 {t3_missing}")
                    stage = fm.get("stage", "").strip('"').strip()
                    if stage and stage not in STAGE_VOCAB:
                        warns.append(f"W7 {rel}: stage '{stage}' 미허용 (공고~종료 7단계)")
        for target in WIKILINK.findall(text):
            t = target.strip()
            linked_targets.add(t)
            if t and t not in all_nodes and "/" not in t and p.name != "CLAUDE.md":
                warns.append(f"W2 {rel}: broken link [[{t}]]")

    # E2 log.md format
    log_md = vault / "log.md"
    if log_md.exists():
        for i, line in enumerate(log_md.read_text(encoding="utf-8", errors="replace").splitlines(), 1):
            if line.startswith("## ") and not LOG_PATTERN.match(line.strip()):
                errors.append(f"E2 log.md:{i} 포맷 위반: {line.strip()[:80]}")

    # E3 index.md project sync
    index_md = vault / "index.md"
    projects_dir = vault / "01. Projects"
    if index_md.exists() and projects_dir.exists():
        index_text = index_md.read_text(encoding="utf-8", errors="replace")
        for d in sorted(projects_dir.iterdir()):
            if d.is_dir() and not d.name.startswith((".", "_")) and d.name not in index_text:
                errors.append(f"E3 index.md 누락 프로젝트: 01. Projects/{d.name}")

    # E4 secret files in vault (.auth/ 폴더는 gitignore된 로컬 격리 구역으로 예외 —
    #     git 포함 여부는 pre_flight.sh Secret Gate가 차단)
    for p in vault.rglob("*"):
        if p.is_file() and ".auth" not in p.parts and any(pat.match(p.name) for pat in SECRET_PATTERNS):
            errors.append(f"E4 비밀 파일 의심: {p.relative_to(vault)} (헌법 §3-2 — 저장소 밖으로 이동)")

    # W3 orphan wiki pages
    wiki_dir = vault / "03. Resources" / "Wiki"
    if wiki_dir.exists():
        for p in wiki_dir.rglob("*.md"):
            if p.stem not in linked_targets and p.stem != "index":
                warns.append(f"W3 orphan wiki: {p.relative_to(vault)}")

    # W4 Core Context snapshot age
    cc = vault / "Core Context.md"
    if cc.exists():
        m = re.search(r"snapshot_date:\s*(\d{4}-\d{2}-\d{2})", cc.read_text(encoding="utf-8", errors="replace"))
        if m:
            age = (date.today() - datetime.strptime(m.group(1), "%Y-%m-%d").date()).days
            if age > 30:
                warns.append(f"W4 Core Context snapshot_date {age}일 경과 — 갱신 필요")

    def show(title: str, items: list[str]) -> None:
        if not items:
            return
        print(f"\n{title} ({len(items)}건)")
        for it in items[:MAX_SHOW]:
            print(f"   - {it}")
        if len(items) > MAX_SHOW:
            print(f"   … 외 {len(items) - MAX_SHOW}건")

    show("🚨 ERROR", errors)
    show("⚠️  WARN", warns)

    if errors:
        print(f"\n❌ [Vault Linter] 실패 — ERROR {len(errors)}건, WARN {len(warns)}건.")
        sys.exit(1)
    print(f"\n✅ [Vault Linter] 통과 — ERROR 0건, WARN {len(warns)}건.")
    sys.exit(0)


if __name__ == "__main__":
    main()
