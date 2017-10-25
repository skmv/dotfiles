.DEFAULT_GOAL := help
SHELL				  :=	/bin/bash
GIT					  := $(shell which git)
CONFIG_ROOT   := $(shell pwd)
PRIVATE_CONFIG_ROOT := $(shell pwd)/private
LN_FLAGS 			= -sfn

.PHONY: help brew emacs git ssh tmux zsh zsh-setup

all: brew git zsh emacs ssh tmux ## Installs all the config files on a osx

setup:: ## Configure the laptop for fresh installation
	@echo "Setting up directory structure"
	@mkdir -p ~/projects/sw/repos/opensource
	@mkdir -p ~/projects/sw/repos/personal
	@mkdir -p ~/projects/sw/sandbox
	@mkdir -p ~/projects/sw/gospace

ifeq ("$(wildcard $(HOME)/projects/sw/repos/personal/configs)","")
	@echo "Downloading the config repository"
	@git clone git@github.com:ageekymonk/dotfiles.git $(HOME)/projects/sw/repos/personal/configs

	@echo "Jump to $(HOME)/projects/sw/repos/personal/configs and run make all"
endif

	@cd $(HOME)/projects/sw/repos/personal/configs
	@echo "Pulling in other submodules"
	@git submodule init
	@git submodule update

	@make git
	@make brew
	@make zsh
	@make emacs

	@echo "Remember to import your gpg keys"

emacs:: ## Configure emacs Settings
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/emacs/spacemacs ${HOME}/.spacemacs
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/emacs/layers/org-trello ${HOME}/.emacs.d/private/org-trello
	@echo emacs configuration completed

git:: ## Configure git Settings
	@echo "Setting up git"
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/git/gitignore ${HOME}/.gitignore
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/git/gitconfig ${HOME}/.gitconfig
	@mkdir -p ~/.git-template
	@git config user.name "ageekymonk"
	@git config user.email "ramzthecoder@gmail.com"
	@echo git configuration completed

hammerspoon:: ## Configure hammerspoon
	@echo Hammerspoon configuration completed

karabiner:: ## Install karabiner configs
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/karabiner/private.xml "${HOME}/Library/Application Support/Karabiner/private.xml"
	@echo karabiner configuration completed

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
	@wget https://raw.githubusercontent.com/wee-slack/wee-slack/master/wee_slack.py
	@mv wee_slack.py $(CONFIG_ROOT)/weechat/plugins/autoload/wee_slack.py

weechat:: ## Configure weechat settings
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/weechat ${HOME}/.weechat
ifneq ("$(wildcard $(PRIVATE_CONFIG_ROOT))","")
	@ln $(LN_FLAGS) $(PRIVATE_CONFIG_ROOT)/weechat/irc.conf ${HOME}/.weechat/irc.conf
	@ln $(LN_FLAGS) $(PRIVATE_CONFIG_ROOT)/weechat/plugins.conf ${HOME}/.weechat/plugins.conf
	@ln $(LN_FLAGS) $(PRIVATE_CONFIG_ROOT)/weechat/weechat.conf ${HOME}/.weechat/weechat.conf

else
	@echo "TODO Need to copy the default file."
endif
	@echo weechat configuration completed

zsh-setup:: ## Configure zsh for the fresh laptop
	@echo "Setting zsh as your default shell"
	@sudo dscl . -create /Users/$(USER) UserShell /usr/local/bin/zsh
	@echo "Installing oh my zsh"
	@curl -fsSL -o /tmp/install_zsh.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
	@sh /tmp/install_zsh.sh
	@rm /tmp/install_zsh.sh
	@echo "Installing powerlevel9 theme"
	@git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/themes/powerlevel9k

zsh:: ## Configure zsh Settings
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/zsh/zshrc ${HOME}/.zshrc

brew:: ## Configure brew Settings
ifeq ("$(wildcard /usr/local/bin/brew)","")
	@echo "Installing brew"
	@curl -fsSL -o /tmp/install https://raw.githubusercontent.com/Homebrew/install/master/install
	@/usr/bin/ruby /tmp/install
endif
	@echo "Installing all sw via brew"
	@brew tap homebrew/bundle
	@brew bundle --file=brew/Brewfile

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
