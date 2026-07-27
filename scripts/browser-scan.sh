#!/bin/bash
# browser-scan.sh — capture one page of a cmux browser surface: screenshot + text + interactive map.
#
# Usage: browser-scan.sh <surface> <out-dir> <slug> [url]
#   With a url, navigates first; without, captures the current page.
# Produces <out-dir>/screens/<slug>.png and <out-dir>/pages/<slug>.md
set -uo pipefail
# cmux panes can hand down a minimal PATH; guarantee core utilities and cmux resolve.
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin:/usr/local/bin:${PATH:-}"
command -v cmux >/dev/null || { echo "cmux not found on PATH" >&2; exit 1; }

SURFACE="$1"; OUT="$2"; SLUG="$3"; URL="${4:-}"
B=(cmux browser --surface "$SURFACE")

mkdir -p "$OUT/screens" "$OUT/pages"

if [ -n "$URL" ]; then
    "${B[@]}" goto "$URL" >/dev/null 2>&1
fi
"${B[@]}" wait --load-state complete --timeout 20 >/dev/null 2>&1
sleep 1.5   # let async/XHR-rendered tables settle

cur_url=$("${B[@]}" get url 2>/dev/null | tr -d '\r')
title=$("${B[@]}" get title 2>/dev/null | tr -d '\r')

"${B[@]}" screenshot --out "$OUT/screens/$SLUG.png" >/dev/null 2>&1

{
    echo "# $title"
    echo
    echo "- URL: \`$cur_url\`"
    echo "- 캡처: $(date '+%Y-%m-%d %H:%M')"
    echo "- 스크린샷: \`screens/$SLUG.png\`"
    echo
    echo "---"
    echo
    echo "## 화면 텍스트"
    echo
    "${B[@]}" get text --selector body 2>/dev/null
    echo
    echo "## 조작 요소 (링크·버튼·입력)"
    echo '```'
    "${B[@]}" snapshot --interactive 2>/dev/null
    echo '```'
    echo
    echo "## 내부 링크"
    echo '```'
    "${B[@]}" eval "[...new Set([...document.querySelectorAll('a[href]')].map(a=>a.getAttribute('href')).filter(h=>h&&!h.startsWith('javascript')))].join('\n')" 2>/dev/null
    echo '```'
} > "$OUT/pages/$SLUG.md"

echo "captured: $SLUG  <-  $cur_url"
