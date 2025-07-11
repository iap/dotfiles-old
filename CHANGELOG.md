# Changelog

All notable changes to this dotfiles configuration are documented here.

## [2.0.0] - 2025-07-11

### Major Architecture Update
- **Modular Makefile System**: Restructured from 320-line monolithic Makefile to modular 17-line system
- **Safety Features**: Added comprehensive shell safety with timeout protection, retry logic, and crash prevention
- **Dry-Run Support**: All destructive operations now support `DRY_RUN=1` for safe preview
- **Server Compatibility**: Enhanced pinentry-fallback with headless detection and better Linux support

### Added
- **make.d/ directory structure**: 6 modular components (safety, help, validation, permissions, setup, maintenance)
- **Process locking**: Prevents concurrent dotfiles operations
- **Resource monitoring**: Disk and memory usage checks before operations
- **Network safety**: Connectivity checks with offline mode support
- **Enhanced logging**: Debug logs for pinentry selection and operations

### Fixed
- **Critical GPG SSH Authentication**: Fixed pinentry-fallback symlink permissions
- **Server pinentry**: Prioritized terminal-based pinentry for headless environments
- **Error handling**: Graceful exit on interrupt (Ctrl+C) with automatic cleanup

## [1.2.1] - 2025-07-11

### Fixed
- **GPG SSH Authentication**: Fixed pinentry-fallback permissions
- **Network Mode**: Changed default from offline to network enabled
- **Script Consistency**: Unified environment variable handling

## [1.2.0] - 2025-07-10

### Fixed
- **macOS Compatibility**: Fixed `readlink -f` issues with proper fallbacks
- **GPG SSH Authentication**: Resolved pinentry path issues
- **SSH Configuration**: Removed redundant Port 22 specifications
- **Cross-Platform**: Enhanced compatibility across macOS/Linux/older systems

### Enhanced
- **SSH Templates**: Improved config.local template with platform examples
- **Security**: Better GPG agent path resolution and SSH integration
- **Performance**: Optimized shell loading and SSH connection multiplexing

## [1.1.1] - 2025-07-09

### Documentation
- **Enhanced README**: Added MacPorts integration and local configuration examples
- **Fixed references**: Corrected `zshrc.d/bashrc.d` to `shell.d/`
- **Project structure**: Added missing files (CHANGELOG.md, VERSION, templates)

### Added
- **Package management**: MacPorts and Linux package manager examples
- **Local customization**: Improved `.local` file configuration system

## [1.1.0] - 2025-07-07

### Fixed
- **Critical**: Shell aliases not loading due to path resolution issues
- Template system and dynamic path resolution

### Added
- Complete template system for local overrides
- Shell syntax validation in compliance checks
- Optimized Makefile validation targets

## [1.0.0] - 2025-07-07

### Initial Release
- Terminal-first pinentry fallback system for GPG
- Cross-platform SSH configuration with security hardening
- MacPorts-only package management compliance
- GPG agent configuration with secure pinentry ordering
- Git configuration with GPG signing enabled
- User configuration templates for local customization
- Makefile automation for reproducible setup
- Cross-platform compatibility (macOS/Linux)
