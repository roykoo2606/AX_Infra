#!/bin/bash
# AX_Infra 표준 세션 (Phase 2) — tmux 세션 하나에 에이전트 창 4개
#
# 사용법 (3줄이면 끝):
#   시작:  scripts/start.sh          # 이미 실행 중이면 그대로 둠 (재실행 안전)
#   접속:  tmux attach -t ax         # cmux 패인에서는: tmux attach -t ax:<창이름>
#   종료:  tmux kill-session -t ax
#
# 창 구성: claude(오케스트레이터) / codex(워커) / anti(워커) / watcher(감시, Phase 5)
# cmux 사용: cmux에서 패인 4개로 분할(new-split) 후 각 패인에서 위 attach 명령 입력

SESSION="ax"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if ! command -v tmux >/dev/null; then
  echo "[ax] tmux가 없습니다. 설치: brew install tmux"
  exit 1
fi

if tmux has-session -t "$SESSION" 2>/dev/null; then
  echo "[ax] 세션이 이미 실행 중입니다 → tmux attach -t ax"
  exit 0
fi

tmux new-session -d -s "$SESSION" -n claude  -c "$ROOT"
tmux new-window  -t "$SESSION"    -n codex   -c "$ROOT"
tmux new-window  -t "$SESSION"    -n anti    -c "$ROOT"
tmux new-window  -t "$SESSION"    -n watcher -c "$ROOT"

# 각 창: 역할 배너 → 에이전트 CLI가 설치돼 있으면 자동 실행
boot() {
  tmux send-keys -t "$SESSION:$1" \
    "clear; echo '── [$1] $2 ──'; $3" C-m
}
boot claude  "오케스트레이터·메인 작업 (Claude Code)" \
     "command -v claude >/dev/null && claude || echo 'claude CLI 미설치 → npm install -g @anthropic-ai/claude-code'"
boot codex   "단순작업 워커 (Codex)" \
     "command -v codex >/dev/null && codex || echo 'codex CLI 미설치 → npm install -g @openai/codex'"
boot anti    "단순작업 워커 (Antigravity)" \
     "command -v antigravity >/dev/null && antigravity || echo 'antigravity CLI 미설치 — 설치 후 이 창에서 직접 실행'"
boot watcher "감시 자동화 — Phase 5에서 구성" \
     "echo '대기 중 (Phase 5: GDrive 감시)'"

tmux select-window -t "$SESSION:claude"
echo "[ax] 세션 시작됨: claude / codex / anti / watcher"
echo "     접속: tmux attach -t ax"
