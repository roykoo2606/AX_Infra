#!/bin/bash
# AX_Infra 자동 기동 설치 (Phase 3) — 로그인/재부팅 시 start.sh 자동 실행
#
# 사용법:
#   설치:  scripts/install-autostart.sh
#   해제:  launchctl unload ~/Library/LaunchAgents/co.ax.infra.plist
#   확인:  launchctl list | grep co.ax.infra
set -e

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PLIST="$HOME/Library/LaunchAgents/co.ax.infra.plist"

mkdir -p "$HOME/Library/LaunchAgents" "$ROOT/logs/system"

cat > "$PLIST" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>co.ax.infra</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>$ROOT/scripts/start.sh</string>
  </array>
  <key>RunAtLoad</key><true/>
  <key>EnvironmentVariables</key>
  <dict>
    <key>PATH</key><string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin</string>
  </dict>
  <key>StandardOutPath</key><string>$ROOT/logs/system/autostart.log</string>
  <key>StandardErrorPath</key><string>$ROOT/logs/system/autostart.err</string>
</dict>
</plist>
EOF

launchctl unload "$PLIST" 2>/dev/null || true
launchctl load -w "$PLIST"

echo "[ax] 자동 기동 설치 완료 (co.ax.infra)"
echo "     즉시 테스트: launchctl start co.ax.infra && sleep 2 && tmux ls"
echo "     이제 재부팅해도 로그인하면 ax 세션이 자동으로 살아납니다"
