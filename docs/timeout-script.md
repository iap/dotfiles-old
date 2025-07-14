# Cross-Platform Timeout Script

## Overview

The `bin/timeout` script provides a consistent timeout command across macOS and Linux without requiring external package installations.

## Problem

- macOS lacks GNU `timeout` by default
- MacPorts has two different timeout packages (`timeout` vs `coreutils`)
- Users might install the wrong timeout tool
- Scripts need to work consistently across platforms

## Solution

A standalone shell script that:
1. Checks for available timeout implementations
2. Falls back to Perl `alarm()` on macOS
3. Provides consistent interface across platforms

## Implementation

### Priority Order
1. `gtimeout` (GNU coreutils via MacPorts)
2. `timeout` (Linux default)
3. Perl `alarm()` fallback (macOS built-in)

### Usage
```bash
timeout 30 ping google.com
timeout 5 curl -s https://httpbin.org/get
timeout 10 ssh user@server.tld
```

## Installation

1. Ensure `$HOME/.dotfiles/bin` is in your PATH:
   ```bash
   export PATH="$HOME/.dotfiles/bin:$PATH"
   ```

2. Make script executable:
   ```bash
   chmod +x $HOME/.dotfiles/bin/timeout
   ```

## Testing

Test the script works on your system:

```bash
# Test basic functionality
timeout 2 sleep 5  # Should timeout after 2 seconds

# Test with network command
timeout 3 ping -c 10 google.com  # Should stop after 3 seconds

# Test help
timeout --help
```

## Compatibility

- **macOS**: Uses Perl `alarm()` (built-in)
- **Linux**: Uses system `timeout` command
- **MacPorts**: Uses `gtimeout` if available

## Limitations

- Only supports basic timeout functionality
- No advanced GNU timeout options (signals, etc.)
- Duration must be in seconds only

## Future Improvements

- Add signal handling options
- Support for floating-point durations
- Better error reporting
- Unit tests

## Related

- MacPorts coreutils installation: `sudo port install coreutils`
- Platform-specific command handling patterns for cross-platform compatibility
