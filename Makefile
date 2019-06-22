.DEFAULT_GOAL := help
SHELL					:=	/bin/bash
GIT						:= $(shell which git)
CONFIG_ROOT   := $(HOME)/projects/sw/repos/person/dotfiles
PRIVATE_CONFIG_ROOT := $(CONFIG_ROOT)/private
LN_FLAGS			= -sfn
OS := $(shell uname -s)

.PHONY: help brew emacs git ssh zsh zsh-setup

setup-common:: ## Setup common configs
	@echo "Setting up directory structure"
	@mkdir -p ~/projects/sw/repos/opensource
	@mkdir -p ~/projects/sw/repos/personal
	@mkdir -p ~/projects/sw/sandbox
	@mkdir -p ~/projects/sw/gospace

ifeq ("$(wildcard $(HOME)/projects/sw/repos/personal/dotfiles)","")
	@echo "Downloading the config repository"
	@git clone https://github.com/ageekymonk/dotfiles.git $(HOME)/projects/sw/repos/personal/dotfiles
	@echo "Jump to $(HOME)/projects/sw/repos/personal/dotfile and run make all"
endif

setup-mac:: ## Setup mac
	@cd $(CONFIG_ROOT)
ifeq ($(OS),Darwin)
	@make brew
	@make hammerspoon
	@make osx
endif

setup:: setup-common setup-mac ## Configure the laptop for fresh installation
	@echo "Pulling in other submodules"
	@git submodule init
	@git submodule update

	@make git
	@make zsh-setup
	@make zsh
	@make emacs-setup
	@make emacs
	@make ssh-setup
	@make python-setup
	@make tmux-setup
	@echo "Remember to import your gpg keys"
	@echo "Load the iterm settings from the file iterm/com.googlecode.iterm2.plist"
	@echo "Install Intellij Idea"
	@echo "Updated the Alfred license manually"
	@echo "Install docker for mac manually"

azure:: ## Configure azure
	@echo "Installing Azure cli"
	@echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(shell lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
	@curl -L https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
	@sudo apt-get install -y apt-transport-https && sudo apt-get update && sudo apt-get install azure-cli

brew:: ## Configure brew Settings
ifeq ("$(wildcard /usr/local/bin/brew)","")
	@echo "Installing brew"
	@curl -fsSL -o /tmp/install https://raw.githubusercontent.com/Homebrew/install/master/install
	@/usr/bin/ruby /tmp/install
endif
	@echo "Installing all sw via brew"
	@brew tap homebrew/bundle
	@brew bundle --file=brew/Brewfile

linux:: ## Configure Linux Settings
	@sudo apt install -y build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev python-pip tmux unzip
	@sudo snap install --classic go
	@wget https://github.com/ogham/exa/releases/download/v0.8.0/exa-linux-x86_64-0.8.0.zip
	@unzip exa-linux-x86_64-0.8.0.zip
	@sudo mv exa-linux-x86_64 /usr/local/bin/exa
	@rm -Rf exa-linux-x86_64-0.8.0.zip
	@wget https://github.com/clvv/fasd/archive/1.0.1.zip
	@unzip 1.0.1.zip
	@rm -Rf 1.0.1.zip
	@sudo mv fasd-1.0.1/fasd /usr/local/bin/fasd

emacs-setup:: ## Configure emacs for fresh laptop
	@echo "Setting up emacs"
ifeq ($(OS),Linux)
	@sudo apt install -y emacs
endif
ifneq ("$(wildcard $(HOME)/.emacs.d)","")
	@echo "Backing up existing emacs configs"
	@mv $(HOME)/.emacs.d $(HOME)/.emacs.d_bkup
endif
	@echo "Installing spacemacs"
	@git clone -b develop https://github.com/syl20bnr/spacemacs ~/.emacs.d

emacs:: ## Configure emacs Settings
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/emacs/spacemacs ${HOME}/.spacemacs
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/emacs/layers/org-trello ${HOME}/.emacs.d/private/org-trello
	@echo emacs configuration completed

gcloud:: ## Install gcloud
	@echo "Installing google cloud sdk"
	@curl https://sdk.cloud.google.com | bash

git:: ## Configure git Settings

ifeq ($(OS),Linux)
		sudo apt install git
endif
	@echo "Setting up git"
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/git/gitignore ${HOME}/.gitignore
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/git/gitconfig ${HOME}/.gitconfig
	@mkdir -p ~/.git-template
	@git config user.name "ageekymonk"
	@git config user.email "ramzthecoder@gmail.com"
	@echo git configuration completed

go:: ## Configure Golang Setttings
	@sudo apt install -y golang
	@go get -u github.com/alecthomas/gometalinter

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
	@bash scripts/osx-setup.sh
	@echo "osx configuration is completed"

python-setup:: ##Setting up python in a fresh laptop
ifeq ($(OS),Linux)
ifeq ("$(wildcard $(HOME)/.pyenv)","")
	git clone https://github.com/pyenv/pyenv.git ~/.pyenv
endif
endif
	@echo "Configuring python"
	@pyenv install 3.6.3
	@pyenv global 3.6.3
	@pip install awscli Pygments

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
	@echo "Setting up tmuxinator"
	@gem install tmuxinator
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/tmux/tmuxinator ${HOME}/.tmuxinator
	@mkdir -p $(HOME)/.tmuxinator/bin
	@curl -sSL -o $(HOME)/.tmuxinator/bin/tmuxinator.zsh https://raw.githubusercontent.com/tmuxinator/tmuxinator/master/completion/tmuxinator.zsh
	@echo "Setting up powerline"
	@pip install powerline-status
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/tmux/tmux.conf ${HOME}/.tmux.conf
	@mkdir -p ${HOME}/.tmux/plugins
	@git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	@echo "tmux configuration completed"

nvm-setup:: ## nvm setup
	@echo "Setting up nvm"
	@mkdir -p ${HOME}/.nvm
	@npm install -g tern js-beautify eslint

update:: ## Update the config repository
	$(GIT) pull && $(GIT) submodule foreach git checkout master && $(GIT) submodule foreach git pull
	@wget https://raw.githubusercontent.com/wee-slack/wee-slack/master/wee_slack.py
	@mv wee_slack.py $(CONFIG_ROOT)/weechat/plugins/autoload/wee_slack.py

zsh-setup:: ## Configure zsh for the fresh laptop
	@echo "Setting zsh as your default shell"
ifeq ($(OS),Darwin)
	@sudo dscl . -create /Users/$(USER) UserShell /usr/local/bin/zsh
endif
ifeq ($(OS),Linux)
	@sudo apt install -y zsh
endif
	@echo "Installing oh my zsh"
	@curl -fsSL -o /tmp/install_zsh.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
	@sh /tmp/install_zsh.sh
	@rm /tmp/install_zsh.sh
	@echo "Installing powerlevel9 theme"
	@git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/themes/powerlevel9k
	@echo "Setting up iterm2 Shell Integrations"
	@curl -L -o $(HOME)/.iterm2_shell_integration.zsh https://iterm2.com/shell_integration/zsh
	@curl -L -o $(HOME)/.kubectl_aliases https://rawgit.com/ahmetb/kubectl-alias/master/.kubectl_aliases

zsh:: ## Configure zsh Settings
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/zsh/zshenv ${HOME}/.zshenv
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/zsh/zshrc ${HOME}/.zshrc
	@mkdir -p $(HOME)/.aws/cli
	@ln $(LN_FLAGS) $(CONFIG_ROOT)/aws/alias ${HOME}/.aws/cli/alias

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
