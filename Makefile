.DEFAULT_GOAL := help
SHELL				  :=	/bin/bash
GIT					  := $(shell which git)
CONFIG_ROOT   := $(shell pwd)
PRIVATE_CONFIG_ROOT := $(shell pwd)/private
LN_FLAGS 			= -sfn

.PHONY: help brew emacs git ssh zsh zsh-setup

all: brew git zsh emacs ssh ## Installs all the config files on a osx

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
	@make zsh-setup
	@make zsh
	@make emacs-setup
	@make emacs
	@make hammerspoon
	@make controlplane
	@make osx
	@make ssh-setup
	@make ruby-setup
	@make python-setup
	@make node-setup
	@make tmux-setup
	@echo "Remember to import your gpg keys"
	@echo "Load the iterm settings from the file iterm/com.googlecode.iterm2.plist"
	@echo "Install Intellij Idea manually"
	@echo "Updated the Alfred license manually"
	@echo "Install docker for mac manually"

brew:: ## Configure brew Settings
ifeq ("$(wildcard /usr/local/bin/brew)","")
	@echo "Installing brew"
	@curl -fsSL -o /tmp/install https://raw.githubusercontent.com/Homebrew/install/master/install
	@/usr/bin/ruby /tmp/install
endif
	@echo "Installing all sw via brew"
	@brew tap homebrew/bundle
	@brew bundle --file=brew/Brewfile

controlplane:: ## Configure control plane
	@echo "Setting up controlplane"
	@cp controlplane/com.dustinrue.ControlPlane.plist ~/Library/Preferences/com.dustinrue.ControlPlane.plist
	@echo "Controlplane setup is done"

emacs-setup:: ## Configure emacs for fresh laptop
	@echo "Setting up emacs"
ifneq ("$(wildcard $(HOME)/.emacs.d)","")
	@echo "Backing up existing emacs configs"
	@mv $(HOME)/.emacs.d $(HOME)/.emacs.d_bkup
endif
	@echo "Installing spacemacs"
	@git clone https://github.com/syl20bnr/spacemacs ~/.emacs.d

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
	@echo "Setting up Hammerspoon"
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/hammerspoon ${HOME}/.hammerspoon

karabiner:: ## Install karabiner configs
	@echo "You might need to install karabiner manually. Since brew for karabiner is broken"
	@echo "Setting up karabiner"
	@mkdir -p "${HOME}/Library/Application Support/Karabiner"
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/karabiner/private.xml "${HOME}/Library/Application Support/Karabiner/private.xml"
	@echo "karabiner configuration completed"

node-setup:: ## Setting up node in a fresh laptop
	@echo "Configuring node"

osx:: ## Configure osx settings
	@echo "Configure osx dock settings"
	@cp osx/com.apple.dock.plist $(HOME)/Library/Preferences/com.apple.dock.plist
	@echo "Configuring finder to quit"
	@defaults write com.apple.finder QuitMenuItem -bool YES
	@killall Finder
	@echo "osx configuration is completed"

python-setup:: ##Setting up python in a fresh laptop
	@echo "Configuring python"
	@pyenv install 3.6.3
	@pyenv global 3.6.3

ruby-setup:: ## Setting up ruby in a fresh laptop
	@echo "Configuring ruby"
	@echo "Installing RVM"
	@curl -sSL -o install_ruby.sh https://get.rvm.io
	@bash install_ruby.sh
	@source $(HOME)/.rvm/scripts/rvm
	@rvm install 2.4
	@rvm use 2.4 --default

ssh-setup:: ## Setting up ssh for the first time
	@echo "Setting up ssh"
	@cp $(HOME)/.ssh/* $(CONFIG_ROOT)/ssh/
	@rm -Rf ${HOME}/.ssh
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/ssh ${HOME}/.ssh
	@chmod 700 ${HOME}/.ssh
	@touch ${HOME}/.ssh/authorized_keys
	@chmod 600 ${HOME}/.ssh/authorized_keys

ifneq ("$(wildcard $(PRIVATE_CONFIG_ROOT))","")
	@ln $(LN_FLAGS) $(PRIVATE_CONFIG_ROOT)/ssh/config ${HOME}/.ssh/config
else
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/ssh/default/config ${HOME}/.ssh/config
endif
	@echo "ssh configuration completed"

tmux-setup:: ## Setting up tmux for th first time
	@echo "Setting up tmux"
	@gem install tmuxinator
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/tmux/tmuxinator ${HOME}/.tmuxinator
	@mkdir -p $(HOME)/.tmuxinator/bin
	@curl -sSL -o $(HOME)/.tmuxinator/bin/tmuxinator.zsh https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/tmux/tmux.conf ${HOME}/.tmux.conf
	@echo "tmux configuration completed"

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
	@echo "Setting up iterm2 Shell Integrations"
	@curl -L -o $(HOME)/.iterm2_shell_integration.zsh https://iterm2.com/shell_integration/zsh

zsh:: ## Configure zsh Settings
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/zsh/zshrc ${HOME}/.zshrc

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
