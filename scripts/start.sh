#!/bin/bash
# AX_Infra 상시 서비스 세션 (최종 구조, 2026-07-07)
#
#   tmux(ax)  = 무인 상시 서비스: watcher(감시). hermes 게이트웨이는 launchd 담당
#               재부팅 시 launchd가 이 스크립트를 자동 실행
#   cmux      = 인터랙티브 에이전트: 패인에서 claudex / codexx / agyx 직접 실행
#               cmux 재시작 시 레이아웃+세션 자동 복원 (1회 설정: cmux hooks setup)
#
# 사용법:  시작 scripts/start.sh | 보기 scripts/view.sh watcher | 종료 tmux kill-session -t ax

SESSION="ax"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

if ! command -v tmux >/dev/null; then
  echo "[ax] tmux가 없습니다. 설치: brew install tmux"
  exit 1
fi

if tmux has-session -t "$SESSION" 2>/dev/null; then
  echo "[ax] 서비스 세션이 이미 실행 중입니다"
  exit 0
fi

# hermes 는 launchd(ai.hermes.gateway, keepalive+runatload)가 관리한다.
# 여기서 또 띄우면 "Gateway already running"으로 5초마다 실패하며 로그만 채운다.
tmux new-session -d -s "$SESSION" -n watcher -c "$ROOT"

boot() {
  tmux send-keys -t "$SESSION:$1" \
    "clear; echo '── [$1] $2 ──'; $3" C-m
}
boot watcher "감시 자동화 — 이벤트 스크립트 supervisor" \
     "'$ROOT/scripts/watcher.sh'"

echo "[ax] 상시 서비스 시작됨: watcher"
echo "[ax] hermes 게이트웨이는 launchd 관리 — 상태: hermes gateway status"
