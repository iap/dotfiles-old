# Dotfiles Makefile - Modular POSIX-compatible development environment management
# Version: 2.1.0 - Optimized modular architecture with shared utilities

# Default target
.DEFAULT_GOAL := help

# Include common utilities first (provides shared variables and functions)
include make.d/00-common.mk

# Include modular makefiles in logical order
include make.d/05-safety.mk
include make.d/10-help.mk
include make.d/20-validation.mk
include make.d/30-permissions.mk
include make.d/40-setup.mk
include make.d/50-maintenance.mk
include make.d/60-testing.mk

# Global PHONY targets from modules
.PHONY: help version validate validate-prerequisites validate-permissions check-compliance
.PHONY: fix-permissions bootstrap link-dotfiles setup-templates
.PHONY: clean-cache backup maintenance test-safety help-safety
.PHONY: test test-all test-validation test-setup test-gpg-template test-permissions
