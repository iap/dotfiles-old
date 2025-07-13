# Pinentry Troubleshooting Guide

## Overview
This guide helps resolve common issues with GPG pinentry authentication, particularly on macOS and Linux systems. Follow these steps to diagnose and fix pinentry problems.

## Common Issues and Solutions

### 1. GPG Agent Not Starting
**Symptoms**: GPG operations fail with "agent not available" errors.

**Solutions**:

```bash
# Restart GPG agent
gpg-connect-agent reloadagent /bye

# Kill and restart agent
gpgconf --kill gpg-agent
gpg-agent --daemon
```

### 2. Pinentry Not Found
**Symptoms**: Error messages like "pinentry: command not found" or "No pinentry".

**Solutions**:
- **macOS**: Install pinentry via MacPorts:

  ```bash
  sudo port install pinentry-mac
  ```

- **Linux**: Install pinentry package:

  ```bash
  # Ubuntu/Debian
  sudo apt install pinentry-gtk2
  
  # CentOS/RHEL
  sudo yum install pinentry-gtk
  ```

### 3. TTY Issues
**Symptoms**: Pinentry appears in wrong terminal window or fails to display.

**Solutions**:

```bash
# Set GPG_TTY in your shell profile
export GPG_TTY=$(tty)

# Update agent with current TTY
gpg-connect-agent updatestartuptty /bye
```

### 4. SSH Agent Integration
**Symptoms**: SSH authentication fails when using GPG keys.

**Solutions**:

```bash
# Add to ~/.gnupg/gpg-agent.conf
enable-ssh-support

# Restart GPG agent
gpgconf --kill gpg-agent
```

## Platform-Specific Issues

### macOS
- **SIP (System Integrity Protection)**: May interfere with pinentry. Use system-installed pinentry when possible.
- **Keychain Integration**: Ensure pinentry-mac is configured for macOS keychain integration.

### Linux
- **X11 Forwarding**: For remote sessions, ensure X11 forwarding is enabled:

  ```bash
  ssh -X user@host
  ```

- **Wayland**: Use pinentry-gtk2 or pinentry-qt for Wayland compatibility.

## Debugging Steps

### 1. Check GPG Agent Status

```bash
# Check if agent is running
gpg-connect-agent /bye

# View agent information
gpg-connect-agent 'getinfo version' /bye
```

### 2. Test Pinentry Manually

```bash
# Test pinentry directly
echo "GETPIN" | pinentry-mac

# Or for other systems
echo "GETPIN" | pinentry-gtk2
```

### 3. Check Configuration

```bash
# View current gpg-agent configuration
gpgconf --list-options gpg-agent

# Check pinentry program setting
gpgconf --list-options gpg-agent | grep pinentry-program
```

## Using the Pinentry Fallback Script

The dotfiles system includes a `pinentry-fallback` script that automatically selects the best available pinentry program.

### How It Works
1. Detects the operating system (macOS or Linux)
2. Checks for available pinentry programs in order of preference
3. Falls back to simpler pinentry options if GUI versions fail
4. Provides detailed logging for debugging

### Customization
Edit `~/.gnupg/gpg-agent.conf` to specify the fallback script:

```
pinentry-program $HOME/bin/pinentry-fallback
```

## Best Practices

### 1. Regular Maintenance
- Restart GPG agent periodically
- Update pinentry programs with system updates
- Clear GPG cache if experiencing persistent issues

### 2. Configuration Management
- Use consistent pinentry programs across environments
- Document custom configurations
- Test pinentry after system updates

### 3. Security Considerations
- Use trusted pinentry programs only
- Avoid storing passphrases in plaintext
- Regularly update GPG and pinentry versions

## Getting Help

If issues persist after following this guide:
1. Check GPG logs: `~/.gnupg/gpg-agent.log`
2. Enable debug logging in gpg-agent.conf: `debug-level expert`
3. Consult system-specific documentation for your pinentry program
4. Consider using a different pinentry program as a temporary workaround

## Conclusion
Proper pinentry configuration is crucial for seamless GPG operations. This guide addresses the most common issues and provides practical solutions. Regular maintenance and following best practices will minimize pinentry-related problems.
