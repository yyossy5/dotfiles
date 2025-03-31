.PHONY: all help zsh nvim tmux lazygit brew aqua gitconfig iterm2

TIMESTAMP := $(shell date +%Y%m%d-%H%M%S)

all: zsh nvim tmux lazygit brew aqua gitconfig iterm2 ## Run all setup tasks

zsh: ## Install .zshrc
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh zsh

nvim: zsh ## Setup Neovim config (~/.config/nvim)
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh nvim

tmux: ## Install .tmux.conf
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh tmux

lazygit: ## Install lazygit config
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh lazygit

brew: ## Install CLI tools via Homebrew
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh brew

aqua: zsh ## Install CLI tools via aqua (requires .zshrc)
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh aqua

gitconfig: ## Configure git
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh gitconfig

iterm2: ## Install iTerm2 config
	LOG_TIMESTAMP=$(TIMESTAMP) ./setup.sh iterm2

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'


