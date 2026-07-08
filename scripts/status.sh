#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TASKS="$REPO/TASKS.md"
STATUS="$REPO/STATUS.md"
LOG_DIR="$REPO/logs"

# Check whether the shared ax tmux session exists.
if tmux ls 2>/dev/null | grep -q '^ax:'; then
  HERMES_STATUS="● 가동"
  WATCHER_STATUS="● 가동"
else
  HERMES_STATUS="○ 중단"
  WATCHER_STATUS="○ 중단"
fi

# Count table rows between two markdown section headers.
count_task_rows() {
  local start_header="$1"
  local end_header="$2"

  awk -v start="$start_header" -v end="$end_header" '
    $0 == start { in_section = 1; next }
    $0 == end { in_section = 0 }
    in_section && /^\|/ && $0 !~ /^\|[[:space:]]*ID[[:space:]]*\|/ && $0 !~ /^\|[-[:space:]|]+\|?$/ {
      count++
    }
    END { print count + 0 }
  ' "$TASKS"
}

# Extract ID and title from the in-progress task table.
list_in_progress_tasks() {
  awk '
    $0 == "## 진행 중" { in_section = 1; next }
    $0 == "## 대기" { in_section = 0 }
    in_section && /^\|/ && $0 !~ /^\|[[:space:]]*ID[[:space:]]*\|/ && $0 !~ /^\|[-[:space:]|]+\|?$/ {
      line = $0
      sub(/^\|/, "", line)
      sub(/\|$/, "", line)
      n = split(line, fields, "|")
      if (n >= 2) {
        id = fields[1]
        task = fields[2]
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", id)
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", task)
        print "- " id ": " task
      }
    }
  ' "$TASKS"
}

IN_PROGRESS_COUNT="$(count_task_rows "## 진행 중" "## 대기")"
WAITING_COUNT="$(count_task_rows "## 대기" "## 완료 (최근 10건만 유지 — 상세는 logs/)")"
IN_PROGRESS_LIST="$(list_in_progress_tasks)"
if [[ -z "$IN_PROGRESS_LIST" ]]; then
  IN_PROGRESS_LIST="- (없음)"
fi

RECENT_LOGS="$(find "$LOG_DIR" -maxdepth 1 -type f -name '????-??-??_*.md' -exec basename {} \; 2>/dev/null | sort -r | head -n 5 || true)"

{
  printf '# STATUS — AX_Infra\n'
  printf '> 생성: %s (scripts/status.sh 자동 생성)\n' "$(date '+%Y-%m-%d %H:%M')"
  printf '\n'
  printf '## 서비스 (tmux ax)\n'
  printf -- '- hermes: %s\n' "$HERMES_STATUS"
  printf -- '- watcher: %s\n' "$WATCHER_STATUS"
  printf '\n'
  printf '## 작업 (TASKS.md 기준)\n'
  printf -- '- 진행 중: %s건\n' "$IN_PROGRESS_COUNT"
  printf -- '- 대기: %s건\n' "$WAITING_COUNT"
  printf '### 진행 중 목록\n'
  printf '%s\n' "$IN_PROGRESS_LIST"
  printf '\n'
  printf '## 최근 로그\n'
  if [[ -n "$RECENT_LOGS" ]]; then
    while IFS= read -r log_file; do
      printf -- '- %s\n' "$log_file"
    done <<< "$RECENT_LOGS"
  fi
  printf '\n'
  printf '## 검증 대기\n'
  printf -- '- 맥 재부팅 풀사이클\n'
  printf -- '- bootstrap.sh 타머신 검증\n'
} > "$STATUS"

echo "STATUS.md 생성 완료: $REPO/STATUS.md"
