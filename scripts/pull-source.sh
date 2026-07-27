#!/bin/bash
# pull-source.sh — copy a read-only source file into a project's workspace, recording provenance.
#
# Usage: pull-source.sh <project-dir> <path-under-source> [dest-subdir]
#   e.g. pull-source.sh projects/2026_질병청_공간전사체 \
#          "work/04_월간회의/6월/공간 바이오마커_월간회의자료_(6월).pptx" 01_보고
#
# Copies into <project>/workspace/_원본사본/ (or the given subdir) and appends an entry to
# <project>/workspace/_원본사본/_출처.md so every working copy can be traced back to its原本.
set -uo pipefail
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:/usr/local/bin:${PATH:-}"

usage() { sed -n '2,12p' "$0"; exit 1; }
[ $# -ge 2 ] || usage

PROJ="${1%/}"; REL="$2"; SUB="${3:-_원본사본}"
SRC="$PROJ/source/$REL"
DEST_DIR="$PROJ/workspace/$SUB"
LEDGER="$PROJ/workspace/_원본사본/_출처.md"

[ -f "$SRC" ] || { echo "원본을 찾을 수 없습니다: $SRC" >&2; exit 1; }

mkdir -p "$DEST_DIR" "$(dirname "$LEDGER")"
base=$(basename "$REL")
dest="$DEST_DIR/$base"

if [ -e "$dest" ]; then
    stamp=$(date '+%Y%m%d-%H%M')
    dest="$DEST_DIR/${base%.*}_$stamp.${base##*.}"
    echo "같은 이름이 있어 타임스탬프를 붙입니다: $(basename "$dest")"
fi

cp -p "$SRC" "$dest"
hash=$(shasum -a 256 "$SRC" | cut -c1-16)

[ -f "$LEDGER" ] || printf '# 원본 사본 출처 기록\n\n원본은 `source/` (Google Drive 미러)이며 수정하지 않습니다.\n아래는 작업용으로 복사해온 파일의 출처입니다.\n\n| 복사일시 | 작업본 | 원본 경로 | 원본 수정일 | sha256(앞16) |\n|---|---|---|---|---|\n' > "$LEDGER"

printf '| %s | `%s` | `source/%s` | %s | `%s` |\n' \
    "$(date '+%Y-%m-%d %H:%M')" \
    "${dest#"$PROJ"/workspace/}" \
    "$REL" \
    "$(date -r "$SRC" '+%Y-%m-%d')" \
    "$hash" >> "$LEDGER"

echo "복사 완료: $dest"
echo "출처 기록: $LEDGER"
