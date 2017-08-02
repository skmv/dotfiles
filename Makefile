.DEFAULT_GOAL := help
SHELL				  :=	/bin/bash
GIT					  := $(shell which git)
CONFIG_ROOT   := $(shell pwd)
PRIVATE_CONFIG_ROOT := $(shell pwd)/private
LN_FLAGS 			= -sfn

.PHONY: help install

all: emacs git ssh tmux zsh ## Installs all the config files on a osx

emacs:: ## Configure emacs Settings
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/emacs/spacemacs ${HOME}/.spacemacs
	@echo emacs configuration completed

git:: ## Configure git Settings
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/git/gitignore ${HOME}/.gitignore
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/git/gitconfig ${HOME}/.gitconfig
	@mkdir -p ~/.git-template
	@echo git configuration completed

hammerspoon:: ## Configure hammerspoon
	@echo Hammerspoon configuration completed

install-bin:: ## Install all Binaries needed
	@echo Installing

ssh:: ## Configure SSH Settings
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/ssh ${HOME}/.ssh
	@chmod 700 ${HOME}/.ssh
	@touch ${HOME}/.ssh/authorized_keys
	@chmod 600 ${HOME}/.ssh/authorized_keys
ifneq ("$(wildcard $(PRIVATE_CONFIG_ROOT))","")
	@ln $(LN_FLAGS) $(PRIVATE_CONFIG_ROOT)/ssh/config ${HOME}/.ssh/config
else
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/ssh/default/config ${HOME}/.ssh/config
endif
	@echo ssh configuration completed

tmux:: ## Configure tmux Settings
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/tmux/tmux.conf ${HOME}/.tmux.conf
	@echo tmux configuration completed

update:: ## Update the config repository
	$(GIT) pull && $(GIT) submodule foreach git checkout master && $(GIT) submodule foreach git pull

# Help text
define HELP_TEXT
Usage: make [TARGET]... [MAKEVAR1=SOMETHING]...

Mandatory variables:

Optional variables:

Available targets:
endef
export HELP_TEXT

# A help target including self-documenting targets (see the awk statement)
help: ## This help target
	$(banner)
	@echo "$$HELP_TEXT"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / \
		{printf "\033[36m%-30s\033[0m  %s\n", $$1, $$2}' $(MAKEFILE_LIST)