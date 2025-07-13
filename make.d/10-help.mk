# Help and information targets
# Part of modular Makefile system

.PHONY: help

# Default target - show available commands
help:
	@echo "Command Reference:"
	@echo "  Setup Targets:"
	@echo "    bootstrap            - Setup complete environment"
	@echo "    setup-templates      - Setup local configuration templates"
	@echo "    link-dotfiles        - Create symbolic links"
	@echo ""
	@echo "  Validation Targets:"
	@echo "    validate             - Comprehensive system and path validation"
	@echo "    validate-prerequisites - Check basic requirements before setup"
	@echo "    validate-permissions - Validate security permissions"
	@echo ""
	@echo "  Maintenance Targets:"
	@echo "    clean-cache          - Clear cache directory"
	@echo "    auto-cleanup         - Clean old logs and backups (7+ days)"
	@echo "    backup               - Backup essential files"
	@echo "    fix-permissions      - Fix directory and file permissions"
	@echo ""
	@echo "  Compliance and Testing Targets:"
	@echo "    check-compliance     - Full system compliance check"
	@echo "    test-safety          - Test safety and reliability features"
	@echo "    help-safety          - Show safety feature documentation"
	@echo ""
	@echo "Safety modes:"
	@echo "  DRY_RUN=1             - Preview actions without executing"
	@echo "  OFFLINE_MODE=1        - Skip network operations"
	@echo "  TIMEOUT=seconds       - Override operation timeout"
	@echo "  Example: make bootstrap DRY_RUN=1 TIMEOUT=600"
