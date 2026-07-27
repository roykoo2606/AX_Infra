#!/bin/bash
# 창별 독립 화면 접속 (cmux 패인용) — tmux 그룹 세션 사용
# 사용법: scripts/view.sh <창이름>    예) view.sh claude / view.sh hermes
# 원리: ax 세션과 창을 공유하는 별도 세션(view-<창>)을 만들어, 패인마다 다른 창을 볼 수 있게 함

W="${1:?사용법: view.sh <claude|codex|anti|watcher|hermes>}"
S="view-$W"

tmux has-session -t ax 2>/dev/null || { echo "[ax] 세션 없음 → scripts/start.sh 먼저 실행"; exit 1; }
tmux has-session -t "$S" 2>/dev/null || tmux new-session -d -t ax -s "$S"
tmux select-window -t "$S:$W"
exec tmux attach -t "$S"
