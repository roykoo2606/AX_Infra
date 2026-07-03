#!/bin/bash
# AX_Infra bootstrap — restore environment on a new Mac
# Usage: git clone <repo-url> AX_Infra && cd AX_Infra && ./bootstrap.sh
set -e

echo "== AX_Infra bootstrap =="

# 1. Homebrew
if ! command -v brew &>/dev/null; then
  echo "[1/4] Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "[1/4] Homebrew OK"
fi

# 2. Core tools
echo "[2/4] Installing core tools..."
brew list --cask obsidian &>/dev/null || brew install --cask obsidian
brew tap manaflow-ai/cmux 2>/dev/null || true
brew list --cask cmux &>/dev/null || brew install --cask cmux
command -v gh &>/dev/null || brew install gh

# 3. AI agents (CLI)
echo "[3/4] Installing AI agent CLIs..."
command -v claude &>/dev/null || npm install -g @anthropic-ai/claude-code
command -v codex &>/dev/null || npm install -g @openai/codex

# 4. Reminders (manual steps)
echo "[4/4] Manual steps remaining:"
echo "  - Open this folder as an Obsidian vault (viewer)"
echo "  - Sign in: claude / codex / gh auth login"
echo "  - Always-on host only: energy settings (prevent sleep) + launchd jobs"
echo "Done."
