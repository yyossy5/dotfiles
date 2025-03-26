.PHONY: all help zsh nvim tmux lazygit brew aqua gitconfig

all: zsh nvim tmux lazygit brew aqua gitconfig ## Run all setup tasks

zsh: ## Install .zshrc
	./setup.sh zsh

nvim: zsh ## Setup Neovim config (~/.config/nvim)
	./setup.sh nvim

tmux: ## Install .tmux.conf
	./setup.sh tmux

lazygit: ## Install lazygit config
	./setup.sh lazygit

brew: ## Install CLI tools via Homebrew
	./setup.sh brew

aqua: zsh ## Install CLI tools via aqua (requires .zshrc)
	./setup.sh aqua

gitconfig: ## Configure git
	./setup.sh gitconfig

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' Makefile | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-18s\033[0m %s\n", $$1, $$2}'


