# Maintenance and cleanup operations
# Part of modular Makefile system - optimized with common utilities

.PHONY: clean-cache backup maintenance

# Note: Common paths and utilities are now in 00-common.mk
# CACHE_DIR, BACKUP_DIR, LOGS_DIR, and macros are defined there

# Clean cache directory
clean-cache:
	$(call show_progress,Cleaning cache directory...)
	$(call dry_run_or_execute,rm -rf "$(CACHE_DIR)")
	$(call create_directory_safe,$(CACHE_DIR))
	$(call show_progress,Cache cleaned)

# Backup essential files
backup:
	$(call show_progress,Creating backup...)
	$(call create_directory_safe,$(BACKUP_DIR)/system)
	$(call dry_run_or_execute,cp -r "$(PWD)" "$(BACKUP_DIR)/system/dotfiles" 2>/dev/null || true)
	$(call dry_run_or_execute,test -f "$(HOME)/.zsh_history" && cp "$(HOME)/.zsh_history" "$(BACKUP_DIR)/system/" || true)
	$(call show_progress,Backup created in $(BACKUP_DIR)/system/)

# Comprehensive maintenance (cleanup, duplicates, permissions, disk check)
maintenance:
	$(call show_progress,Running comprehensive maintenance...)
	$(call log_action,Starting maintenance via Makefile)
	@$(PROJECT_BIN_DIR)/maintenance
	$(call show_progress,Maintenance completed. Check logs: $(LOGS_DIR)/maintenance-cron.log)
