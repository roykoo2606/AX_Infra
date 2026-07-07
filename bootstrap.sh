#!/bin/bash
# AX_Infra bootstrap — 새 맥에서 전체 환경 복원 (Phase 3 갱신)
# 사용법: git clone https://github.com/roykoo2606/AX_Infra.git && cd AX_Infra && ./bootstrap.sh
set -e

echo "== AX_Infra bootstrap =="

# 1. Homebrew
if ! command -v brew &>/dev/null; then
  echo "[1/5] Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "[1/5] Homebrew OK"
fi

# 2. Core tools
echo "[2/5] Installing core tools..."
command -v tmux &>/dev/null || brew install tmux
command -v gh   &>/dev/null || brew install gh
brew list --cask obsidian &>/dev/null || brew install --cask obsidian
brew tap manaflow-ai/cmux 2>/dev/null || true
brew list --cask cmux &>/dev/null || brew install --cask cmux

# 3. AI agent CLIs
echo "[3/5] Installing AI agent CLIs..."
command -v claude &>/dev/null || npm install -g @anthropic-ai/claude-code
command -v codex  &>/dev/null || npm install -g @openai/codex

# 4. Autostart (재부팅 시 ax 세션 자동 기동)
echo "[4/5] Installing autostart..."
bash "$(dirname "$0")/scripts/install-autostart.sh"

# 5. Manual steps
echo "[5/5] 남은 수동 단계:"
echo "  - gh auth login  (roykoo2606 로그인 → git push 가능)"
echo "  - claude / codex 로그인"
echo "  - antigravity CLI 설치 (설치 경로 확정 시 이 스크립트에 추가)"
echo "  - Obsidian에서 이 폴더를 vault로 열기 (뷰어)"
echo "  - 상시가동 맥: 시스템 설정 > 에너지 > 잠자기 방지"
echo "Done. 세션 확인: tmux attach -t ax"
