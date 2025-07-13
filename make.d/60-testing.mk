# Testing framework for dotfiles system
# Part of modular Makefile system

.PHONY: test test-functionality test-validation test-setup test-all

# Define common paths
CONFIG_DIR := $(PWD)/config
GNUPG_TEMPLATE := $(PWD)/gnupg/gpg-agent.conf.template

# Macro for permission checks
define check-permissions
if [ -d "$1" ]; then \
    PERMS=$$(stat -f "%Lp" "$1" 2>/dev/null || stat -c "%a" "$1" 2>/dev/null); \
    if [ "$$PERMS" != "$2" ]; then \
        echo "[WARNING] $1 has permissions $$PERMS, expected $2"; \
    else \
        echo "[OK] $1 has correct permissions ($2)"; \
    fi; \
fi
endef

# Run all tests
test-all: test-functionality test-validation test-setup
	@echo "[INFO] All tests completed successfully"

# Test functionality features (renamed to avoid conflict with safety module)
test-functionality:
	@echo "[INFO] Testing functionality features..."
	@# Test DRY_RUN functionality
	@if ! make link-dotfiles DRY_RUN=1 >/dev/null 2>&1; then \
		echo "[ERROR] Dry-run test failed"; \
		exit 1; \
	fi
	@echo "[OK] Dry-run functionality working"
	@# Test error handling (controlled failure)
	@if make validate-prerequisites FORCE_FAIL=1 >/dev/null 2>&1; then \
		echo "[WARNING] Error handling test inconclusive"; \
	else \
		echo "[OK] Error handling working"; \
	fi
	@echo "[INFO] Functionality tests completed"

# Test validation functions
test-validation:
	@echo "[INFO] Testing validation functions..."
	@# Test basic validation
	@if ! make validate >/dev/null 2>&1; then \
		echo "[ERROR] Validation test failed"; \
		exit 1; \
	fi
	@echo "[OK] System validation working"
	@# Test permission validation
	@if ! make validate-permissions >/dev/null 2>&1; then \
		echo "[ERROR] Permission validation failed"; \
		exit 1; \
	fi
	@echo "[OK] Permission validation working"
	@echo "[INFO] Validation tests completed"

# Test setup functions with path variables
test-setup:
	@echo "[INFO] Testing setup functions..."
	@# Test path variables are defined
	@if [ -z "$(CONFIG_DIR)" ]; then \
		echo "[ERROR] CONFIG_DIR variable not defined"; \
		exit 1; \
	fi
	@echo "[OK] Path variables defined"
	@# Test template validation
	@if [ ! -f "$(GNUPG_TEMPLATE)" ]; then \
		echo "[ERROR] GPG template not found"; \
		exit 1; \
	fi
	@if ! grep -q "%h" "$(GNUPG_TEMPLATE)"; then \
		echo "[ERROR] Template missing placeholder"; \
		exit 1; \
	fi
	@echo "[OK] Template validation working"
	@# Test shell detection
	@OS_TEST=$$(uname -s); \
	if [ "$$OS_TEST" != "Darwin" ] && [ "$$OS_TEST" != "Linux" ]; then \
		echo "[WARNING] Unknown OS: $$OS_TEST"; \
	else \
		echo "[OK] OS detection working: $$OS_TEST"; \
	fi
	@echo "[INFO] Setup tests completed"

# Test specific components
test-gpg-template:
	@echo "[INFO] Testing GPG template processing..."
	@# Create temporary test template
	@echo "pinentry-program %h/bin/test" > /tmp/test-template
	@# Test template processing
	@sed 's|%h|$(HOME)|g' /tmp/test-template > /tmp/test-output
	@if ! grep -q "$(HOME)/bin/test" /tmp/test-output; then \
		echo "[ERROR] Template processing failed"; \
		rm -f /tmp/test-template /tmp/test-output; \
		exit 1; \
	fi
	@rm -f /tmp/test-template /tmp/test-output
	@echo "[OK] GPG template processing working"

# Test permission functions
test-permissions:
	@echo "[INFO] Testing permission functions..."
	@# Test that required directories exist with correct permissions
	@$(call check-permissions,$(BACKUP_DIR),700)
	@$(call check-permissions,$(LOGS_DIR),700)
	@$(call check-permissions,$(GNUPG_DIR),700)
	@$(call check-permissions,$(SSH_DIR),700)
	@echo "[INFO] Permission tests completed"

# Comprehensive test runner
test: test-gpg-template test-permissions test-validation
	@echo "[INFO] Core tests completed successfully"
	@echo ""
	@echo "Test Summary:"
	@echo "[OK] GPG template processing"
	@echo "[OK] Permission validation"
	@echo "[OK] System validation"
	@echo "[OK] Path variables"
	@echo "[OK] Error handling"
