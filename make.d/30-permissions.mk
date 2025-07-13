# Permission management and security
# Part of modular Makefile system

.PHONY: fix-permissions

# Sensitive directories and scripts
GNUPG_DIR := $(HOME)/.gnupg
SSH_DIR := $(HOME)/.ssh
BACKUP_DIR := $(HOME)/.backup
LOGS_DIR := $(HOME)/.logs
PINENTRY_SCRIPTS := $(PWD)/bin/pinentry-*

# Macro to set permissions
define set_permissions
	@test -d "$(1)" && chmod $(2) "$(1)" || echo "[INFO] Skipping: $(1) (not found)"
endef

# Fix directory and file permissions for GPG+SSH reliability
fix-permissions:
	@echo "Fixing directory and file permissions..."
	@echo "Setting directory permissions for security consistency..."
ifdef DRY_RUN
	@echo "[DRY-RUN] Would set HOME permission: chmod 711 $(HOME)"
	@echo "[DRY-RUN] Would set bin permission: chmod 711 $(HOME)/bin"
else
	@chmod 711 "$(HOME)"  # Home directory baseline
	@chmod 711 "$(HOME)/bin"  # Match home directory permissions
endif
	@echo "Setting secure permissions for sensitive directories..."
ifdef DRY_RUN
	@echo "[DRY-RUN] Would set permissions for sensitive directories:"
	@echo "[DRY-RUN]   $(GNUPG_DIR): chmod 700"
	@echo "[DRY-RUN]   $(SSH_DIR): chmod 700"
	@echo "[DRY-RUN]   $(BACKUP_DIR): chmod 700"
	@echo "[DRY-RUN]   $(LOGS_DIR): chmod 700"
else
	$(call set_permissions,$(GNUPG_DIR),700)
	$(call set_permissions,$(SSH_DIR),700)
	$(call set_permissions,$(BACKUP_DIR),700)
	$(call set_permissions,$(LOGS_DIR),700)
endif
	@echo "Setting executable permissions for pinentry scripts..."
ifdef DRY_RUN
	@echo "[DRY-RUN] Would set pinentry script permissions: chmod 755 $(PINENTRY_SCRIPTS)"
else
	@chmod 755 $(PINENTRY_SCRIPTS) 2>/dev/null || true
endif
	@echo "Creating symlinks with proper permissions..."
ifdef DRY_RUN
	@echo "[DRY-RUN] Would create symlink: $(HOME)/bin/pinentry-fallback"
else
	@ln -sf "$(PWD)/bin/pinentry-fallback" "$(HOME)/bin/pinentry-fallback"
endif
	@echo "Permission fixes complete"
