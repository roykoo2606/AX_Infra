#!/bin/bash
# 로그 로테이션 — 상시 서비스 로그가 무한히 커지는 것을 막는다.
#
# hermes 게이트웨이 오류 로그는 Discord 재연결 실패 시 초당 여러 줄을 쏟아낸다.
# 2026-07-29 점검 시 gateway.error.log 가 1.9MB / DNS 오류 684건이었다.
#
# 사용: scripts/rotate-logs.sh          (임계치 초과분만 회전)
#       scripts/rotate-logs.sh --force  (크기 무관 전부 회전)
set -uo pipefail
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:${PATH:-}"

MAX_BYTES=${LOG_MAX_BYTES:-2097152}   # 2MB
KEEP=${LOG_KEEP:-3}                   # 세대 보관 수
FORCE=0
[ "${1:-}" = "--force" ] && FORCE=1

TARGETS=(
  "$HOME/.hermes/logs/gateway.log"
  "$HOME/.hermes/logs/gateway.error.log"
  "$HOME/Claude/Projects/AX_Infra/logs/system/watcher.log"
  "$HOME/Claude/Projects/AX_Infra/logs/system/rpb-daily.log"
)

rotated=0
for f in "${TARGETS[@]}"; do
  [ -f "$f" ] || continue
  size=$(stat -f%z "$f" 2>/dev/null || echo 0)
  if [ "$FORCE" -eq 0 ] && [ "$size" -lt "$MAX_BYTES" ]; then
    continue
  fi
  for ((i=KEEP-1; i>=1; i--)); do
    [ -f "$f.$i" ] && mv -f "$f.$i" "$f.$((i+1))"
  done
  cp "$f" "$f.1"
  : > "$f"          # truncate in place — 실행 중인 프로세스의 파일 핸들을 유지한다
  echo "회전: $(basename "$f")  ($((size/1024))KB → 0, 이전본 .1)"
  rotated=$((rotated+1))
done

[ "$rotated" -eq 0 ] && echo "회전 대상 없음 (임계치 $((MAX_BYTES/1024))KB)"
exit 0
