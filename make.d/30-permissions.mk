# Permission management and security
# Part of modular Makefile system - optimized with common utilities

.PHONY: fix-permissions

# Note: Common paths and permission macros are now in 00-common.mk
# GNUPG_DIR, SSH_DIR, BACKUP_DIR, LOGS_DIR defined there
PINENTRY_SCRIPTS := $(PROJECT_BIN_DIR)/pinentry-*

# Fix directory and file permissions for GPG+SSH reliability
fix-permissions:
	$(call show_progress,Fixing directory and file permissions...)
	$(call log_action,Starting permission fixes)
	$(call set_permissions_safe,$(HOME),711)
	$(call set_permissions_safe,$(BIN_DIR),711)
	$(call show_progress,Setting secure permissions for sensitive directories...)
	$(call set_permissions_safe,$(GNUPG_DIR),700)
	$(call set_permissions_safe,$(SSH_DIR),700)
	$(call set_permissions_safe,$(SSH_DIR)/control,700)
	$(call set_permissions_safe,$(BACKUP_DIR),700)
	$(call set_permissions_safe,$(LOGS_DIR),700)
	$(call show_progress,Setting executable permissions for pinentry scripts...)
	$(call dry_run_or_execute,chmod 755 $(PINENTRY_SCRIPTS) 2>/dev/null || true)
	$(call show_progress,Permission fixes complete)
