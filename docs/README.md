# Dotfiles Documentation

This directory contains documentation for the dotfiles configuration system.

## Contents

- [timeout-script.md](timeout-script.md) - Cross-platform timeout script implementation

## Quick Start

1. **Setup Environment**
   ```bash
   make bootstrap
   ```

2. **Validate Installation**
   ```bash
   make validate
   ```

3. **Test Tools**
   ```bash
   # Test timeout script
   timeout 2 sleep 5
   
   # Check environment
   echo $OS_TYPE
   ```

## Architecture

- `bin/` - Custom scripts and utilities
- `config/` - Configuration files
- `docs/` - Documentation
- `template/` - Template files for local configs

## Platform Support

- **macOS**: Primary development platform
- **Linux**: Cross-platform compatibility
- **Shell**: zsh (primary), bash (fallback)

## Key Features

- Cross-platform command handling
- Secure local config overrides
- Minimal external dependencies
- Consistent tool behavior

## Contributing

- Create feature branches: `dev/feature-name`
- Follow commit message guidelines
- Test on both macOS and Linux when possible
- Document new features

## Support

- Check existing issues and documentation first
- Test with clean environment when troubleshooting
- Provide system information (OS, shell, etc.)
