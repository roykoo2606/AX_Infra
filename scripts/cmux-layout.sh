#!/bin/bash
# 제로 베이스 관제 화면 구성 v4 (2026-07-07, Roy 확정 순서)
#
# 순서: ① 오른쪽 패널 생성 → ② 오른쪽 패널을 아래로 분할
#       → ③ 왼쪽(첫) 패널 이동, claudex → ④ 우상 이동, agyx → ⑤ 우하 이동, codexx
#
#   ┌─────────────┬─────────────┐
#   │  ③ claude   │  ④ anti     │
#   │   (메인)     ├─────────────┤
#   │             │  ⑤ codex    │
#   └─────────────┴─────────────┘
#
# 사용법: cmux의 빈 패인에서 실행 (alias: axx)
# 패인 ID는 추측하지 않는다 — 분할 전후 list-panels 비교로 확정

[ -n "$CMUX_SURFACE_ID" ] || { echo "cmux 터미널 안에서 실행하세요."; exit 1; }

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
# 상시 서비스(hermes/watcher) 보장 — 실패 시 숨기지 않고 알림
if OUT="$(bash scripts/start.sh 2>&1)"; then
  echo "[서비스] $OUT" | head -1
else
  echo "⚠ tmux 서비스 시작 실패: $OUT"
fi
ME="$CMUX_SURFACE_ID"                           # 왼쪽(첫) 패널 = 지금 여기

list_ids() {
  { cmux list-panels --json --id-format both 2>/dev/null || cmux list-panels 2>/dev/null; } \
  | grep -oE 'surface:[0-9]+|[0-9A-Fa-f]{8}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{4}-[0-9A-Fa-f]{12}' \
  | sort -u
}
new_of() { comm -13 <(printf '%s\n' "$1") <(list_ids) | sort -r | head -1; }

# ① 오른쪽 패널 생성
B1="$(list_ids)"
cmux new-split right; sleep 0.5
RIGHT="$(new_of "$B1")"
[ -z "$RIGHT" ] && { echo "① 우측 패인 ID 탐지 실패 — cmux list-panels --json 출력 확인 필요"; exit 1; }

# ② 오른쪽 패널을 직접 지정해 아래로 분할 (포커스 이동 불필요)
B2="$(list_ids)"
cmux new-split down --surface "$RIGHT"; sleep 0.5
BOTTOM="$(new_of "$B2")"
[ -z "$BOTTOM" ] && echo "② 우하 패인 탐지 실패 — 해당 패인에서 수동: codexx"

# 세션 자동 재개는 cmux 공식 훅이 담당 (1회 설정: cmux hooks setup / codex / antigravity)

# ③ 왼쪽(첫) 패널 → claudex
cmux focus-panel --panel "$ME"; sleep 0.3
cmux send --surface "$ME" "clear; claudex\n"

# ④ 우상 패널 → agyx
cmux send --surface "$RIGHT" "clear; cd $ROOT && agyx\n"

# ⑤ 우하 패널 → codexx
[ -n "$BOTTOM" ] && cmux send --surface "$BOTTOM" "clear; cd $ROOT && codexx\n"

exit 0   # 종료하면 ③에서 예약된 claudex가 이 패널에서 실행된다
