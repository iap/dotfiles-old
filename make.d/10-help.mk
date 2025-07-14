# Help and information targets
# Part of modular Makefile system - optimized with common utilities

.PHONY: help version

# Default target - show available commands with version info
help:
	@echo "$(GREEN)Dotfiles Management System v$(DOTFILES_VERSION)$(NC)"
	@echo "$(BLUE)Last updated: $(MAKEFILE_UPDATED)$(NC)"
	@echo "Platform: $(PLATFORM)"
	@echo ""
	@echo "$(YELLOW)Setup Targets:$(NC)"
	@echo "  bootstrap            - Setup complete environment"
	@echo "  setup-templates      - Setup local configuration templates"
	@echo "  link-dotfiles        - Create symbolic links"
	@echo ""
	@echo "$(YELLOW)Validation Targets:$(NC)"
	@echo "  validate             - Comprehensive system and path validation"
	@echo "  validate-prerequisites - Check basic requirements before setup"
	@echo "  validate-permissions - Validate security permissions"
	@echo ""
	@echo "$(YELLOW)Maintenance Targets:$(NC)"
	@echo "  maintenance          - Comprehensive system maintenance (cleanup, permissions, disk check)"
	@echo "  clean-cache          - Clear cache directory"
	@echo "  backup               - Backup essential files"
	@echo ""
	@echo "$(YELLOW)Compliance and Testing Targets:$(NC)"
	@echo "  check-compliance     - Full system compliance check"
	@echo "  test-safety          - Test safety and reliability features"
	@echo "  help-safety          - Show safety feature documentation"
	@echo ""
	@echo "$(YELLOW)Safety modes:$(NC)"
	@echo "  DRY_RUN=1             - Preview actions without executing"
	@echo "  OFFLINE_MODE=1        - Skip network operations"
	@echo "  TIMEOUT=seconds       - Override operation timeout"
	@echo "  NO_COLOR=1            - Disable colored output"
	@echo ""
	@echo "$(GREEN)Example:$(NC) make bootstrap DRY_RUN=1 TIMEOUT=600"

# Show version information
version:
	@echo "$(GREEN)Dotfiles Management System$(NC)"
	@echo "Version: $(DOTFILES_VERSION)"
	@echo "Updated: $(MAKEFILE_UPDATED)"
	@echo "Platform: $(PLATFORM)"
