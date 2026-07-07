#!/usr/bin/env python3
# ==============================================================================
# B:Essential Agentic Harness v4.0 - frontmatter_migrate_v21.py
# ==============================================================================
# 목적: Frontmatter 표준 v2.1(CLAUDE.md §Frontmatter — 3계층 모델)로 일괄 이관.
#   1) 자생 type → 정식 type + subtype 재분류
#   2) status 자유기술 → 통제 어휘 매핑 (버전은 version 키로 분리)
#   3) 금지 키 정리 (created/modified → date *, title → aliases)
#   4) 00_프로젝트_인덱스.md → type: project-index + Tier3 키 골격 주입
# 본문(--- 이후)은 절대 수정하지 않는다. 사용: [--apply] (기본 dry-run)
# ==============================================================================

import re
import sys
from pathlib import Path

VAULT_NAME = "Urban_vault"
SKIP_PARTS = {".obsidian", ".smart-env", ".trash", "_Templates", "04. Archive",
              "Clippings", "codexx", ".auth"}

TYPE_MAP = {  # 자생 type → (정식 type, subtype)
    "evaluation-report": ("query-result", "evaluation-report"),
    "research-loop-detail": ("query-result", "research-loop"),
    "research-loop": ("query-result", "research-loop"),
    "evidence-matrix": ("query-result", "evidence-matrix"),
    "internal-validation": ("query-result", "validation-report"),
    "design-spec": ("query-result", "design-spec"),
    "planning-brief": ("query-result", "planning-brief"),
    "note": ("query-result", "note"),
    "reference": ("query-result", "reference"),
}
STATUS_MAP = {  # 자유기술 status → (통제 어휘, version 또는 None)
    "draft-for-review": ("review", None),
    "claude-final-v1.0": ("final", "v1.0"),
    "v1.0-deck-built": ("final", "v1.0"),
    "integrating": ("draft", None),
    "integrated": ("final", None),
    "merge-source": ("superseded", None),
    "baseline": ("superseded", None),
    "open": ("active", None),
    "snapshot": ("final", None),
}
STATUS_VER_RE = re.compile(r"^.*final-(v[\d.]+)$")  # 예: claude-final-v1.7 → final + version
TIER3_SKELETON = ['program: ""', 'role: ""', 'stage: ""', "owner: Roy",
                  'deadline: ""', 'priority: ""']


def get_val(line: str) -> str:
    return line.split(":", 1)[1].strip().strip('"').strip("'")


def migrate(lines: list[str], is_project_index: bool, log: list[str]) -> list[str] | None:
    out, changed = [], False
    keys = {re.match(r"^([A-Za-z_][\w ]*?):", l).group(1).strip()
            for l in lines if re.match(r"^([A-Za-z_][\w ]*?):", l)}
    title_val = None
    for line in lines:
        m = re.match(r"^([A-Za-z_][\w ]*?):", line)
        key = m.group(1).strip() if m else None

        if key == "type":
            val = get_val(line)
            if is_project_index and val != "project-index":
                out.append("type: project-index")
                changed = True
                log.append(f"type {val} → project-index")
                continue
            if val in TYPE_MAP:
                new_t, sub = TYPE_MAP[val]
                out.append(f"type: {new_t}")
                if "subtype" not in keys:
                    out.append(f"subtype: {sub}")
                changed = True
                log.append(f"type {val} → {new_t}/subtype:{sub}")
                continue
        elif key == "status":
            val = get_val(line)
            vm = STATUS_VER_RE.match(val)
            if vm and val not in STATUS_MAP:
                out.append("status: final")
                if "version" not in keys:
                    out.append(f'version: "{vm.group(1)}"')
                changed = True
                log.append(f"status {val} → final (version {vm.group(1)})")
                continue
            if val in STATUS_MAP:
                new_s, ver = STATUS_MAP[val]
                out.append(f"status: {new_s}")
                if ver and "version" not in keys:
                    out.append(f'version: "{ver}"')
                changed = True
                log.append(f"status {val} → {new_s}" + (f" (version {ver})" if ver else ""))
                continue
        elif key == "created":
            out.append(line.replace("created:", "date created:", 1) if "date created" not in keys
                       else None)
            changed = True
            log.append("created → date created" if "date created" not in keys else "created 제거(중복)")
            out = [l for l in out if l is not None]
            continue
        elif key == "modified":
            if "date modified" not in keys:
                out.append(line.replace("modified:", "date modified:", 1))
                log.append("modified → date modified")
            else:
                log.append("modified 제거(중복)")
            changed = True
            continue
        elif key == "title":
            title_val = get_val(line)
            changed = True
            continue  # 아래에서 aliases 편입
        out.append(line)

    if title_val:
        if "aliases" in keys:
            for i, l in enumerate(out):
                if re.match(r"^aliases:", l):
                    out.insert(i + 1, f'  - "{title_val}"')
                    break
        else:
            out = [f'aliases:\n  - "{title_val}"'] + out
        log.append(f"title '{title_val}' → aliases")

    if is_project_index:
        for item in TIER3_SKELETON:
            k = item.split(":")[0]
            if k not in keys:
                out.append(item)
                changed = True
        if any(item.split(":")[0] not in keys for item in TIER3_SKELETON):
            log.append("Tier3 골격 주입")

    return out if changed else None


def main() -> None:
    apply = "--apply" in sys.argv
    vault = Path(__file__).resolve().parents[2] / VAULT_NAME
    touched = 0
    for p in sorted(vault.rglob("*.md")):
        rel = p.relative_to(vault)
        if any(part in SKIP_PARTS for part in rel.parts):
            continue
        text = p.read_text(encoding="utf-8", errors="replace")
        if not text.startswith("---"):
            continue
        end = text.find("\n---", 3)
        if end == -1:
            continue
        fm_lines = text[4:end].splitlines()
        log: list[str] = []
        new_fm = migrate(fm_lines, p.name == "00_프로젝트_인덱스.md", log)
        if new_fm is None:
            continue
        touched += 1
        print(f"📝 {rel}")
        for entry in log:
            print(f"     · {entry}")
        if apply:
            p.write_text("---\n" + "\n".join(new_fm) + text[end:], encoding="utf-8")
    mode = "APPLY" if apply else "DRY-RUN"
    print(f"\n{'✅' if apply else 'ℹ️ '} [{mode}] 변경 대상 {touched}건" +
          ("" if apply else " — 적용: --apply"))


if __name__ == "__main__":
    main()
