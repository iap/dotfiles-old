#!/bin/sh
# Interactive shell environment loader
# POSIX-compatible for both bash and zsh
# Note: .profile should already have loaded the main environment

# Ensure core environment is loaded if .profile wasn't sourced
# (fallback for non-login shells)
if [ -z "$OS_TYPE" ] && [ -f "$HOME/.config/env.d/default.sh" ]; then
  . "$HOME/.config/env.d/default.sh"
fi

# Load local environment overrides for interactive shells
# These can override any defaults set above
if [ -f "$HOME/.config/env.d/default.local.sh" ]; then
  . "$HOME/.config/env.d/default.local.sh"
fi

# Load shell-specific local overrides (if they exist)
if [ -n "$ZSH_VERSION" ] && [ -f "$HOME/.zshrc.local" ]; then
  . "$HOME/.zshrc.local"
elif [ -n "$BASH_VERSION" ] && [ -f "$HOME/.bashrc.local" ]; then
  . "$HOME/.bashrc.local"
fi

# Load shared aliases (requires OS_TYPE to be set)
# Use shell-agnostic method to find dotfiles directory
if [ -n "$ZSH_VERSION" ]; then
  # Running in zsh
  SHELL_CONFIG="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
  # Running in bash
  SHELL_CONFIG="$HOME/.bashrc"
else
  # Fallback for other POSIX shells
  SHELL_CONFIG="$HOME/.profile"
fi

# Cross-platform readlink compatibility for aliases
if command -v greadlink >/dev/null 2>&1; then
  DOTFILES_DIR="$(dirname "$(greadlink -f "$SHELL_CONFIG")")" 2>/dev/null
elif [ "$(uname)" = "Darwin" ]; then
  DOTFILES_DIR="$(dirname "$(readlink "$SHELL_CONFIG")")" 2>/dev/null
else
  DOTFILES_DIR="$(dirname "$(readlink -f "$SHELL_CONFIG")")" 2>/dev/null
fi

ALIASES_PATH="$DOTFILES_DIR/shell.d/aliases.sh"
if [ -f "$ALIASES_PATH" ]; then
  . "$ALIASES_PATH"
fi
