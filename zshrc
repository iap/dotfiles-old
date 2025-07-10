# Zsh configuration
# Minimal, secure, and cross-platform setup

# Load environment configuration
# Cross-platform readlink compatibility
if command -v greadlink >/dev/null 2>&1; then
  DOTFILES_DIR="$(dirname "$(greadlink -f "$HOME/.zshrc")")" 2>/dev/null
elif [ "$(uname)" = "Darwin" ]; then
  DOTFILES_DIR="$(dirname "$(readlink "$HOME/.zshrc")")" 2>/dev/null
else
  DOTFILES_DIR="$(dirname "$(readlink -f "$HOME/.zshrc")")" 2>/dev/null
fi

if [ -f "$DOTFILES_DIR/shell.d/env.sh" ]; then
  source "$DOTFILES_DIR/shell.d/env.sh"
fi

# Zsh options
setopt AUTO_CD
setopt CORRECT
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_VERIFY
setopt INC_APPEND_HISTORY
setopt INTERACTIVE_COMMENTS
setopt SHARE_HISTORY

# Key bindings
bindkey -e  # Emacs key bindings

# Completion system
autoload -Uz compinit
compinit

# Simple prompt
PROMPT='%n@%m:%~%# '

# Aliases and platform-specific configurations are loaded via shell.d/env.sh
# which sources shell.d/aliases.sh

