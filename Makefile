# Dotfiles Makefile - Modular POSIX-compatible development environment management
# Version: 2.0.0 - Modular architecture with dry-run support

# Default target
.DEFAULT_GOAL := help

# Include all modular makefiles
include make.d/05-safety.mk
include make.d/10-help.mk
include make.d/20-validation.mk
include make.d/30-permissions.mk
include make.d/40-setup.mk
include make.d/50-maintenance.mk

# Global PHONY targets from modules
.PHONY: help validate validate-prerequisites validate-permissions check-compliance
.PHONY: fix-permissions bootstrap link-dotfiles setup-templates
.PHONY: clean-cache backup auto-cleanup test-safety help-safety
