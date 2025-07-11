# Dotfiles

> **Version**: 1.2.1 | **Last Updated**: 2025-07-11T06:24:00Z | **Status**: ✅ Stable

Minimal, secure, and cross-platform development environment configuration with optimized variable syntax and enhanced compatibility.

## What's New in v1.2.0

**Major Optimizations & Cross-Platform Improvements:**
- **SSH Config Overhaul**: Eliminated redundant Port 22 specifications, now uses SSH defaults for cleaner config
- **Essential vs Template Architecture**: Main config provides essential cross-platform defaults, local config for customization
- **Enhanced Compatibility**: Fixed macOS readlink issues, now works seamlessly on older Unix systems (OpenSSH 6.0+)
- **Variable Syntax Bulletproofing**: Comprehensive fixes for all variable usage patterns across the project
- **GPG SSH Auth Fixes**: Resolved pinentry path issues causing "agent refused operation" errors
- **Permissions**: Ensured pinentry-fallback symlink has 755 permissions for proper GPG agent execution
- **Beautiful Config Templates**: Restructured SSH config.local with comprehensive examples for all scenarios

## Overview

This dotfiles setup follows POSIX-compatible standards and supports both Zsh and Bash shells with shared environment configuration. Includes MacPorts package manager integration on macOS for streamlined development tool installation.

## Structure

```
.dotfiles/
├── Makefile                # Environment management and automation
├── README.md              # Documentation
├── CHANGELOG.md           # Version history and changes
├── VERSION                # Current version number
├── bashrc                 # Bash shell configuration
├── bin/                   # Essential utility scripts
│   ├── git-provider       # Multi-provider Git management
│   ├── gpg-setup          # GPG key management
│   ├── gpg-ssh            # GPG SSH authentication
│   ├── pinentry-fallback  # Cross-platform pinentry
│   └── ssh-keygen-secure  # Secure SSH key generation
├── config/
│   └── env.d/
│       └── default.sh     # Central environment configuration
├── gitconfig              # Git configuration
├── gitignore_global       # Global Git ignore rules
├── gnupg/                 # GPG configuration
│   ├── gpg-agent.conf     # GPG agent settings (SSH support) - copied for stability
│   └── gpg.conf           # GPG client configuration
├── hushlogin              # Suppress login messages
├── profile                # POSIX shell profile
├── shell.d/               # Shared shell configuration
│   ├── aliases.sh         # Common aliases for bash/zsh
│   └── env.sh             # Shared environment loader
├── ssh/
│   └── config             # SSH client configuration (essential cross-platform defaults)
├── template/              # Local configuration templates
│   ├── config.local       # SSH host configuration template
│   ├── default.local.sh   # Environment variable overrides template
│   ├── forward.local      # Email forwarding template
│   ├── gitconfig.local    # Git user settings template
│   └── profile.local      # POSIX shell profile overrides template
├── vimrc                  # Vim editor configuration
└── zshrc                  # Zsh shell configuration

8 directories, 22 files
```

## Installation

1. Clone or initialize the repository:
   ```bash
   cd ~/.dotfiles
   git init
   ```

2. Run the bootstrap process:
   ```bash
   make bootstrap
   ```

3. Restart your shell or source the configuration:
   ```bash
   # For Zsh users
   source ~/.zshrc
   
   # For Bash users
   source ~/.bashrc
   ```

## Shell Support

### Zsh (Primary)
- Default shell configuration
- Advanced completion and history
- Modular configuration via `shell.d/`

### Bash (Optional Alternative)
- Legacy compatibility
- Same aliases and environment as Zsh
- Bash completion support
- Modular configuration via `shell.d/`

Both shells share the same:
- Environment variables
- PATH configuration
- Git aliases
- Platform detection
- Security settings

## Key Features

- **Cross-platform**: Works on macOS and Linux
- **Package Management**: MacPorts integration on macOS, native package managers on Linux
- **Modular**: Organized configuration files
- **Secure**: Proper permissions and security modes
- **Minimal**: Essential tools only
- **Extensible**: Local override support

## Local Customization

### Template System

The `bootstrap` process automatically creates local configuration files from templates:

- `~/.gitconfig.local` - Git user settings (name, email, GPG signing key)
- `~/.ssh/config.local` - SSH host configurations
- `~/.forward.local` - Email forwarding addresses
- `~/.config/env.d/default.local.sh` - Environment variable overrides
- `~/.profile.local` - POSIX shell profile overrides

These files are:
- Created from `template/` directory during bootstrap
- Automatically sourced by main configuration files
- Excluded from Git tracking (never committed)
- Safe to customize with personal/machine-specific settings

### Manual Overrides

Additional `.local` files for machine/platform-specific customization:
- `~/.profile.local` - Shell environment, PATH, and development tool overrides
- `~/.config/env.d/default.local.sh` - Environment variables, API keys, and local settings

#### Machine-Specific Examples:
```bash
# ~/.profile.local - macOS with MacPorts
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
export JAVA_HOME="/opt/local/Library/Java/JavaVirtualMachines/openjdk11/Contents/Home"

# ~/.config/env.d/default.local.sh - Development environment
export DOCKER_HOST="tcp://localhost:2376"
export KUBECONFIG="$HOME/.kube/config"
export NODE_ENV="development"
```

## Available Commands

Run `make help` to see available targets:

- `make bootstrap` - Complete setup
- `make validate` - Check configuration
- `make link-dotfiles` - Create symbolic links
- `make clean-cache` - Clear cache directory
- `make backup` - Backup configuration

## Development Workflow

This project follows universal development standards for consistent, secure development:

**Development Standards Include**:
- Pre-push checklist ✅
- Commit message guidelines (conventional commits)
- Release process with proper versioning
- Quality gates and validation
- Security standards and best practices
- Cross-platform compatibility

**Project-specific validation**:
```bash
make validate              # System configuration validation
make check-compliance      # POSIX compliance and security
```

## Switching Between Shells

### To Zsh:
```bash
chsh -s /bin/zsh
# Restart terminal
```

### To Bash:
```bash
chsh -s /bin/bash
# Restart terminal
```

Both configurations will work seamlessly as they share the same environment foundation.

## Directory Permissions

The setup enforces secure permissions:
- `~/.backup/` - 700 (user only)
- `~/.gnupg/` - 700 (user only)  
- `~/.ssh/` - 700 (user only)
- Configuration files - 600 (user read/write only)

## Security Features

- Network mode by default (`OFFLINE_MODE=0`)
- Secure umask (077)
- PATH hardening (removes current directory)
- History protection in secure mode
- Modeline protection in Vim
- No exposure of personal identifiers
- Clean login experience (hushlogin)
- GPG agent SSH authentication (unified key management)

## Clean Terminal Experience

The `.hushlogin` file suppresses system login messages for a professional, minimal terminal:
- No "Last login" information
- No system messages (MOTD)
- No mail notifications
- Faster login process
- Clean appearance for demonstrations and screenshots

## Utility Scripts

The `bin/` directory contains powerful utility scripts:

### Git Provider Management (`git-provider`)
Manage dotfiles across multiple Git providers:
```bash
git-provider setup                    # Interactive setup
git-provider add-remote -p github -u URL
git-provider push-all                 # Push to all providers
git-provider sync                     # Sync across providers
```

### GPG Management (`gpg-setup`, `gpg-ssh`)
GPG key management and SSH authentication:
```bash
gpg-setup generate                    # Create new GPG key
gpg-ssh setup                        # Enable GPG agent SSH
gpg-ssh add-key -k KEYID             # Add key for SSH auth
gpg-ssh ssh-keys                     # Show SSH public keys
```

### SSH Key Generation (`ssh-keygen-secure`)
Secure SSH key generation with best practices:
```bash
ssh-keygen-secure                     # Generate Ed25519 key
ssh-keygen-secure -t rsa -b 4096      # Generate RSA key
```

### Email Forwarding
Simple email forwarding setup:
```bash
# Email forwarding is automatically set up during bootstrap
vim ~/.forward.local                  # Edit with your email addresses
```

## Advanced Features

### GPG SSH Authentication
Use GPG keys for SSH authentication (enabled by default):
- Unified key management (GPG + SSH)
- Secure agent-based authentication
- Cross-platform compatibility
- Professional security setup

### Multi-Provider Git Support
Synchronize dotfiles across multiple Git providers:
- GitHub, GitLab, Bitbucket, Codeberg, Gitea
- Primary/secondary provider management
- Automated push/pull synchronization
- Per-provider SSH key support

### SSH Security Configuration
- Essential defaults for maximum cross-platform compatibility
- Platform-specific overrides in `~/.ssh/config.local`
- Modern cryptography with fallbacks for older systems
- Connection multiplexing and optimization for Git operations
- Separate known_hosts for local vs remote hosts
- Port 22 by default (customizable per host in config.local)

### Email Integration
- Template-based forwarding configuration
- Private address management (`.forward.local`)
- Validation and backup functionality

## Platform Detection & Compatibility

The configuration automatically detects your platform and provides enhanced compatibility:
- `$OS_TYPE` is set to "macOS" or "linux"
- Platform-specific PATH and tool configurations
- **MacPorts support on macOS**: `/opt/local/bin:/opt/local/sbin` added to PATH
- **Native package manager support on Linux**: Standard system paths
- **Cross-platform readlink compatibility**: Handles macOS vs Linux differences automatically
- **Older system support**: Works with OpenSSH 6.0+ and older Unix systems
- **Smart fallbacks**: Graceful degradation when modern tools aren't available

### Package Management

#### macOS (MacPorts)
```bash
# Install essential development tools
sudo port install git vim gpg2 pinentry-mac
sudo port install python311 nodejs18 go

# Security tools
sudo port install gnupg2 pinentry-curses
```

#### Linux (Distribution-specific)
```bash
# Ubuntu/Debian
sudo apt-get install git vim gnupg2 pinentry-gtk2

# CentOS/RHEL
sudo yum install git vim gnupg2 pinentry-gtk
```
