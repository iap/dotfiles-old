#!/bin/sh
# Central environment configuration
# Platform detection and core environment setup

# Platform detection
case "$(uname -s)" in
  Darwin) export OS_TYPE="macOS" ;;
  Linux)  export OS_TYPE="linux" ;;
  *)      export OS_TYPE="unknown" ;;
esac

# Core environment variables
export EDITOR="vim"
export VISUAL="$EDITOR"

# XDG Base Directory Specification with fallbacks
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# Platform-specific PATH configuration
if [ "$OS_TYPE" = "macOS" ]; then
  export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
else
  export PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
fi

# User binary directory
export PATH="$HOME/bin:$PATH"

# Security settings
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000

# Network and security modes
export OFFLINE_MODE="${OFFLINE_MODE:-0}"
export SECURE_MODE="${SECURE_MODE:-0}"
export DEBUG_MODE="${DEBUG_MODE:-0}"

# PATH hardening - remove current directory
export PATH=$(echo "$PATH" | sed -E 's/(^|:)\.(:|$)//g')

# Secure umask
umask 077

# Disable history in secure mode
if [ "$SECURE_MODE" = "1" ]; then
  export HISTFILE="/dev/null"
fi

# Logging function
log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$HOME/.logs/decisions.log"
}

# Network logging function
log_network() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$HOME/.logs/network.log"
}

# Network check function
check_network() {
  ping -c 1 1.1.1.1 >/dev/null 2>&1 || return 1
}
# GPG configuration
# Set GPG TTY for proper pinentry operation
if command -v gpg > /dev/null 2>&1; then
  export GPG_TTY=$(tty)
  # Update GPG agent with current TTY
  if command -v gpg-connect-agent > /dev/null 2>&1; then
    gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1 || true
  fi
fi

# GPG agent SSH support
# Use GPG agent for SSH authentication if available
if command -v gpgconf > /dev/null 2>&1; then
  # Get GPG agent SSH socket
  GPG_SSH_SOCKET="$(gpgconf --list-dirs agent-ssh-socket 2>/dev/null)"
  if [ -n "$GPG_SSH_SOCKET" ]; then
    export SSH_AUTH_SOCK="$GPG_SSH_SOCKET"
    log "GPG agent SSH support enabled"
  fi
fi
