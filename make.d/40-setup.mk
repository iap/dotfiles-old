# Bootstrap and setup operations
# Part of modular Makefile system

# Path variables for maintainability
CONFIG_DIR := $(HOME)/.config
ENV_DIR := $(CONFIG_DIR)/env.d
BACKUP_DIR := $(HOME)/.backup
LOGS_DIR := $(HOME)/.logs
CACHE_DIR := $(HOME)/.cache
LOCAL_DIR := $(HOME)/.local
GNUPG_DIR := $(HOME)/.gnupg
SSH_DIR := $(HOME)/.ssh
BIN_DIR := $(HOME)/bin
VIM_CACHE_DIR := $(CACHE_DIR)/vim

# Error handling function for critical operations
define check_result
	@if [ $$? -ne 0 ]; then \
		echo "[ERROR] Failed: $(1)"; \
		exit 1; \
	fi
endef

.PHONY: bootstrap link-dotfiles setup-templates check-shell-defaults

# Full environment setup - corrected dependency order
bootstrap: validate-prerequisites link-dotfiles setup-templates check-shell-defaults validate-permissions validate clean-cache auto-cleanup
	@echo "Dotfiles environment setup complete"
	@echo "Please restart your shell or run: source ~/.zshrc"
	@echo ""
	@echo "Local configuration files created from templates:"
	@echo "  ~/.gitconfig.local  - Git user settings (name, email, GPG key)"
	@echo "  ~/.ssh/config.local - SSH host configurations"
	@echo "  ~/.forward.local    - Email forwarding addresses"

# Create symbolic links for dotfiles with proper permissions
link-dotfiles:
	@echo "Linking dotfiles with secure permissions..."
	@echo "Setting baseline directory permissions..."
ifdef DRY_RUN
	@echo "[DRY-RUN] Would set HOME permission: chmod 711 $(HOME)"
else
	@chmod 711 "$(HOME)"  # Home directory baseline
endif
	@echo "[INFO] Creating required directories with proper permissions..."
ifdef DRY_RUN
	@echo "[DRY-RUN] Would create directories:"
	@echo "[DRY-RUN]   mkdir -p $(ENV_DIR)"
	@echo "[DRY-RUN]   mkdir -p $(LOGS_DIR) $(CACHE_DIR) $(HOME)/Projects"
	@echo "[DRY-RUN]   mkdir -p $(BACKUP_DIR)/{system,projects,gpg,logs}"
	@echo "[DRY-RUN]   mkdir -p $(BIN_DIR)"
	@echo "[DRY-RUN]   mkdir -p $(LOCAL_DIR)/{share,state}"
	@echo "[DRY-RUN]   mkdir -p $(VIM_CACHE_DIR)/{backup,swap,undo}"
	@echo "[DRY-RUN] Would set directory permissions:"
	@echo "[DRY-RUN]   chmod 700 $(BACKUP_DIR) $(LOGS_DIR)"
	@echo "[DRY-RUN]   chmod 711 $(BIN_DIR)"
	@echo "[DRY-RUN]   chmod 755 $(LOCAL_DIR) $(LOCAL_DIR)/share $(LOCAL_DIR)/state"
else
	@# Create all directories in optimized batches
	@mkdir -p "$(ENV_DIR)" || { echo "[ERROR] Failed to create $(ENV_DIR)"; exit 1; }
	@mkdir -p "$(LOGS_DIR)" "$(CACHE_DIR)" "$(HOME)/Projects" || { echo "[ERROR] Failed to create core directories"; exit 1; }
	@mkdir -p "$(BACKUP_DIR)/system" "$(BACKUP_DIR)/projects" "$(BACKUP_DIR)/gpg" "$(BACKUP_DIR)/logs" || { echo "[ERROR] Failed to create backup directories"; exit 1; }
	@mkdir -p "$(BIN_DIR)" || { echo "[ERROR] Failed to create $(BIN_DIR)"; exit 1; }
	@mkdir -p "$(LOCAL_DIR)/share" "$(LOCAL_DIR)/state" || { echo "[ERROR] Failed to create XDG directories"; exit 1; }
	@mkdir -p "$(VIM_CACHE_DIR)/backup" "$(VIM_CACHE_DIR)/swap" "$(VIM_CACHE_DIR)/undo" || { echo "[ERROR] Failed to create vim cache directories"; exit 1; }
	@# Set secure permissions with error checking
	@chmod 700 "$(BACKUP_DIR)" "$(LOGS_DIR)" || { echo "[ERROR] Failed to set secure permissions"; exit 1; }
	@chmod 711 "$(BIN_DIR)" || { echo "[ERROR] Failed to set bin permissions"; exit 1; }
	@chmod 755 "$(LOCAL_DIR)" "$(LOCAL_DIR)/share" "$(LOCAL_DIR)/state" || { echo "[ERROR] Failed to set XDG permissions"; exit 1; }
	@echo "[INFO] Directory structure created successfully"
endif
ifdef DRY_RUN
	@echo "[DRY-RUN] Would create symlinks:"
	@echo "[DRY-RUN]   ln -sf $(PWD)/config/env.d/default.sh $(HOME)/.config/env.d/default.sh"
	@echo "[DRY-RUN]   ln -sf $(PWD)/zshrc $(HOME)/.zshrc"
	@echo "[DRY-RUN]   ln -sf $(PWD)/bashrc $(HOME)/.bashrc"
	@echo "[DRY-RUN]   ln -sf $(PWD)/profile $(HOME)/.profile"
	@echo "[DRY-RUN]   ln -sf $(PWD)/vimrc $(HOME)/.vimrc"
	@echo "[DRY-RUN]   ln -sf $(PWD)/gitconfig $(HOME)/.gitconfig"
	@echo "[DRY-RUN]   ln -sf $(PWD)/gitignore_global $(HOME)/.gitignore_global"
	@echo "[DRY-RUN]   ln -sf $(PWD)/hushlogin $(HOME)/.hushlogin"
	@echo "[DRY-RUN] Would run: git config --global core.excludesfile ~/.gitignore_global"
else
	@ln -sf "$(PWD)/config/env.d/default.sh" "$(HOME)/.config/env.d/default.sh"
	@ln -sf "$(PWD)/zshrc" "$(HOME)/.zshrc"
	@ln -sf "$(PWD)/bashrc" "$(HOME)/.bashrc"
	@ln -sf "$(PWD)/profile" "$(HOME)/.profile"
	@ln -sf "$(PWD)/vimrc" "$(HOME)/.vimrc"
	@ln -sf "$(PWD)/gitconfig" "$(HOME)/.gitconfig"
	@ln -sf "$(PWD)/gitignore_global" "$(HOME)/.gitignore_global"
	@git config --global core.excludesfile "~/.gitignore_global" 2>/dev/null || true
	@ln -sf "$(PWD)/hushlogin" "$(HOME)/.hushlogin"
endif
	@echo "[INFO] Linking GPG configuration..."
ifdef DRY_RUN
	@echo "[DRY-RUN] Would create GPG directory: mkdir -p $(GNUPG_DIR)"
	@echo "[DRY-RUN] Would set GPG permissions: chmod 700 $(GNUPG_DIR)"
	@echo "[DRY-RUN] Would create GPG symlinks:"
	@echo "[DRY-RUN]   ln -sf $(PWD)/gnupg/gpg.conf $(GNUPG_DIR)/gpg.conf"
	@echo "[DRY-RUN] Would process template: $(PWD)/gnupg/gpg-agent.conf.template -> $(GNUPG_DIR)/gpg-agent.conf"
	@echo "[DRY-RUN] Would replace %h with $(HOME) in template"
	@echo "[DRY-RUN] Would set GPG file permissions: chmod 600 $(GNUPG_DIR)/{gpg.conf,gpg-agent.conf}"
else
	@# Create GPG directory with secure permissions
	@mkdir -p "$(GNUPG_DIR)" || { echo "[ERROR] Failed to create $(GNUPG_DIR)"; exit 1; }
	@chmod 700 "$(GNUPG_DIR)" || { echo "[ERROR] Failed to set GPG directory permissions"; exit 1; }
	@# Link GPG configuration file
	@ln -sf "$(PWD)/gnupg/gpg.conf" "$(GNUPG_DIR)/gpg.conf" || { echo "[ERROR] Failed to link gpg.conf"; exit 1; }
	@# Process gpg-agent.conf template with dynamic path substitution and validation
	@if [ ! -f "$(PWD)/gnupg/gpg-agent.conf.template" ]; then echo "[ERROR] Template $(PWD)/gnupg/gpg-agent.conf.template not found"; exit 1; fi
	@if ! grep -q "%h" "$(PWD)/gnupg/gpg-agent.conf.template"; then echo "[ERROR] Template missing %h placeholder"; exit 1; fi
	@sed 's|%h|$(HOME)|g' "$(PWD)/gnupg/gpg-agent.conf.template" > "$(GNUPG_DIR)/gpg-agent.conf" || { echo "[ERROR] Failed to process GPG agent template"; exit 1; }
	@chmod 600 "$(GNUPG_DIR)/gpg.conf" "$(GNUPG_DIR)/gpg-agent.conf" || { echo "[ERROR] Failed to set GPG file permissions"; exit 1; }
	@echo "[INFO] GPG configuration linked successfully"
endif
	@echo "[INFO] Linking SSH configuration..."
ifdef DRY_RUN
	@echo "[DRY-RUN] Would create SSH directory: mkdir -p $(SSH_DIR)"
	@echo "[DRY-RUN] Would set SSH permissions: chmod 700 $(SSH_DIR)"
	@echo "[DRY-RUN] Would create SSH symlinks:"
	@echo "[DRY-RUN]   ln -sf $(PWD)/ssh/config $(SSH_DIR)/config"
	@echo "[DRY-RUN] Would set SSH file permissions: chmod 600 $(SSH_DIR)/config"
	@echo "[DRY-RUN] Would create SSH files:"
	@echo "[DRY-RUN]   touch $(SSH_DIR)/known_hosts $(SSH_DIR)/known_hosts_local"
	@echo "[DRY-RUN] Would set SSH file permissions: chmod 600 $(SSH_DIR)/{known_hosts,known_hosts_local}"
else
	@# Create SSH directory with secure permissions
	@mkdir -p "$(SSH_DIR)" || { echo "[ERROR] Failed to create $(SSH_DIR)"; exit 1; }
	@chmod 700 "$(SSH_DIR)" || { echo "[ERROR] Failed to set SSH directory permissions"; exit 1; }
	@# Link SSH configuration and create required files
	@ln -sf "$(PWD)/ssh/config" "$(SSH_DIR)/config" || { echo "[ERROR] Failed to link SSH config"; exit 1; }
	@touch "$(SSH_DIR)/known_hosts" "$(SSH_DIR)/known_hosts_local" || { echo "[ERROR] Failed to create SSH known_hosts files"; exit 1; }
	@chmod 600 "$(SSH_DIR)/config" "$(SSH_DIR)/known_hosts" "$(SSH_DIR)/known_hosts_local" || { echo "[ERROR] Failed to set SSH file permissions"; exit 1; }
	@echo "[INFO] SSH configuration linked successfully"
endif
	@echo "Linking bin scripts with proper permissions..."
ifdef DRY_RUN
	@echo "[DRY-RUN] Would set script permissions: chmod 755 $(PWD)/bin/pinentry-* $(PWD)/bin/ssh-keygen-secure $(PWD)/bin/gpg-setup $(PWD)/bin/git-provider $(PWD)/bin/gpg-ssh"
	@echo "[DRY-RUN] Would create bin symlinks:"
	@echo "[DRY-RUN]   ln -sf $(PWD)/bin/pinentry-fallback $(HOME)/bin/pinentry-fallback"
	@echo "[DRY-RUN]   ln -sf $(PWD)/bin/ssh-keygen-secure $(HOME)/bin/ssh-keygen-secure"
	@echo "[DRY-RUN]   ln -sf $(PWD)/bin/git-provider $(HOME)/bin/git-provider"
	@echo "[DRY-RUN]   ln -sf $(PWD)/bin/gpg-setup $(HOME)/bin/gpg-setup"
	@echo "[DRY-RUN]   ln -sf $(PWD)/bin/gpg-ssh $(HOME)/bin/gpg-ssh"
else
	@# Ensure source scripts are executable
	@chmod 755 "$(PWD)/bin/pinentry-"* "$(PWD)/bin/ssh-keygen-secure" "$(PWD)/bin/gpg-setup" "$(PWD)/bin/git-provider" "$(PWD)/bin/gpg-ssh" 2>/dev/null || true
	@# Create symlinks with controlled umask for security
	@OLD_UMASK=$$(umask); \
	umask 066; \
	ln -sf "$(PWD)/bin/pinentry-fallback" "$(HOME)/bin/pinentry-fallback"; \
	ln -sf "$(PWD)/bin/ssh-keygen-secure" "$(HOME)/bin/ssh-keygen-secure"; \
	ln -sf "$(PWD)/bin/git-provider" "$(HOME)/bin/git-provider"; \
	ln -sf "$(PWD)/bin/gpg-setup" "$(HOME)/bin/gpg-setup"; \
	ln -sf "$(PWD)/bin/gpg-ssh" "$(HOME)/bin/gpg-ssh"; \
	umask $$OLD_UMASK
endif
	@echo "Dotfiles linked successfully"

# Setup local configuration templates
# Local files can override defaults from dotfiles
setup-templates:
	@echo "Setting up local configuration templates..."
ifdef DRY_RUN
	@test ! -f "$(HOME)/.gitconfig.local" && echo "[DRY-RUN] Would copy: $(PWD)/template/gitconfig.local -> $(HOME)/.gitconfig.local" || echo "[DRY-RUN] $(HOME)/.gitconfig.local already exists"
	@test ! -f "$(HOME)/.ssh/config.local" && echo "[DRY-RUN] Would copy: $(PWD)/template/config.local -> $(HOME)/.ssh/config.local" || echo "[DRY-RUN] $(HOME)/.ssh/config.local already exists"
	@test ! -f "$(HOME)/.forward.local" && echo "[DRY-RUN] Would copy: $(PWD)/template/forward.local -> $(HOME)/.forward.local" || echo "[DRY-RUN] $(HOME)/.forward.local already exists"
	@test ! -f "$(HOME)/.config/env.d/default.local.sh" && echo "[DRY-RUN] Would copy: $(PWD)/template/default.local.sh -> $(HOME)/.config/env.d/default.local.sh" || echo "[DRY-RUN] $(HOME)/.config/env.d/default.local.sh already exists"
	@test ! -f "$(HOME)/.profile.local" && echo "[DRY-RUN] Would copy: $(PWD)/template/profile.local -> $(HOME)/.profile.local" || echo "[DRY-RUN] $(HOME)/.profile.local already exists"
	@echo "[DRY-RUN] Would create symlink: ln -sf $(HOME)/.forward.local $(HOME)/.forward"
else
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
endif
	@echo "Local configuration templates setup complete"

# Check and recommend shell defaults based on OS type
check-shell-defaults:
	@echo "Checking shell defaults for your system..."
	@case "$$(uname -s)" in \
		Darwin) OS_TYPE="macOS" ;; \
		Linux) OS_TYPE="linux" ;; \
		*) OS_TYPE="unknown" ;; \
	esac; \
	CURRENT_SHELL=$$(basename "$$SHELL"); \
	echo "Detected OS: $$OS_TYPE"; \
	echo "Current shell: $$CURRENT_SHELL"; \
	echo ""; \
	if [ "$$OS_TYPE" = "macOS" ]; then \
		RECOMMENDED="zsh"; \
		REASON="macOS default since Catalina"; \
	elif [ "$$OS_TYPE" = "linux" ]; then \
		if command -v zsh >/dev/null 2>&1; then \
			RECOMMENDED="zsh"; \
			REASON="modern features available"; \
		else \
			RECOMMENDED="bash"; \
			REASON="maximum compatibility"; \
		fi; \
	else \
		RECOMMENDED="bash"; \
		REASON="conservative fallback"; \
	fi; \
	echo "Recommended shell: $$RECOMMENDED ($$REASON)"; \
	echo ""; \
	if [ "$$CURRENT_SHELL" != "$$RECOMMENDED" ]; then \
		echo "Info: Shell recommendation"; \
		echo "  Your current shell ($$CURRENT_SHELL) differs from the recommended shell ($$RECOMMENDED)"; \
		echo "  To switch to $$RECOMMENDED, run:"; \
		echo "    chsh -s $$(command -v $$RECOMMENDED 2>/dev/null || echo "/bin/$$RECOMMENDED")"; \
		echo "  Then restart your terminal"; \
		echo ""; \
		echo "  Both shells are supported by this dotfiles configuration."; \
	else \
		echo "[OK] Your shell ($$CURRENT_SHELL) matches the recommendation for $$OS_TYPE"; \
	fi
