# Maintenance and cleanup operations
# Part of modular Makefile system

.PHONY: clean-cache backup maintenance

# Default to dry-run mode for safety
DRY_RUN ?= 1

# Define common paths
CACHE_DIR := $(HOME)/.cache
BACKUP_DIR := $(HOME)/.backup/system
LOG_DIR := $(HOME)/.logs

# Macro for creating directories
define create-dir
	@mkdir -p "$1" && echo "[OK] Created directory: $1" || echo "[ERROR] Failed to create directory: $1"
endef

# Clean cache directory
clean-cache:
	@echo "Cleaning cache directory..."
ifdef DRY_RUN
	@echo "[DRY-RUN] Would remove cache: rm -rf $(CACHE_DIR)"
	@echo "[DRY-RUN] Would recreate cache: mkdir -p $(CACHE_DIR)"
else
	@rm -rf "$(CACHE_DIR)"
	$(call create-dir,$(CACHE_DIR))
endif
	@echo "Cache cleaned"

# Backup essential files
backup:
	@echo "Creating backup..."
ifdef DRY_RUN
	@echo "[DRY-RUN] Would create backup directory: mkdir -p $(BACKUP_DIR)"
	@echo "[DRY-RUN] Would copy dotfiles: cp -r $(PWD) $(BACKUP_DIR)/dotfiles"
	@test -f "$(HOME)/.zsh_history" && echo "[DRY-RUN] Would copy zsh history: cp $(HOME)/.zsh_history $(BACKUP_DIR)/" || true
	@echo "[DRY-RUN] Backup would be created in $(BACKUP_DIR)/"
else
	$(call create-dir,$(BACKUP_DIR))
	@cp -r "$(PWD)" "$(BACKUP_DIR)/dotfiles" 2>/dev/null || true
	@test -f "$(HOME)/.zsh_history" && cp "$(HOME)/.zsh_history" "$(BACKUP_DIR)/" || true
	@echo "Backup created in $(BACKUP_DIR)/"
endif

# Comprehensive maintenance (cleanup, duplicates, permissions, disk check)
maintenance:
	@echo "Running comprehensive maintenance..."
	@$(PWD)/bin/maintenance
	@echo "Maintenance completed. Check logs: $(HOME)/.logs/maintenance-cron.log"
