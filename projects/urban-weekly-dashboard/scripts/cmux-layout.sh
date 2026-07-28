#!/bin/bash
# uraxx — 어반데이터랩 주간회의 대시보드 전용 관제 화면
#
#   ┌─────────────┬─────────────┐
#   │  claudex    │   agyx      │   왼쪽: 설계·조립 (메인)
#   │  (메인)      ├─────────────┤   우상: 수집·파싱 상시 담당
#   │             │   codexx    │   우하: 대시보드 구현
#   └─────────────┴─────────────┘
#
# 사용법: cmux의 빈 패인에서 `uraxx`
# 패인 ID는 추측하지 않고 분할 전후 목록 비교로 확정한다.
set -uo pipefail
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:/usr/local/bin:${PATH:-}"

[ -n "${CMUX_SURFACE_ID:-}" ] || { echo "cmux 터미널 안에서 실행하세요."; exit 1; }

PROJ="$(cd "$(dirname "$0")/.." && pwd)"
ME="$CMUX_SURFACE_ID"

list_ids() {
  cmux list-panels 2>/dev/null | grep -oE 'surface:[0-9]+' | sort -u
}
new_of() { comm -13 <(printf '%s\n' "$1") <(list_ids) | sort -t: -k2 -n | tail -1; }

# ① 오른쪽 패널
B1="$(list_ids)"
cmux new-split right >/dev/null 2>&1; sleep 0.6
RIGHT="$(new_of "$B1")"
[ -z "$RIGHT" ] && { echo "우측 패인 탐지 실패 — cmux list-panels 확인"; exit 1; }

# ② 오른쪽을 위/아래로 분할
B2="$(list_ids)"
cmux new-split down --panel "$RIGHT" >/dev/null 2>&1; sleep 0.6
RIGHT_DOWN="$(new_of "$B2")"
[ -z "$RIGHT_DOWN" ] && { echo "우하 패인 탐지 실패"; exit 1; }

send() {  # send <surface> <명령>
  cmux send --surface "$1" "$2" >/dev/null 2>&1
  cmux send-key --surface "$1" enter >/dev/null 2>&1
}

# ③ 왼쪽(현재) — claudex 메인
send "$ME"         "clear; cd '$PROJ'; echo '주간회의 대시보드 / claudex — 설계·조립'; claudex"
sleep 0.4
# ④ 우상 — agyx 수집·파싱
send "$RIGHT"      "clear; cd '$PROJ'; echo '주간회의 대시보드 / agyx — 수집·파싱'; agyx"
sleep 0.4
# ⑤ 우하 — codexx 구현
send "$RIGHT_DOWN" "clear; cd '$PROJ'; echo '주간회의 대시보드 / codexx — 대시보드 구현'; codexx"

echo "uraxx 레이아웃 구성 완료 — $PROJ"
echo "  왼쪽 claudex($ME) · 우상 agyx($RIGHT) · 우하 codexx($RIGHT_DOWN)"
