#!/bin/bash
# uraxx — Urban_AX 마스터 관제 화면 (어반데이터랩 전사 AX)
#
#   ┌─────────────┬─────────────┐
#   │  claudex    │   agyx      │   왼쪽: 오케스트레이터·설계 (메인)
#   │  (메인)      ├─────────────┤   우상: 수집·파싱·감시 워커
#   │             │   codexx    │   우하: 구현·반복작업 워커
#   └─────────────┴─────────────┘
#
# 사용법 (cmux 빈 패인에서):
#   uraxx           마스터(projects/Urban_AX) 기준 관제
#   uraxx weekly    서브: urban-weekly-dashboard
#   uraxx rpb       서브: rpb-ax
#   uraxx mig       서브: urban-ax-migration
# 패인 ID는 추측하지 않고 분할 전후 목록 비교로 확정한다.
set -uo pipefail
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:/usr/local/bin:${PATH:-}"

[ -n "${CMUX_SURFACE_ID:-}" ] || { echo "cmux 터미널 안에서 실행하세요."; exit 1; }

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
case "${1:-}" in
  "")      PROJ="$ROOT";                          LABEL="Urban_AX 마스터" ;;
  weekly)  PROJ="$ROOT/urban-weekly-dashboard";   LABEL="주간보고 대시보드" ;;
  rpb)     PROJ="$ROOT/rpb-ax";                   LABEL="RPB 파이프라인" ;;
  mig)     PROJ="$ROOT/urban-ax-migration";       LABEL="vault 이관" ;;
  *) echo "사용법: uraxx [weekly|rpb|mig]"; exit 1 ;;
esac
[ -d "$PROJ" ] || { echo "폴더 없음: $PROJ"; exit 1; }

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
send "$ME"         "clear; cd '$PROJ'; echo '$LABEL / claudex — 설계·조율'; claudex"
sleep 0.4
# ④ 우상 — agyx 수집·파싱
send "$RIGHT"      "clear; cd '$PROJ'; echo '$LABEL / agyx — 수집·파싱·감시'; agyx"
sleep 0.4
# ⑤ 우하 — codexx 구현
send "$RIGHT_DOWN" "clear; cd '$PROJ'; echo '$LABEL / codexx — 구현·반복'; codexx"

echo "uraxx 레이아웃 구성 완료 — $LABEL ($PROJ)"
echo "  왼쪽 claudex($ME) · 우상 agyx($RIGHT) · 우하 codexx($RIGHT_DOWN)"
