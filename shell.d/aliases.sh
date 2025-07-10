#!/bin/sh
# Shared aliases for bash and zsh
# POSIX-compatible alias definitions

# Basic filesystem navigation
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'

# Enhanced commands
alias grep='grep --color=auto'

# Git aliases - consistent across shells
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline'
alias gd='git diff'

# Platform-specific ls coloring
if [ "$OS_TYPE" = "macOS" ]; then
  alias ls='ls -G'
else
  alias ls='ls --color=auto'
fi
