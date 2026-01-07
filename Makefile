ALL_ACCOUNTS_FILE := all_accounts_completion.ledger

help: URL := github.com/drdv/makefile-doc/releases/latest/download/makefile-doc.awk
help: DIR := $(HOME)/.local/share/makefile-doc
help: SCR := $(DIR)/makefile-doc.awk
help: ## Show this help
	@test -f $(SCR) || wget -q -P $(DIR) $(URL)
	@awk -f $(SCR) $(MAKEFILE_LIST)

acounts: ## Generate a file with all accounts
	@ledger accounts -E | sed 's/^/account /' > $(ALL_ACCOUNTS_FILE)

clean: ## Clean generated files
	@rm -f $(ALL_ACCOUNTS_FILE)
