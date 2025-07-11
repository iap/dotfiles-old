# Help and information targets
# Part of modular Makefile system

.PHONY: help

# Default target - show available commands
help:
	@echo "Available targets:"
	@echo "  bootstrap      - Setup complete environment"
	@echo "  validate       - Comprehensive system and path validation"
	@echo "  validate-prerequisites - Check basic requirements before setup"
	@echo "  link-dotfiles  - Create symbolic links"
	@echo "  clean-cache    - Clear cache directory"
	@echo "  backup         - Backup essential files"
	@echo "  setup-templates - Setup local configuration templates"
	@echo "  auto-cleanup   - Clean old logs and backups (7+ days)"
	@echo "  check-compliance - Full system compliance check"
	@echo "  fix-permissions - Fix directory and file permissions"
	@echo "  validate-permissions - Validate security permissions"
	@echo "  test-safety     - Test safety and reliability features"
	@echo "  help-safety     - Show safety feature documentation"
	@echo ""
	@echo "Safety modes:"
	@echo "  DRY_RUN=1       - Preview actions without executing"
	@echo "  OFFLINE_MODE=1  - Skip network operations"
	@echo "  TIMEOUT=seconds - Override operation timeout"
	@echo "  Example: make bootstrap DRY_RUN=1 TIMEOUT=600"
