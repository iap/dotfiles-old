# Environment Variable Setup Guide

## Overview
This guide explains how to set up environment variables in your system using the dotfiles framework. Properly configuring environment variables will ensure your system works efficiently and as expected.

## Base Environment Setup

### .config/env.d/default.sh
This is where global environment variables are set, providing a central location for all configurations.

```bash
# Sample default.sh content
export PATH="$HOME/bin:$PATH"
export EDITOR="vim"
export LANG="en_US.UTF-8"
```

## Key Environment Variables

### 1. PATH
- **Purpose**: Specifies the directories to search for executables.
- **Setup**: Prepend user-specific directories, like `~/bin`.

### 2. EDITOR
- **Purpose**: Defines the default editor for editing files.
- **Setup**: Set to preferred text editor, e.g., `vim`, `nano`.

### 3. LANG
- **Purpose**: Sets default locale.
- **Setup**: Configure based on region, e.g., `en_US.UTF-8`.

## Custom Configurations

### Creating a Local Override
- **File**: Create `~/.config/env.d/default.local.sh` for machine-specific settings.
- **Usage**: Add variables specific to the machine or session.

```bash
# Sample local override
export PATH="$HOME/.local/bin:$PATH"
```

## Best Practices
- **Source Order**: Always source local overrides after default settings.
- **Consistency**: Keep variable names consistent for cross-platform compatibility.
- **Security**: Avoid storing sensitive information directly in environment files.

## Conclusion
Setting up environment variables correctly ensures your system is configured for your workflow and enhances productivity. Customize and extend as needed while keeping security and best practices in mind.
