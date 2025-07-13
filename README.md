# Dotfiles

> **Version**: 2.1.0 | **Last Updated**: 2025-07-12T15:59:00Z | **Status**: ✅ Stable

Personal dotfiles for cross-platform development environment management with Makefiles.

## Overview

This dotfiles setup follows POSIX-compatible standards and supports both Zsh and Bash shells with shared environment configuration. Includes MacPorts package manager integration on macOS for streamlined development tool installation.

## 📂 Project Structure

```text
.dotfiles/
├── Makefile                        # Main Makefile (modular architecture)
├── make.d/                         # Modular Makefile components
│   ├── 05-safety.mk                # Safety and reliability
│   ├── 10-help.mk                  # Help and information
│   ├── 20-validation.mk            # Validation scripts
│   ├── 30-permissions.mk           # Permission management
│   ├── 40-setup.mk                 # Environment setup
│   ├── 50-maintenance.mk           # Cleanup and maintenance tasks
│   └── 60-testing.mk               # Testing utilities
├── README.md                       # Main documentation
├── CHANGELOG.md                    # Version history
├── VERSION                         # Current version marker
├── .editorconfig                   # Editor configuration
├── .gitignore                      # Git ignore rules
├── .logs/                          # Logs
├── bashrc                          # Bash configuration
├── bin/                            # Utility scripts
│   ├── git-provider                # Multi-provider Git management
│   ├── gpg-setup                   # GPG key management tools
│   ├── gpg-ssh                     # GPG SSH tools
│   ├── pinentry-fallback           # Cross-platform pinentry
│   ├── pinentry-fallback-debug     # Pinentry debug mode
│   └── ssh-keygen-secure           # Secure SSH key generation
├── config/                         # Configuration files
│   └── env.d/                      # Environment configuration
│       ├── default.local.sh        # Local environment overrides
│       └── default.sh              # Base environment configuration
├── docs/                           # Documentation
│   ├── env-setup-guide.md          # Environment setup guide
│   ├── pinentry-troubleshooting.md # Pinentry troubleshooting
│   └── terminal-configuration.md   # Terminal configuration
├── gitconfig                       # Git global configuration
├── gitignore_global                # Global gitignore patterns
├── gnupg/                          # GPG configuration
│   ├── gpg-agent.conf.template     # GPG agent template
│   └── gpg.conf                    # GPG configuration
├── hooks/                          # Git hooks
│   └── pre-commit                  # Pre-commit hook
├── hushlogin                       # Suppress login messages
├── profile                         # Shell profile
├── shell.d/                        # Shell scripts
│   ├── aliases.sh                  # Shell aliases
│   └── env.sh                      # Environment variable loader
├── ssh/                            # SSH configuration
│   └── config                      # SSH configuration
├── template/                       # Template files
│   ├── config.local                # SSH config template
│   ├── default.local.sh            # Local env overrides template
│   ├── forward.local               # Email forward template
│   ├── gitconfig.local             # Git local config template
│   └── profile.local               # Local profile template
├── vimrc                           # Vim configuration
└── zshrc                           # Zsh configuration

12 directories, 43 files
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

- **Modular Architecture**: 6 focused Makefile modules with single responsibility
- **Safety First**: Comprehensive safety features with dry-run support and crash prevention
- **Cross-platform**: Works seamlessly on macOS and Linux servers
- **Server-Ready**: Enhanced pinentry-fallback with headless environment detection
- **Secure**: Proper permissions, process locking, and security modes
- **Minimal**: Essential tools by platform
- **Extensible**: Local override support with template system

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

#### Machine-Specific Examples

```bash
# ~/.profile.local - macOS with MacPorts
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
export JAVA_HOME="/opt/local/Library/Java/JavaVirtualMachines/openjdk11/Contents/Home"

# ~/.config/env.d/default.local.sh - Development environment
export DOCKER_HOST="tcp://localhost:2376"
export KUBECONFIG="$HOME/.kube/config"
export NODE_ENV="development"
```

## Local Environment Configuration

Refer to [docs/local-env-config.md](docs/local-env-config.md) for detailed environment configuration instructions.


Place this file at `~/.config/env.d/default.local.sh` and it will be automatically sourced by the environment setup.

## Available Commands

Run `make help` to see available targets:

### Core Operations

- `make bootstrap` - Complete setup with safety features
- `make validate` - System configuration validation
- `make link-dotfiles` - Create symbolic links
- `make clean-cache` - Clear cache directory
- `make backup` - Backup configuration

### Testing & Optimization

- `make test` - Run comprehensive system tests
- `make test-validation` - Test system validation functions
- `make test-permissions` - Test directory permission validation
- `make test-gpg-template` - Test GPG template processing
- `make test-safety` - Test safety and reliability features
- `make help-safety` - Show safety feature documentation
- All targets support `DRY_RUN=1` for safe preview

### Safety Modes

- `DRY_RUN=1` - Preview actions without executing
- `OFFLINE_MODE=1` - Skip network operations
- `TIMEOUT=seconds` - Override operation timeout
- Example: `make bootstrap DRY_RUN=1 TIMEOUT=600`

## Development Workflow

**Project-specific validation**:

```bash
make validate              # System configuration validation
make check-compliance      # POSIX compliance and security
make test-safety           # Test safety and reliability features
```

## Switching Between Shells

### To Zsh

```bash
chsh -s /bin/zsh
# Restart terminal
```

### To Bash

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
- `~/.ssh/control/` - 700 (user only)
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

### Dynamic Configuration System

The dotfiles system uses template-based configuration for cross-platform compatibility:

- **GPG Agent Template**: `gnupg/gpg-agent.conf.template` with `%h` placeholder for dynamic home path
- **Bootstrap Processing**: Templates processed during setup with actual paths
- **Path Independence**: No hardcoded paths in configuration files
- **Cross-Platform**: Works across different user directories and systems

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
