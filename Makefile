# Dotfiles Makefile
# Minimal POSIX-compatible development environment management

.PHONY: bootstrap validate validate-prerequisites link-dotfiles clean-cache backup setup-templates auto-cleanup check-compliance fix-permissions validate-permissions help

# Default target
help:
	@echo "Available targets:"
	@echo "  bootstrap      - Setup complete environment"
	@echo "  validate       - Comprehensive system and path validation"
	@echo "  validate-prerequisites - Check basic requirements before setup"
	@echo "  link-dotfiles  - Create symbolic links"
	@echo "  clean-cache    - Clear cache directory"
	@echo "  backup         - Backup essential files"
	@echo "  setup-templates - Setup local configuration templates"
	@echo "  auto-cleanup   - Clean old logs and backups (7+ days)"
	@echo "  check-compliance - Full system compliance check"
	@echo "  fix-permissions - Fix directory and file permissions"
	@echo "  validate-permissions - Validate security permissions"

# Full environment setup - corrected dependency order
bootstrap: validate-prerequisites link-dotfiles setup-templates validate-permissions validate clean-cache auto-cleanup
	@echo "Dotfiles environment setup complete"
	@echo "Please restart your shell or run: source ~/.zshrc"
	@echo ""
	@echo "Local configuration files created from templates:"
	@echo "  ~/.gitconfig.local  - Git user settings (name, email, GPG key)"
	@echo "  ~/.ssh/config.local - SSH host configurations"
	@echo "  ~/.forward.local    - Email forwarding addresses"

# Prerequisites validation - runs first to ensure environment is ready
validate-prerequisites:
	@echo "Validating prerequisites for bootstrap..."
	@echo "Checking basic system requirements..."
	@test -d "$(HOME)" || (echo "ERROR: HOME directory not found"; exit 1)
	@test -x "$$(which vim)" || (echo "ERROR: vim not found - install required"; exit 1)
	@test -x "$$(which git)" || (echo "ERROR: git not found - install required"; exit 1) 
	@echo "Checking write permissions..."
	@test -w "$(HOME)" || (echo "ERROR: Cannot write to HOME directory"; exit 1)
	@echo "Checking dotfiles directory..."
	@test -d "$(PWD)" || (echo "ERROR: Dotfiles directory not found"; exit 1)
	@test -f "$(PWD)/zshrc" || (echo "ERROR: Essential dotfiles missing"; exit 1)
	@echo "Prerequisites validation complete"

# Comprehensive system validation
validate:
	@echo "Validating system configuration and paths..."
	@test -d "$(HOME)" || (echo "ERROR: HOME directory not found"; exit 1)
	@if [ "$$(uname)" = "Darwin" ]; then \
		test "$$(stat -f '%p' $(HOME) 2>/dev/null | tail -c 4)" = "711" || echo "WARNING: HOME permissions should be 711"; \
	else \
		test "$$(stat -c '%a' $(HOME) 2>/dev/null)" = "711" || echo "WARNING: HOME permissions should be 711"; \
	fi
	@test -x "$$(which vim)" || (echo "ERROR: vim not found"; exit 1)
	@test -x "$$(which git)" || (echo "ERROR: git not found"; exit 1)
	@if [ -d "$(HOME)/.backup" ]; then \
		if [ "$$(uname)" = "Darwin" ]; then \
			test "$$(stat -f '%p' $(HOME)/.backup 2>/dev/null | tail -c 4)" = "700" || echo "WARNING: .backup should have 700 permissions"; \
		else \
			test "$$(stat -c '%a' $(HOME)/.backup 2>/dev/null)" = "700" || echo "WARNING: .backup should have 700 permissions"; \
		fi; \
	fi
	@echo "Validating GPG configuration..."
	@if [ -d "$(HOME)/.gnupg" ]; then \
		if [ "$$(uname)" = "Darwin" ]; then \
			test "$$(stat -f '%p' $(HOME)/.gnupg 2>/dev/null | tail -c 4)" = "700" || echo "WARNING: .gnupg should have 700 permissions"; \
		else \
			test "$$(stat -c '%a' $(HOME)/.gnupg 2>/dev/null)" = "700" || echo "WARNING: .gnupg should have 700 permissions"; \
		fi; \
	fi
	@test -f "$(HOME)/.gnupg/gpg.conf" || echo "WARNING: GPG config not found"
	@test -x "$$(which gpg)" || echo "WARNING: GPG not found - install with: sudo port install gnupg2"
	@echo "Validating SSH configuration..."
	@if [ -d "$(HOME)/.ssh" ]; then \
		if [ "$$(uname)" = "Darwin" ]; then \
			test "$$(stat -f '%p' $(HOME)/.ssh 2>/dev/null | tail -c 4)" = "700" || echo "WARNING: .ssh should have 700 permissions"; \
		else \
			test "$$(stat -c '%a' $(HOME)/.ssh 2>/dev/null)" = "700" || echo "WARNING: .ssh should have 700 permissions"; \
		fi; \
	fi
	@test -f "$(HOME)/.ssh/config" || echo "WARNING: SSH config not found"
	@echo "Checking for hardcoded paths..."
	@! grep -r "/Users/" . --exclude-dir=.git --exclude="README.md" --exclude="Makefile" || (echo "[ERROR] Hardcoded user paths found"; exit 1)
	@! grep -r "/home/" . --exclude-dir=.git --exclude="README.md" --exclude="Makefile" || (echo "[ERROR] Hardcoded home paths found"; exit 1)
	@! grep -r "\.dotfiles" . --exclude-dir=.git --exclude="README.md" --exclude="*.md" --exclude="Makefile" || (echo "[ERROR] Hardcoded .dotfiles references found"; exit 1)
	@echo "[OK] No hardcoded paths found"
	@echo "Checking dynamic path resolution..."
	@grep -q "\$$(PWD)" Makefile && echo "[OK] Makefile uses dynamic paths" || (echo "[ERROR] Makefile should use \$$(PWD)"; exit 1)
	@grep -q "%h" gnupg/gpg-agent.conf && echo "[OK] GPG config uses placeholder" || (echo "[ERROR] GPG config should use %h placeholder"; exit 1)
	@echo "Checking security settings..."
	@grep -q "umask 077" config/env.d/default.sh && echo "[OK] Secure umask configured" || (echo "[ERROR] umask 077 required"; exit 1)
	@grep -q "PATH.*sed.*\\.(:|$)" config/env.d/default.sh && echo "[OK] PATH hardening configured" || (echo "[ERROR] PATH hardening required"; exit 1)
	@echo "Checking logging standards..."
	@grep -q "log()" config/env.d/default.sh && echo "[OK] Logging function available" || (echo "[ERROR] log() function required"; exit 1)
	@echo "System validation complete"

# Fix directory and file permissions for GPG+SSH reliability
fix-permissions:
	@echo "Fixing directory and file permissions..."
	@echo "Setting directory permissions for security consistency..."
	@chmod 711 "$(HOME)"  # Home directory baseline
	@chmod 711 "$(HOME)/bin"  # Match home directory permissions
	@echo "Setting secure permissions for sensitive directories..."
	@test -d "$(HOME)/.gnupg" && chmod 700 "$(HOME)/.gnupg" || true
	@test -d "$(HOME)/.ssh" && chmod 700 "$(HOME)/.ssh" || true
	@test -d "$(HOME)/.backup" && chmod 700 "$(HOME)/.backup" || true
	@test -d "$(HOME)/.logs" && chmod 700 "$(HOME)/.logs" || true
	@echo "Setting executable permissions for pinentry scripts..."
	@chmod 755 "$(PWD)/bin/pinentry-"* 2>/dev/null || true
	@chmod 755 "$(HOME)/bin/pinentry-"* 2>/dev/null || true
	@echo "Creating symlinks with proper permissions..."
	@# Remove and recreate pinentry symlink with 711 permissions (matching bin directory)
	@rm -f "$(HOME)/bin/pinentry-fallback"
	@umask 066 && ln -sf "$(PWD)/bin/pinentry-fallback" "$(HOME)/bin/pinentry-fallback" && umask 077
	@echo "Permission fixes complete"

# Validate security permissions
validate-permissions:
	@echo "Validating security permissions..."
	@echo "Checking directory permissions..."
	@if [ "$$(uname)" = "Darwin" ]; then \
		HOME_PERM=$$(stat -f '%p' $(HOME) 2>/dev/null | tail -c 4); \
		BIN_PERM=$$(stat -f '%p' $(HOME)/bin 2>/dev/null | tail -c 4); \
	else \
		HOME_PERM=$$(stat -c '%a' $(HOME) 2>/dev/null); \
		BIN_PERM=$$(stat -c '%a' $(HOME)/bin 2>/dev/null); \
	fi; \
	if [ "$$HOME_PERM" = "711" ]; then \
		echo "[OK] HOME directory permissions: $$HOME_PERM"; \
	else \
		echo "[WARNING] HOME directory permissions: $$HOME_PERM (should be 711)"; \
	fi; \
	if [ "$$BIN_PERM" = "711" ]; then \
		echo "[OK] bin directory permissions: $$BIN_PERM"; \
	else \
		echo "[WARNING] bin directory permissions: $$BIN_PERM (should be 711)"; \
	fi
	@echo "Checking sensitive directory permissions..."
	@for dir in .gnupg .ssh .backup .logs; do \
		if [ -d "$(HOME)/$$dir" ]; then \
			if [ "$$(uname)" = "Darwin" ]; then \
				PERM=$$(stat -f '%p' $(HOME)/$$dir 2>/dev/null | tail -c 4); \
			else \
				PERM=$$(stat -c '%a' $(HOME)/$$dir 2>/dev/null); \
			fi; \
			if [ "$$PERM" = "700" ]; then \
				echo "[OK] $$dir permissions: $$PERM"; \
			else \
				echo "[WARNING] $$dir permissions: $$PERM (should be 700)"; \
			fi; \
		fi; \
	done
	@echo "Checking XDG directory structure..."
	@for dir in .local .local/share .local/state .cache/vim; do \
		if [ -d "$(HOME)/$$dir" ]; then \
			echo "[OK] $$dir directory exists"; \
		else \
			echo "[WARNING] $$dir directory missing"; \
		fi; \
	done
	@echo "Checking pinentry script permissions..."
	@if [ -f "$(HOME)/bin/pinentry-fallback" ]; then \
		if [ -x "$(HOME)/bin/pinentry-fallback" ]; then \
			echo "[OK] pinentry-fallback is executable"; \
		else \
			echo "[ERROR] pinentry-fallback is not executable"; \
		fi; \
	else \
		echo "[WARNING] pinentry-fallback not found"; \
	fi
	@echo "Checking symlink permissions..."
	@if [ -L "$(HOME)/bin/pinentry-fallback" ]; then \
		if [ "$$(uname)" = "Darwin" ]; then \
			SYM_PERM=$$(stat -f '%p' $(HOME)/bin/pinentry-fallback 2>/dev/null | tail -c 4); \
		else \
			SYM_PERM=$$(stat -c '%a' $(HOME)/bin/pinentry-fallback 2>/dev/null); \
		fi; \
		if [ "$$SYM_PERM" = "755" ]; then \
			echo "[OK] pinentry-fallback symlink permissions: $$SYM_PERM"; \
		else \
			echo "[WARNING] pinentry-fallback symlink permissions: $$SYM_PERM (should be 755)"; \
		fi;
	fi
	@echo "Permission validation complete"

# Create symbolic links for dotfiles with proper permissions
link-dotfiles:
	@echo "Linking dotfiles with secure permissions..."
	@echo "Setting baseline directory permissions..."
	@chmod 711 "$(HOME)"  # Home directory baseline
	@echo "Creating required directories with proper permissions..."
	@mkdir -p "$(HOME)/.config/env.d"
	@mkdir -p "$(HOME)/.logs" "$(HOME)/.cache" "$(HOME)/Projects"
	@mkdir -p "$(HOME)/.backup/system" "$(HOME)/.backup/projects" "$(HOME)/.backup/gpg" "$(HOME)/.backup/logs"
	@mkdir -p "$(HOME)/bin"
	@# Create XDG Base Directory structure
	@mkdir -p "$(HOME)/.local/share" "$(HOME)/.local/state"
	@# Create vim cache directories (referenced in vimrc)
	@mkdir -p "$(HOME)/.cache/vim/backup" "$(HOME)/.cache/vim/swap" "$(HOME)/.cache/vim/undo"
	@# Set secure permissions for sensitive directories
	@chmod 700 "$(HOME)/.backup" "$(HOME)/.logs"
	@chmod 711 "$(HOME)/bin"  # Match home directory for consistency
	@chmod 755 "$(HOME)/.local"  # XDG directories should be accessible
	@chmod 755 "$(HOME)/.local/share" "$(HOME)/.local/state"
	@ln -sf "$(PWD)/config/env.d/default.sh" "$(HOME)/.config/env.d/default.sh"
	@ln -sf "$(PWD)/zshrc" "$(HOME)/.zshrc"
	@ln -sf "$(PWD)/bashrc" "$(HOME)/.bashrc"
	@ln -sf "$(PWD)/profile" "$(HOME)/.profile"
	@ln -sf "$(PWD)/vimrc" "$(HOME)/.vimrc"
	@ln -sf "$(PWD)/gitconfig" "$(HOME)/.gitconfig"
	@ln -sf "$(PWD)/gitignore_global" "$(HOME)/.gitignore_global"
	@git config --global core.excludesfile "~/.gitignore_global" 2>/dev/null || true
	@ln -sf "$(PWD)/hushlogin" "$(HOME)/.hushlogin"
	@echo "Linking GPG configuration..."
	@mkdir -p "$(HOME)/.gnupg"
	@chmod 700 "$(HOME)/.gnupg"
	@ln -sf "$(PWD)/gnupg/gpg.conf" "$(HOME)/.gnupg/gpg.conf"
	@cp "$(PWD)/gnupg/gpg-agent.conf" "$(HOME)/.gnupg/gpg-agent.conf"
	@# gpg-agent.conf is copied from dotfiles and already contains correct pinentry path
	@chmod 600 "$(HOME)/.gnupg/gpg.conf" "$(HOME)/.gnupg/gpg-agent.conf"
	@echo "Linking SSH configuration..."
	@mkdir -p "$(HOME)/.ssh"
	@chmod 700 "$(HOME)/.ssh"
	@ln -sf "$(PWD)/ssh/config" "$(HOME)/.ssh/config"
	@chmod 600 "$(HOME)/.ssh/config"
	@touch "$(HOME)/.ssh/known_hosts" "$(HOME)/.ssh/known_hosts_local"
	@chmod 600 "$(HOME)/.ssh/known_hosts" "$(HOME)/.ssh/known_hosts_local"
	@echo "Linking bin scripts with proper permissions..."
	@# Ensure source scripts are executable
	@chmod 755 "$(PWD)/bin/pinentry-"* "$(PWD)/bin/ssh-keygen-secure" "$(PWD)/bin/gpg-setup" "$(PWD)/bin/git-provider" "$(PWD)/bin/gpg-ssh" 2>/dev/null || true
	@# Create symlinks with 711 permissions to match bin directory
	@old_umask=$$(umask); umask 022; \
		ln -sf "$(PWD)/bin/pinentry-fallback" "$(HOME)/bin/pinentry-fallback"; \
		ln -sf "$(PWD)/bin/ssh-keygen-secure" "$(HOME)/bin/ssh-keygen-secure"; \
		ln -sf "$(PWD)/bin/git-provider" "$(HOME)/bin/git-provider"; \
		ln -sf "$(PWD)/bin/gpg-setup" "$(HOME)/bin/gpg-setup"; \
		ln -sf "$(PWD)/bin/gpg-ssh" "$(HOME)/bin/gpg-ssh"; \
		umask $$old_umask
	@echo "Dotfiles linked successfully"

# Clean cache directory
clean-cache:
	@echo "Cleaning cache directory..."
	@rm -rf "$(HOME)/.cache"
	@mkdir -p "$(HOME)/.cache"
	@echo "Cache cleaned"

# Backup essential files
backup:
	@echo "Creating backup..."
	@mkdir -p "$(HOME)/.backup/system"
	@cp -r "$(PWD)" "$(HOME)/.backup/system/dotfiles" 2>/dev/null || true
	@test -f "$(HOME)/.zsh_history" && cp "$(HOME)/.zsh_history" "$(HOME)/.backup/system/" || true
	@echo "Backup created in $(HOME)/.backup/system/"

# Setup local configuration templates
# Local files can override defaults from dotfiles
setup-templates:
	@echo "Setting up local configuration templates..."
	@if [ ! -f "$(HOME)/.gitconfig.local" ]; then \
		cp "$(PWD)/template/gitconfig.local" "$(HOME)/.gitconfig.local"; \
		echo "Created ~/.gitconfig.local from template"; \
	else \
		echo "~/.gitconfig.local already exists"; \
	fi
	@if [ ! -f "$(HOME)/.ssh/config.local" ]; then \
		cp "$(PWD)/template/config.local" "$(HOME)/.ssh/config.local"; \
		echo "Created ~/.ssh/config.local from template"; \
	else \
		echo "~/.ssh/config.local already exists"; \
	fi
	@if [ ! -f "$(HOME)/.forward.local" ]; then \
		cp "$(PWD)/template/forward.local" "$(HOME)/.forward.local"; \
		echo "Created ~/.forward.local from template"; \
	else \
		echo "~/.forward.local already exists"; \
	fi
	@if [ ! -f "$(HOME)/.config/env.d/default.local.sh" ]; then \
		cp "$(PWD)/template/default.local.sh" "$(HOME)/.config/env.d/default.local.sh"; \
		echo "Created ~/.config/env.d/default.local.sh from template"; \
	else \
		echo "~/.config/env.d/default.local.sh already exists"; \
	fi
	@if [ ! -f "$(HOME)/.profile.local" ]; then \
		cp "$(PWD)/template/profile.local" "$(HOME)/.profile.local"; \
		echo "Created ~/.profile.local from template"; \
	else \
		echo "~/.profile.local already exists"; \
	fi
	@ln -sf "$(HOME)/.forward.local" "$(HOME)/.forward"
	@echo "Local configuration templates setup complete"

# Auto-cleanup old logs and backups (per rules: 7+ days)
auto-cleanup:
	@echo "Cleaning old logs and backups (7+ days)..."
	@find "$(HOME)/.logs" -type f -mtime +7 -exec rm -f {} \; 2>/dev/null || true
	@find "$(HOME)/.backup/logs" -type f -mtime +7 -exec rm -f {} \; 2>/dev/null || true
	@echo "Auto-cleanup complete"


# Full system compliance check
check-compliance: validate
	@echo "Performing full system compliance check..."
	@echo "Checking shell syntax..."
	@zsh -n zshrc && echo "[OK] zshrc syntax OK" || (echo "[ERROR] zshrc syntax error"; exit 1)
	@bash -n bashrc && echo "[OK] bashrc syntax OK" || (echo "[ERROR] bashrc syntax error"; exit 1)
	@sh -n profile && echo "[OK] profile syntax OK" || (echo "[ERROR] profile syntax error"; exit 1)
	@echo "Checking script standards..."
	@for script in bin/*; do \
		if [ -f "$$script" ]; then \
			head -1 "$$script" | grep -q "#!/bin/sh" && echo "[OK] $$script uses POSIX shell" || echo "[WARNING] $$script may not be POSIX compatible"; \
			grep -q "usage()" "$$script" && echo "[OK] $$script has usage function" || echo "[WARNING] $$script missing usage function"; \
		fi; \
	done
	@echo "Checking template system..."
	@test -d template && echo "[OK] Template directory exists" || (echo "[ERROR] template/ directory required"; exit 1)
	@test -f template/gitconfig.local && echo "[OK] Git template exists" || (echo "[ERROR] gitconfig.local template required"; exit 1)
	@echo "[OK] Full compliance check complete"

