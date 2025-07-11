# Shell safety and reliability features
# Part of modular Makefile system

# Safety configuration
SHELL := /bin/sh
.SHELLFLAGS := -ec
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --no-builtin-variables

# Timeout for long-running operations (seconds)
TIMEOUT := 300
RETRY_COUNT := 3
RETRY_DELAY := 2

# Define safety functions as shell variables
define SAFETY_WRAPPER
set -e; \
trap 'echo "ERROR: Operation interrupted at line $$LINENO" >&2; exit 1' INT TERM; \
trap 'echo "ERROR: Operation failed at line $$LINENO" >&2; exit 1' ERR; \
timeout_cmd() { \
    if command -v timeout >/dev/null 2>&1; then \
        timeout $(TIMEOUT) "$$@"; \
    elif command -v gtimeout >/dev/null 2>&1; then \
        gtimeout $(TIMEOUT) "$$@"; \
    else \
        "$$@"; \
    fi; \
}; \
retry_cmd() { \
    local count=0; \
    while [ $$count -lt $(RETRY_COUNT) ]; do \
        if timeout_cmd "$$@"; then \
            return 0; \
        fi; \
        count=$$((count + 1)); \
        if [ $$count -lt $(RETRY_COUNT) ]; then \
            echo "Retry $$count/$(RETRY_COUNT) after $(RETRY_DELAY)s..."; \
            sleep $(RETRY_DELAY); \
        fi; \
    done; \
    echo "ERROR: Operation failed after $(RETRY_COUNT) attempts" >&2; \
    return 1; \
}; \
safe_exec() { \
    echo "Executing: $$*"; \
    retry_cmd "$$@"; \
}
endef

# Progress indicator for long operations
define PROGRESS_INDICATOR
progress_start() { \
    echo "Starting: $$1"; \
    printf "Progress: "; \
}; \
progress_update() { \
    printf "."; \
}; \
progress_end() { \
    printf " done\n"; \
}
endef

# Cleanup function for failed operations
define CLEANUP_HANDLER
cleanup_on_failure() { \
    local exit_code=$$?; \
    if [ $$exit_code -ne 0 ]; then \
        echo "Cleaning up after failure (exit code: $$exit_code)"; \
        rm -f "$$HOME/.dotfiles-lock" 2>/dev/null || true; \
        rm -f "/tmp/dotfiles-*" 2>/dev/null || true; \
    fi; \
    exit $$exit_code; \
}; \
trap cleanup_on_failure EXIT
endef

# Lock mechanism to prevent concurrent operations
define LOCK_MECHANISM
acquire_lock() { \
    local lockfile="$$HOME/.dotfiles-lock"; \
    if [ -f "$$lockfile" ]; then \
        local pid=$$(cat "$$lockfile" 2>/dev/null); \
        if [ -n "$$pid" ] && kill -0 "$$pid" 2>/dev/null; then \
            echo "ERROR: Another dotfiles operation is running (PID: $$pid)" >&2; \
            return 1; \
        fi; \
        rm -f "$$lockfile"; \
    fi; \
    echo "$$$$" > "$$lockfile"; \
}; \
release_lock() { \
    rm -f "$$HOME/.dotfiles-lock" 2>/dev/null || true; \
}; \
trap release_lock EXIT
endef

# Resource monitoring (prevent system overload)
define RESOURCE_MONITOR
check_resources() { \
    if command -v df >/dev/null 2>&1; then \
        local disk_usage=$$(df "$$HOME" | tail -1 | awk '{print $$5}' | sed 's/%//'); \
        if [ "$$disk_usage" -gt 90 ]; then \
            echo "WARNING: Disk usage is $$disk_usage% - operation may fail" >&2; \
        fi; \
    fi; \
    if command -v free >/dev/null 2>&1; then \
        local mem_usage=$$(free | grep Mem | awk '{printf "%.0f", $$3/$$2 * 100}'); \
        if [ "$$mem_usage" -gt 80 ]; then \
            echo "WARNING: Memory usage is $$mem_usage% - operation may be slow" >&2; \
        fi; \
    fi; \
}
endef

# Safe file operations
define SAFE_FILE_OPS
safe_mkdir() { \
    local dir="$$1"; \
    if [ ! -d "$$dir" ]; then \
        mkdir -p "$$dir" || { echo "ERROR: Failed to create directory: $$dir" >&2; return 1; }; \
    fi; \
}; \
safe_link() { \
    local src="$$1" dst="$$2"; \
    if [ ! -f "$$src" ] && [ ! -d "$$src" ]; then \
        echo "ERROR: Source does not exist: $$src" >&2; \
        return 1; \
    fi; \
    if [ -L "$$dst" ]; then \
        rm -f "$$dst"; \
    elif [ -e "$$dst" ]; then \
        echo "WARNING: Backing up existing file: $$dst.backup"; \
        mv "$$dst" "$$dst.backup"; \
    fi; \
    ln -sf "$$src" "$$dst" || { echo "ERROR: Failed to create symlink: $$dst" >&2; return 1; }; \
}; \
safe_copy() { \
    local src="$$1" dst="$$2"; \
    if [ ! -f "$$src" ]; then \
        echo "ERROR: Source file does not exist: $$src" >&2; \
        return 1; \
    fi; \
    cp "$$src" "$$dst" || { echo "ERROR: Failed to copy file: $$src -> $$dst" >&2; return 1; }; \
}
endef

# Network operation safety
define NETWORK_SAFETY
check_network() { \
    if ! timeout 5 ping -c 1 1.1.1.1 >/dev/null 2>&1; then \
        echo "WARNING: Network connectivity issues detected" >&2; \
        return 1; \
    fi; \
}; \
safe_network_op() { \
    if [ "$${OFFLINE_MODE:-0}" = "1" ]; then \
        echo "OFFLINE_MODE enabled - skipping network operation"; \
        return 0; \
    fi; \
    check_network || { echo "ERROR: Network check failed" >&2; return 1; }; \
}
endef

.PHONY: test-safety help-safety

# Test safety features
test-safety:
	@echo "Testing safety features..."
	@$(SAFETY_WRAPPER); \
	$(PROGRESS_INDICATOR); \
	$(CLEANUP_HANDLER); \
	$(LOCK_MECHANISM); \
	$(RESOURCE_MONITOR); \
	$(SAFE_FILE_OPS); \
	$(NETWORK_SAFETY); \
	progress_start "Safety test"; \
	check_resources; \
	progress_update; \
	safe_exec echo "Safety test passed"; \
	progress_end

# Help for safety features
help-safety:
	@echo "Safety Features:"
	@echo "  - Timeout protection ($(TIMEOUT)s default)"
	@echo "  - Retry logic ($(RETRY_COUNT) attempts)"
	@echo "  - Process locking (prevents concurrent runs)"
	@echo "  - Resource monitoring (disk/memory)"
	@echo "  - Graceful interrupt handling (Ctrl+C)"
	@echo "  - Automatic cleanup on failure"
	@echo "  - Safe file operations with backup"
	@echo "  - Network connectivity checks"
	@echo ""
	@echo "Environment variables:"
	@echo "  TIMEOUT=seconds     - Override default timeout"
	@echo "  RETRY_COUNT=number  - Override retry attempts"
	@echo "  OFFLINE_MODE=1      - Skip network operations"
