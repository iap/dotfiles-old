# Changelog

All notable changes to this dotfiles configuration are documented here.

## [1.2.0] - 2025-07-10

### Major Optimizations
- **SSH Configuration Overhaul**: Removed redundant Port 22 specifications (3 instances eliminated)
- **Essential vs Template Architecture**: Redesigned config for maximum reusability across older devices
- **Cross-Platform Compatibility**: Added comprehensive readlink fallbacks for macOS/Linux/older systems
- **Variable Syntax Bulletproofing**: Fixed and standardized all variable usage across the project

### Fixed
- **Critical macOS Compatibility**: Fixed `readlink -f` issues on macOS with proper fallback chain
- **GPG SSH Authentication**: Resolved pinentry path issues causing "agent refused operation" errors
- **Path Resolution**: Enhanced cross-platform compatibility in zshrc, bashrc, and shell.d/env.sh
- **SSH Config Redundancy**: Eliminated unnecessary Port 22 specifications (now relies on SSH defaults)
- **Bootstrap Validation**: Fixed hardcoded path detection for `$HOME` vs `~` usage in Git configuration

### Enhanced
- **SSH Configuration**: 
  - Essential defaults in main config for maximum compatibility
  - Platform-specific settings moved to config.local template
  - Added comprehensive git provider examples (GitHub, GitLab, Codeberg)
  - Optimized connection multiplexing for Git operations
  - Enhanced security with modern crypto fallbacks for older systems
- **Config.local Template**: 
  - Beautiful structured template with platform sections
  - macOS/Linux/older system compatibility examples
  - Port override examples for specific scenarios
  - Git provider optimizations with GPG SSH notes
  - Development shortcuts and server examples

### Security
- **GPG Agent**: Fixed pinentry program path resolution with `%h` placeholder
- **SSH**: Maintained `IdentitiesOnly no` for proper GPG SSH integration
- **Variable Syntax**: Eliminated potential shell injection vectors with proper quoting
- **Cross-Platform**: Ensured secure defaults work on OpenSSH 6.0+ (older systems)

### Performance
- **SSH**: Optimized connection multiplexing for Git providers
- **Shell Loading**: Improved readlink performance with platform-specific optimization
- **Configuration**: Reduced complexity while maintaining functionality

### Documentation
- **README**: Comprehensive update reflecting all optimizations and new architecture
- **Version**: Bumped to 1.2.0 reflecting significant improvements
- **Examples**: Updated all examples to reflect optimized configurations

## [1.1.1] - 2025-07-09

### Documentation
- **Enhanced README**: Added MacPorts package manager integration documentation
- **Improved local configuration**: Better examples for machine/platform-specific customization
- **Fixed directory references**: Corrected `zshrc.d/bashrc.d` references to `shell.d/`
- **Updated project structure**: Added missing files (CHANGELOG.md, VERSION, template files)
- **Status update**: Changed project status from "Production Ready" to "Stable"
- **Version synchronization**: Updated all version references to 1.1.0

### Commit Message Improvements
- **Standardized format**: Applied conventional commit guidelines to all commit messages
- **Improved clarity**: Made commit titles more concise and meaningful
- **Fixed categorization**: Corrected commit types (feat/fix/refactor/docs)
- **GPG signing**: Re-signed all commits for GitHub verification

### Added
- **Package management section**: Comprehensive MacPorts and Linux package manager examples
- **Machine-specific configuration examples**: Practical `.local` file configurations
- **Enhanced template documentation**: Better explanation of local customization system

## [1.1.0] - 2025-07-07

### Fixed
- **Critical**: Shell aliases not loading due to incorrect path resolution
- Dynamic path resolution in zshrc and bashrc (removed extra `../`)
- Shell-agnostic aliases loading in env.sh
- Template system path resolution for aliases.sh

### Added
- Complete template system for local overrides:
  - `template/default.local.sh` - Environment variable overrides
  - `template/profile.local` - POSIX shell profile overrides
- Comprehensive shell syntax validation in compliance checks
- Debug support for shell loading troubleshooting

### Changed
- **Optimized Makefile validation targets**:
  - Merged `validate` and `validate-path` into single comprehensive `validate` target
  - Simplified validation structure: `validate` + `check-compliance`
  - Eliminated redundant functionality and improved maintainability
- Enhanced shell configuration loading with proper error handling
- Updated help text to reflect consolidated validation targets

### Security
- Validated all dynamic path resolutions work correctly
- Confirmed no hardcoded paths remain in any configuration
- Template system properly excludes sensitive files from version control

## [1.0.0] - 2025-07-07

### Added
- Terminal-first pinentry fallback system for GPG
- Cross-platform SSH configuration with security hardening  
- MacPorts-only package management compliance
- GPG agent configuration with secure pinentry ordering
- Git configuration with GPG signing enabled
- User configuration templates for local customization

### Security
- SSH IdentitiesOnly disabled for GitHub (controlled exception)
- Pinentry priority: terminal-first, GUI fallback only
- GPG agent cache: 10min default, 2hr maximum
- File permissions: 700/600 for sensitive directories/files
- No hardcoded paths, dynamic resolution only

### Configuration
- SSH GitHub authentication working
- GPG signing and encryption tested and functional
- Terminal-based pinentry confirmed working (pinentry-curses)
- All security rules compliance verified

### Infrastructure
- Symlinked configuration files for instant updates
- Copied GPG agent config for security isolation
- Makefile automation for reproducible setup
- Cross-platform compatibility (macOS/Linux)

---
*Format: [Version] - YYYY-MM-DD*  
*Categories: Added, Changed, Deprecated, Removed, Fixed, Security*
