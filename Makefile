# -----------------------------------------------------------------
# Params
# -----------------------------------------------------------------

ALL_ACCOUNTS_FILE := all_accounts_completion.ledger

MEMBERS_FILE := members.json
MEMBERS_GITHUB_LINK := https://raw.githubusercontent.com/peshachko/peshachko.github.io/refs/heads/main/docs/data/members.json

TAGS_DIR := tags
TAGS_DIR_GENERATED := $(TAGS_DIR)/generated
TAG_SUFFIX := no_python
TAG_FILES := tag_member

LEDGER := ledger

# -----------------------------------------------------------------

ALLOWED_TAG_SUFFIX := python no_python
ifeq (,$(filter $(TAG_SUFFIX),$(ALLOWED_TAG_SUFFIX)))
$(error Invalid TAG_SUFFIX: '$(TAG_SUFFIX)'. Allowed suffixes: $(ALLOWED_TAG_SUFFIX))
endif

.PHONY: tags

help: URL := github.com/drdv/makefile-doc/releases/latest/download/makefile-doc.awk
help: DIR := $(HOME)/.local/share/makefile-doc
help: SCR := $(DIR)/makefile-doc.awk
help: ## Show this help
	@test -f $(SCR) || wget -q -P $(DIR) $(URL)
	@awk -f $(SCR) $(MAKEFILE_LIST)

accounts: ## Generate a file with all accounts
	$(LEDGER) accounts -E | sed 's/^/account /' > $(ALL_ACCOUNTS_FILE)

## Generate tags (with or without python support depending on TAG_SUFFIX)
tags: get-members | $(TAGS_DIR_GENERATED)
	$(foreach f,$(TAG_FILES),\
		cp $(TAGS_DIR)/$(f)_$(TAG_SUFFIX).ledger $(TAGS_DIR_GENERATED)/$(f).ledger)

get-members:
	test -f $(MEMBERS_FILE) || curl -f -sS -L -o $(MEMBERS_FILE) $(MEMBERS_GITHUB_LINK)

clean: ## Clean generated files
	rm -f $(ALL_ACCOUNTS_FILE) $(MEMBERS_FILE)
	rm -rf $(TAGS_DIR_GENERATED)

$(TAGS_DIR_GENERATED):
	@mkdir -p $@
