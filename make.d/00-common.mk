# Common utilities and shared functions
# Part of modular Makefile system - loaded first

# Version and metadata
DOTFILES_VERSION := 2.1.0
MAKEFILE_UPDATED := 2025-07-14

# Default configuration
DRY_RUN ?= 0
OFFLINE_MODE ?= 0
TIMEOUT ?= 30

# Platform detection (cached)
UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Darwin)
    PLATFORM := macos
else ifeq ($(UNAME_S),Linux)
    PLATFORM := linux
else
    PLATFORM := unknown
endif

# Common path variables (centralized)
CONFIG_DIR := $(HOME)/.config
ENV_DIR := $(CONFIG_DIR)/env.d
BACKUP_DIR := $(HOME)/.backup
LOGS_DIR := $(HOME)/.logs
CACHE_DIR := $(HOME)/.cache
VIM_CACHE_DIR := $(CACHE_DIR)/vim
LOCAL_DIR := $(HOME)/.local
GNUPG_DIR := $(HOME)/.gnupg
SSH_DIR := $(HOME)/.ssh
BIN_DIR := $(HOME)/bin
PROJECT_BIN_DIR := $(PWD)/bin

# Commonly used file lists
CORE_DOTFILES := zshrc bashrc profile vimrc gitconfig gitignore_global hushlogin
SENSITIVE_DIRS := .gnupg .ssh .backup .logs .cache
TEMPLATE_FILES := gitconfig.local config.local forward.local profile.local

# Platform-specific stat command
ifeq ($(PLATFORM),macos)
    STAT_CMD := stat -f '%p'
    STAT_PERM := | tail -c 4
else
    STAT_CMD := stat -c '%a'
    STAT_PERM :=
endif

# Utility macros
define log_action
	@mkdir -p "$(LOGS_DIR)" 2>/dev/null || true
	@echo "[$(shell date '+%Y-%m-%d %H:%M:%S')] $(1)" >> "$(LOGS_DIR)/makefile.log" 2>/dev/null || true
endef

define dry_run_or_execute
	$(if $(filter 1,$(DRY_RUN)),@echo "[DRY-RUN] Would execute: $(1)",@$(1))
endef

define check_directory
	@test -d "$(1)" || { echo "[ERROR] Directory not found: $(1)"; exit 1; }
endef

define create_directory_safe
	@mkdir -p "$(1)" 2>/dev/null || { echo "[ERROR] Failed to create: $(1)"; exit 1; }
endef

define set_permissions_safe
	$(call dry_run_or_execute,chmod $(2) "$(1)" 2>/dev/null || echo "[WARNING] Could not set permissions on $(1)")
endef

define create_symlink_safe
	$(call dry_run_or_execute,ln -sf "$(2)" "$(1)" || echo "[ERROR] Failed to create symlink: $(1) -> $(2)")
endef

# Color output (optional)
ifndef NO_COLOR
    RED := \033[0;31m
    GREEN := \033[0;32m
    YELLOW := \033[0;33m
    BLUE := \033[0;34m
    NC := \033[0m
endif

# Common validation functions
define validate_prerequisites
	@command -v $(1) >/dev/null 2>&1 || { echo "[ERROR] Required tool not found: $(1)"; exit 1; }
endef

# Progress indicator
define show_progress
	@echo "$(GREEN)[INFO]$(NC) $(1)"
endef

define show_warning
	@echo "$(YELLOW)[WARNING]$(NC) $(1)"
endef

define show_error
	@echo "$(RED)[ERROR]$(NC) $(1)"
endef
