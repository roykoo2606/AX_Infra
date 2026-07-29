#!/usr/bin/env bash
# AX_Infra watcher supervisor
#
# watcher는 단일 이벤트 스크립트가 아니라, AX_Infra의 모든 백그라운드
# 이벤트/감시 스크립트를 관리하는 상위 supervisor다.
#
# 현재 관리 대상:
#   - rpb-daily: 연구기획사업부 스캔→브리프 평일 08:30 실행
#
# 추가 원칙:
#   1. 새 이벤트 스크립트는 여기의 SERVICES에 등록한다.
#   2. 각 서비스는 자기 log/lock을 가진다.
#   3. 한 서비스가 죽어도 watcher는 계속 돌고 해당 서비스만 재시작한다.
#   4. 외부 발송/launchd 변경/비용 발생 작업은 이 파일에 바로 넣지 말고 승인 후 별도 서비스로 추가한다.

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$REPO/logs/system"
LOG_FILE="$LOG_DIR/watcher.log"
mkdir -p "$LOG_DIR"

# name|command|restart_delay_seconds
# rpb-daily moved to the Urban_AX root (2026-07-28); its logs live there too.
SERVICES=(
  "rpb-daily|RPB_RUN_ON_START=${RPB_RUN_ON_START:-0} '/Users/roysmac/Urban_AX/scripts/rpb-daily.sh'|10"
  # 상시 서비스 로그가 무한히 커지지 않도록 6시간마다 임계치 초과분만 회전
  "log-rotate|while true; do '/Users/roysmac/Claude/Projects/AX_Infra/scripts/rotate-logs.sh' >/dev/null 2>&1; sleep 21600; done|60"
)

log() {
  printf '[%s] [watcher] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" | tee -a "$LOG_FILE"
}

PIDS=()
NAMES=()

stop_all() {
  log "STOP: stopping ${#PIDS[@]} child service(s)"
  for pid in "${PIDS[@]:-}"; do
    if kill -0 "$pid" 2>/dev/null; then
      kill "$pid" 2>/dev/null || true
    fi
  done
  wait 2>/dev/null || true
}
start_service() {
  local name="$1" cmd="$2"
  log "START: $name -> $cmd"
  bash -lc "$cmd" &
  local pid=$!
  PIDS+=("$pid")
  NAMES+=("$name")
  log "PID: $name=$pid"
}

start_all() {
  for spec in "${SERVICES[@]}"; do
    IFS='|' read -r name cmd delay <<< "$spec"
    start_service "$name" "$cmd"
  done
}

remove_pid_at() {
  local idx="$1"
  local new_pids=()
  local new_names=()
  for i in "${!PIDS[@]}"; do
    if [[ "$i" != "$idx" ]]; then
      new_pids+=("${PIDS[$i]}")
      new_names+=("${NAMES[$i]}")
    fi
  done
  if ((${#new_pids[@]})); then
    PIDS=("${new_pids[@]}")
    NAMES=("${new_names[@]}")
  else
    PIDS=()
    NAMES=()
  fi
}

restart_loop() {
  trap 'stop_all; exit 0' INT TERM
  log "LOOP: watcher supervisor started (${#SERVICES[@]} service(s))"
  start_all

  while true; do
    if ((${#PIDS[@]} == 0)); then
      log "WARN: no child services alive; restarting all after 10s"
      sleep 10
      start_all
      continue
    fi

    # Bash on macOS supports wait -n only on newer bash? /bin/bash is old.
    # Poll instead for portability.
    sleep 5
    for i in "${!PIDS[@]}"; do
      local_pid="${PIDS[$i]}"
      local_name="${NAMES[$i]}"
      if ! kill -0 "$local_pid" 2>/dev/null; then
        wait "$local_pid" 2>/dev/null || status=$?
        status="${status:-unknown}"
        log "EXIT: $local_name pid=$local_pid status=$status"
        remove_pid_at "$i"

        # Find service spec and restart only that service.
        for spec in "${SERVICES[@]}"; do
          IFS='|' read -r name cmd delay <<< "$spec"
          if [[ "$name" == "$local_name" ]]; then
            log "RESTART: $name after ${delay}s"
            sleep "$delay"
            start_service "$name" "$cmd"
            break
          fi
        done
        break
      fi
    done
  done
}

case "${1:-}" in
  --list)
    printf '%s\n' "${SERVICES[@]}"
    ;;
  --help|-h)
    sed -n '1,36p' "$0"
    ;;
  *)
    restart_loop
    ;;
esac
