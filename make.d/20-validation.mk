# Validation and compliance checking
# Part of modular Makefile system

.PHONY: validate validate-prerequisites validate-permissions check-compliance

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
	@! grep -r "/Users/" . --exclude-dir=.git --exclude-dir=make.d --exclude="README.md" --exclude="Makefile" || (echo "[ERROR] Hardcoded user paths found"; exit 1)
	@! grep -r "/home/" . --exclude-dir=.git --exclude-dir=make.d --exclude="README.md" --exclude="Makefile" || (echo "[ERROR] Hardcoded home paths found"; exit 1)
	@! grep -r "\.dotfiles" . --exclude-dir=.git --exclude-dir=make.d --exclude="README.md" --exclude="*.md" --exclude="Makefile" || (echo "[ERROR] Hardcoded .dotfiles references found"; exit 1)
	@echo "[OK] No hardcoded paths found"
	@echo "Checking dynamic path resolution..."
	@grep -q "(PWD)" make.d/*.mk && echo "[OK] Makefiles use dynamic paths" || (echo "[ERROR] Makefiles should use \$$(PWD)"; exit 1)
	@grep -q "%h" gnupg/gpg-agent.conf.template && echo "[OK] GPG template uses placeholder" || (echo "[ERROR] GPG template should use %h placeholder"; exit 1)
	@echo "Checking security settings..."
	@grep -q "umask 077" config/env.d/default.sh && echo "[OK] Secure umask configured" || (echo "[ERROR] umask 077 required"; exit 1)
	@grep -q "PATH.*sed.*\\.(:|$$)" config/env.d/default.sh && echo "[OK] PATH hardening configured" || (echo "[ERROR] PATH hardening required"; exit 1)
	@echo "Checking logging standards..."
	@grep -q "log()" config/env.d/default.sh && echo "[OK] Logging function available" || (echo "[ERROR] log() function required"; exit 1)
	@echo "System validation complete"

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
		if [ "$$SYM_PERM" = "711" ]; then \
			echo "[OK] pinentry-fallback symlink permissions: $$SYM_PERM"; \
		else \
			echo "[WARNING] pinentry-fallback symlink permissions: $$SYM_PERM (should be 711)"; \
		fi;\
	fi
	@echo "Permission validation complete"

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
