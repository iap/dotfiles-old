# Bootstrap and setup operations
# Part of modular Makefile system

.PHONY: bootstrap link-dotfiles setup-templates

# Full environment setup - corrected dependency order
bootstrap: validate-prerequisites link-dotfiles setup-templates validate-permissions validate clean-cache auto-cleanup
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
	@echo "Creating required directories with proper permissions..."
ifdef DRY_RUN
	@echo "[DRY-RUN] Would create directories:"
	@echo "[DRY-RUN]   mkdir -p $(HOME)/.config/env.d"
	@echo "[DRY-RUN]   mkdir -p $(HOME)/.logs $(HOME)/.cache $(HOME)/Projects"
	@echo "[DRY-RUN]   mkdir -p $(HOME)/.backup/system $(HOME)/.backup/projects $(HOME)/.backup/gpg $(HOME)/.backup/logs"
	@echo "[DRY-RUN]   mkdir -p $(HOME)/bin"
	@echo "[DRY-RUN]   mkdir -p $(HOME)/.local/share $(HOME)/.local/state"
	@echo "[DRY-RUN]   mkdir -p $(HOME)/.cache/vim/backup $(HOME)/.cache/vim/swap $(HOME)/.cache/vim/undo"
else
	@mkdir -p "$(HOME)/.config/env.d"
	@mkdir -p "$(HOME)/.logs" "$(HOME)/.cache" "$(HOME)/Projects"
	@mkdir -p "$(HOME)/.backup/system" "$(HOME)/.backup/projects" "$(HOME)/.backup/gpg" "$(HOME)/.backup/logs"
	@mkdir -p "$(HOME)/bin"
	@# Create XDG Base Directory structure
	@mkdir -p "$(HOME)/.local/share" "$(HOME)/.local/state"
	@# Create vim cache directories (referenced in vimrc)
	@mkdir -p "$(HOME)/.cache/vim/backup" "$(HOME)/.cache/vim/swap" "$(HOME)/.cache/vim/undo"
endif
	@# Set secure permissions for sensitive directories
ifdef DRY_RUN
	@echo "[DRY-RUN] Would set directory permissions:"
	@echo "[DRY-RUN]   chmod 700 $(HOME)/.backup $(HOME)/.logs"
	@echo "[DRY-RUN]   chmod 711 $(HOME)/bin"
	@echo "[DRY-RUN]   chmod 755 $(HOME)/.local $(HOME)/.local/share $(HOME)/.local/state"
else
	@chmod 700 "$(HOME)/.backup" "$(HOME)/.logs"
	@chmod 711 "$(HOME)/bin"  # Match home directory for consistency
	@chmod 755 "$(HOME)/.local"  # XDG directories should be accessible
	@chmod 755 "$(HOME)/.local/share" "$(HOME)/.local/state"
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
	@echo "Linking GPG configuration..."
ifdef DRY_RUN
	@echo "[DRY-RUN] Would create GPG directory: mkdir -p $(HOME)/.gnupg"
	@echo "[DRY-RUN] Would set GPG permissions: chmod 700 $(HOME)/.gnupg"
	@echo "[DRY-RUN] Would create GPG symlinks:"
	@echo "[DRY-RUN]   ln -sf $(PWD)/gnupg/gpg.conf $(HOME)/.gnupg/gpg.conf"
	@echo "[DRY-RUN] Would process template: $(PWD)/gnupg/gpg-agent.conf.template -> $(HOME)/.gnupg/gpg-agent.conf"
	@echo "[DRY-RUN] Would replace %h with $(HOME) in template"
	@echo "[DRY-RUN] Would set GPG file permissions: chmod 600 $(HOME)/.gnupg/gpg.conf $(HOME)/.gnupg/gpg-agent.conf"
else
	@mkdir -p "$(HOME)/.gnupg"
	@chmod 700 "$(HOME)/.gnupg"
	@ln -sf "$(PWD)/gnupg/gpg.conf" "$(HOME)/.gnupg/gpg.conf"
	@# Process gpg-agent.conf template with dynamic path substitution
	@sed 's|%h|$(HOME)|g' "$(PWD)/gnupg/gpg-agent.conf.template" > "$(HOME)/.gnupg/gpg-agent.conf"
	@echo "Processed GPG agent template: %h -> $(HOME)"
	@chmod 600 "$(HOME)/.gnupg/gpg.conf" "$(HOME)/.gnupg/gpg-agent.conf"
endif
	@echo "Linking SSH configuration..."
ifdef DRY_RUN
	@echo "[DRY-RUN] Would create SSH directory: mkdir -p $(HOME)/.ssh"
	@echo "[DRY-RUN] Would set SSH permissions: chmod 700 $(HOME)/.ssh"
	@echo "[DRY-RUN] Would create SSH symlinks:"
	@echo "[DRY-RUN]   ln -sf $(PWD)/ssh/config $(HOME)/.ssh/config"
	@echo "[DRY-RUN] Would set SSH file permissions: chmod 600 $(HOME)/.ssh/config"
	@echo "[DRY-RUN] Would create SSH files:"
	@echo "[DRY-RUN]   touch $(HOME)/.ssh/known_hosts $(HOME)/.ssh/known_hosts_local"
	@echo "[DRY-RUN] Would set SSH file permissions: chmod 600 $(HOME)/.ssh/known_hosts $(HOME)/.ssh/known_hosts_local"
else
	@mkdir -p "$(HOME)/.ssh"
	@chmod 700 "$(HOME)/.ssh"
	@ln -sf "$(PWD)/ssh/config" "$(HOME)/.ssh/config"
	@chmod 600 "$(HOME)/.ssh/config"
	@touch "$(HOME)/.ssh/known_hosts" "$(HOME)/.ssh/known_hosts_local"
	@chmod 600 "$(HOME)/.ssh/known_hosts" "$(HOME)/.ssh/known_hosts_local"
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
	@# Create symlinks with 711 permissions to match bin directory
	@old_umask=$$(umask); umask 066; \
		ln -sf "$(PWD)/bin/pinentry-fallback" "$(HOME)/bin/pinentry-fallback"; \
		ln -sf "$(PWD)/bin/ssh-keygen-secure" "$(HOME)/bin/ssh-keygen-secure"; \
		ln -sf "$(PWD)/bin/git-provider" "$(HOME)/bin/git-provider"; \
		ln -sf "$(PWD)/bin/gpg-setup" "$(HOME)/bin/gpg-setup"; \
		ln -sf "$(PWD)/bin/gpg-ssh" "$(HOME)/bin/gpg-ssh"; \
		umask $$old_umask
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
