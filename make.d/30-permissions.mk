# Permission management and security
# Part of modular Makefile system

.PHONY: fix-permissions

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
	@test -d "$(HOME)/.gnupg" && echo "[DRY-RUN] Would set .gnupg permission: chmod 700 $(HOME)/.gnupg" || true
	@test -d "$(HOME)/.ssh" && echo "[DRY-RUN] Would set .ssh permission: chmod 700 $(HOME)/.ssh" || true
	@test -d "$(HOME)/.backup" && echo "[DRY-RUN] Would set .backup permission: chmod 700 $(HOME)/.backup" || true
	@test -d "$(HOME)/.logs" && echo "[DRY-RUN] Would set .logs permission: chmod 700 $(HOME)/.logs" || true
else
	@test -d "$(HOME)/.gnupg" && chmod 700 "$(HOME)/.gnupg" || true
	@test -d "$(HOME)/.ssh" && chmod 700 "$(HOME)/.ssh" || true
	@test -d "$(HOME)/.backup" && chmod 700 "$(HOME)/.backup" || true
	@test -d "$(HOME)/.logs" && chmod 700 "$(HOME)/.logs" || true
endif
	@echo "Setting executable permissions for pinentry scripts..."
ifdef DRY_RUN
	@echo "[DRY-RUN] Would set pinentry script permissions: chmod 755 $(PWD)/bin/pinentry-*"
	@echo "[DRY-RUN] Would set pinentry script permissions: chmod 755 $(HOME)/bin/pinentry-*"
else
	@chmod 755 "$(PWD)/bin/pinentry-"* 2>/dev/null || true
	@chmod 755 "$(HOME)/bin/pinentry-"* 2>/dev/null || true
endif
	@echo "Creating symlinks with proper permissions..."
ifdef DRY_RUN
	@echo "[DRY-RUN] Would remove and recreate pinentry symlink:"
	@echo "[DRY-RUN]   rm -f $(HOME)/bin/pinentry-fallback"
	@echo "[DRY-RUN]   ln -sf $(PWD)/bin/pinentry-fallback $(HOME)/bin/pinentry-fallback"
else
	@# Remove and recreate pinentry symlink with 711 permissions (matching bin directory)
	@rm -f "$(HOME)/bin/pinentry-fallback"
	@umask 066 && ln -sf "$(PWD)/bin/pinentry-fallback" "$(HOME)/bin/pinentry-fallback" && umask 077
endif
	@echo "Permission fixes complete"
