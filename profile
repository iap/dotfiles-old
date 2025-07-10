#!/bin/sh
# POSIX shell profile
# Universal shell configuration for login shells

# Load central environment configuration
if [ -f "$HOME/.config/env.d/default.sh" ]; then
  . "$HOME/.config/env.d/default.sh"
fi

# Load local profile overrides if they exist
# These can override any defaults set above
if [ -f "$HOME/.profile.local" ]; then
  . "$HOME/.profile.local"
fi
