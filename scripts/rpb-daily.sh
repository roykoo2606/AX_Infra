#!/usr/bin/env bash
# 연구기획사업부 데일리 파이프라인 백그라운드 러너
#
# 목적:
#   claudex/Claude Code가 Google Drive 원천을 직접 읽지 못해도,
#   AX_Infra의 상시 서비스(tmux ax / watcher)가 같은 호스트 권한으로
#   스캔→브리프 생성을 수행하게 한다.
#
# 사용:
#   scripts/rpb-daily.sh --once    # 즉시 1회 실행
#   scripts/rpb-daily.sh           # 평일 08:30 KST 반복 실행
#
# 승인 경계:
#   - 로컬/DriveFS 읽기 + 지정 아카이브 data/guidance 갱신까지만 수행
#   - launchd 등록, 네이버웍스/메일 발송, 외부 업로드는 여기서 하지 않는다

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$REPO/logs/system"
LOG_FILE="$LOG_DIR/rpb-daily.log"
LOCK_DIR="$LOG_DIR/rpb-daily.lock"

ARCHIVE="${RPB_ARCHIVE:-/Users/roysmac/Library/CloudStorage/GoogleDrive-roykoo@urbancorp.co.kr/공유 드라이브/U/Urban_AX_Workflow/연구기획_프로젝트_아카이브}"
SOURCE_ACTIVE="${RPB_SOURCE_ACTIVE:-/Users/roysmac/Library/CloudStorage/GoogleDrive-roykoo@urbancorp.co.kr/공유 드라이브/U/2. R&D 사업/2-3. 수행중인 사업}"
RUN_AT="${RPB_DAILY_RUN_AT:-08:30}"
RUN_ON_START="${RPB_RUN_ON_START:-0}"

mkdir -p "$LOG_DIR"

log() {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" | tee -a "$LOG_FILE"
}

require_path() {
  local label="$1" path="$2"
  if [[ ! -e "$path" ]]; then
    log "ERROR: $label 경로 없음: $path"
    return 1
  fi
  if [[ ! -r "$path" ]]; then
    log "ERROR: $label 읽기 권한 없음: $path"
    return 1
  fi
}

with_lock() {
  if ! mkdir "$LOCK_DIR" 2>/dev/null; then
    log "SKIP: 이전 rpb-daily 실행 lock 존재: $LOCK_DIR"
    return 0
  fi
  trap 'rmdir "$LOCK_DIR" 2>/dev/null || true' RETURN
  "$@"
}

run_once() {
  require_path "archive" "$ARCHIVE"
  require_path "source_active" "$SOURCE_ACTIVE"
  require_path "scan_projects.py" "$ARCHIVE/scan_projects.py"
  require_path "generate_brief.py" "$ARCHIVE/generate_brief.py"

  log "START: RPB scan+brief"
  log "ARCHIVE=$ARCHIVE"
  log "SOURCE_ACTIVE=$SOURCE_ACTIVE"

  python3 "$ARCHIVE/scan_projects.py" "$SOURCE_ACTIVE" "$ARCHIVE/data" 2>&1 | tee -a "$LOG_FILE"
  python3 "$ARCHIVE/generate_brief.py" "$ARCHIVE" 2>&1 | tee -a "$LOG_FILE"

  if [[ ! -s "$ARCHIVE/data/projects_data.json" ]]; then
    log "ERROR: projects_data.json 생성/갱신 확인 실패"
    return 1
  fi
  if [[ ! -s "$ARCHIVE/guidance/latest_brief.md" ]]; then
    log "ERROR: latest_brief.md 생성/갱신 확인 실패"
    return 1
  fi

  python3 - <<PY 2>&1 | tee -a "$LOG_FILE"
import json
from pathlib import Path
archive = Path(r'''$ARCHIVE''')
data = json.loads((archive/'data/projects_data.json').read_text(encoding='utf-8'))
brief = archive/'guidance/latest_brief.md'
print('VERIFY: generated_at=', data.get('generated_at'))
print('VERIFY: project_count=', data.get('project_count'), 'total_files=', data.get('total_files'))
print('VERIFY: latest_brief_bytes=', brief.stat().st_size)
PY
  log "DONE: RPB scan+brief"
}

next_run_epoch() {
  python3 - <<PY
from datetime import datetime, timedelta
run_at = '$RUN_AT'
h, m = map(int, run_at.split(':'))
now = datetime.now()
t = now.replace(hour=h, minute=m, second=0, microsecond=0)
if t <= now:
    t += timedelta(days=1)
while t.weekday() >= 5:  # 5=Sat, 6=Sun
    t += timedelta(days=1)
print(int(t.timestamp()))
PY
}

main_loop() {
  log "LOOP: RPB daily watcher started (weekday $RUN_AT, RUN_ON_START=$RUN_ON_START)"
  if [[ "$RUN_ON_START" == "1" ]]; then
    with_lock run_once || log "ERROR: startup run failed"
  fi
  while true; do
    target="$(next_run_epoch)"
    now="$(date +%s)"
    sleep_for=$(( target - now ))
    if (( sleep_for < 1 )); then sleep_for=1; fi
    log "SLEEP: next run at $(date -r "$target" '+%Y-%m-%d %H:%M:%S') (${sleep_for}s)"
    sleep "$sleep_for"
    with_lock run_once || log "ERROR: scheduled run failed"
  done
}

case "${1:-}" in
  --once)
    with_lock run_once
    ;;
  --help|-h)
    sed -n '1,32p' "$0"
    ;;
  *)
    main_loop
    ;;
esac
