# Maintenance and cleanup operations
# Part of modular Makefile system

.PHONY: clean-cache backup auto-cleanup

# Clean cache directory
clean-cache:
	@echo "Cleaning cache directory..."
ifdef DRY_RUN
	@echo "[DRY-RUN] Would remove cache: rm -rf $(HOME)/.cache"
	@echo "[DRY-RUN] Would recreate cache: mkdir -p $(HOME)/.cache"
else
	@rm -rf "$(HOME)/.cache"
	@mkdir -p "$(HOME)/.cache"
endif
	@echo "Cache cleaned"

# Backup essential files
backup:
	@echo "Creating backup..."
ifdef DRY_RUN
	@echo "[DRY-RUN] Would create backup directory: mkdir -p $(HOME)/.backup/system"
	@echo "[DRY-RUN] Would copy dotfiles: cp -r $(PWD) $(HOME)/.backup/system/dotfiles"
	@test -f "$(HOME)/.zsh_history" && echo "[DRY-RUN] Would copy zsh history: cp $(HOME)/.zsh_history $(HOME)/.backup/system/" || true
	@echo "[DRY-RUN] Backup would be created in $(HOME)/.backup/system/"
else
	@mkdir -p "$(HOME)/.backup/system"
	@cp -r "$(PWD)" "$(HOME)/.backup/system/dotfiles" 2>/dev/null || true
	@test -f "$(HOME)/.zsh_history" && cp "$(HOME)/.zsh_history" "$(HOME)/.backup/system/" || true
	@echo "Backup created in $(HOME)/.backup/system/"
endif

# Auto-cleanup old logs and backups (per rules: 7+ days)
auto-cleanup:
	@echo "Cleaning old logs and backups (7+ days)..."
ifdef DRY_RUN
	@echo "[DRY-RUN] Would find and remove old logs:"
	@find "$(HOME)/.logs" -type f -mtime +7 2>/dev/null | head -10 | sed 's/^/[DRY-RUN]   Would remove: /' || true
	@echo "[DRY-RUN] Would find and remove old backup logs:"
	@find "$(HOME)/.backup/logs" -type f -mtime +7 2>/dev/null | head -10 | sed 's/^/[DRY-RUN]   Would remove: /' || true
else
	@find "$(HOME)/.logs" -type f -mtime +7 -exec rm -f {} \; 2>/dev/null || true
	@find "$(HOME)/.backup/logs" -type f -mtime +7 -exec rm -f {} \; 2>/dev/null || true
endif
	@echo "Auto-cleanup complete"
