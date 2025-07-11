#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
LOG_TIMESTAMP="${LOG_TIMESTAMP:-$(date +%Y%m%d-%H%M%S)}"
LOG_FILE="$DOTFILES_DIR/setup-$LOG_TIMESTAMP.log"
BACKUP_SUFFIX=".bak.$LOG_TIMESTAMP"

log() {
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

backup_and_link() {
  local target="$1"
  local source="$2"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    log "Backing up $target to ${target}${BACKUP_SUFFIX}"
    mv "$target" "${target}${BACKUP_SUFFIX}"
  fi

  if [ -L "$target" ]; then
    log "Removing existing symlink $target"
    rm "$target"
  fi

  ln -s "$source" "$target"
  log "Linked $source → $target"
}

backup_and_copy() {
  local source="$1"
  local target="$2"

  if [ -e "$target" ] && [ ! -L "$target" ]; then
    log "Backing up $target to ${target}${BACKUP_SUFFIX}"
    mv "$target" "${target}${BACKUP_SUFFIX}"
  fi

  cp "$source" "$target"
  log "Copied $source → $target"
}

install_zsh() {
  log "Setting up zsh..."
  backup_and_link "$HOME/.zshrc" "$DOTFILES_DIR/zsh/.zshrc"
}

install_nvim() {
  log "Setting up Neovim..."
  mkdir -p "$HOME/.config"
  backup_and_link "$HOME/.config/nvim" "$DOTFILES_DIR/nvim"
}

install_tmux() {
  log "Setting up tmux..."
  backup_and_link "$HOME/.tmux.conf" "$DOTFILES_DIR/tmux/.tmux.conf"
}

install_lazygit() {
  log "Setting up lazygit config..."
  mkdir -p "$HOME/Library/Application Support/lazygit"
  backup_and_link "$HOME/Library/Application Support/lazygit/config.yml" "$DOTFILES_DIR/lazygit/config.yml"
}

install_gitconfig() {
  log "Setting up git config..."
  backup_and_link "$HOME/.gitconfig" "$DOTFILES_DIR/git/.gitconfig"

  local local_gitconfig_src="$DOTFILES_DIR/git/.gitconfig.local"
  local local_gitconfig_dst="$HOME/.gitconfig.local"

  if [ -f "$local_gitconfig_src" ]; then
    backup_and_copy "$local_gitconfig_src" "$local_gitconfig_dst"
  else
    log "No .gitconfig.local found at $local_gitconfig_src, skipping copy"
  fi
}

install_brew() {
  log "Installing Homebrew packages (without upgrading existing ones)..."
  while read -r pkg; do
    if ! brew list "$pkg" &>/dev/null; then
      log "Installing $pkg via Homebrew"
      brew install "$pkg" 2>&1 | tee -a "$LOG_FILE"
    else
      log "$pkg already installed, skipping"
    fi
  done <<EOF
aqua
cmake
curl
font-hack-nerd-font
gcc
git
git-delta
gh
lua
neovim
node
openjdk@21
ripgrep
tmux
tree
EOF
}

install_openjdk_symlink() {
  local jdk_path="/Library/Java/JavaVirtualMachines/openjdk-21.jdk"
  local brew_jdk="/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk"

  if [ ! -L "$jdk_path" ]; then
    log "Creating symlink for OpenJDK 21..."
    sudo ln -sfn "$brew_jdk" "$jdk_path"
    log "Symlink created: $jdk_path → $brew_jdk"
  else
    log "Symlink already exists: $jdk_path"
  fi
}

install_aqua() {
  log "Installing tools via aqua (global config)..."
  aqua i -a
}

install_iterm2() {
  local target="$HOME/Documents/ConfigFiles/iTerm2"
  local source="$DOTFILES_DIR/iterm2/config"
  log "Setting up iTerm2 config..."
  mkdir -p "$(dirname "$target")"
  backup_and_link "$target" "$source"
}

install_claude() {
  log "Setting up Claude config..."
  mkdir -p "$HOME/.claude"
  backup_and_link "$HOME/.claude/CLAUDE.md" "$DOTFILES_DIR/claude/CLAUDE.md"
}

install_gemini() {
  log "Setting up Gemini CLI config..."
  mkdir -p "$HOME/.gemini"
  backup_and_link "$HOME/.gemini/settings.json" "$DOTFILES_DIR/gemini/settings.json"
  backup_and_link "$HOME/.gemini/GEMINI.md" "$DOTFILES_DIR/gemini/GEMINI.md"
}

install_codex() {
  log "Setting up Codex CLI config..."
  mkdir -p "$HOME/.codex"
  backup_and_link "$HOME/.codex/AGENT.md" "$DOTFILES_DIR/codex/AGENT.md"
  backup_and_link "$HOME/.codex/config.toml" "$DOTFILES_DIR/codex/config.toml"
}

install_intellij() {
  log "Setting up IntelliJ IDEA config..."
  backup_and_link "$HOME/.ideavimrc" "$DOTFILES_DIR/intellij/.ideavimrc"
}

install_npm_global() {
  log "Installing npm global packages..."
  while read -r pkg; do
    if ! npm list -g "$pkg" &>/dev/null; then
      log "Installing $pkg globally via npm"
      npm install -g "$pkg" 2>&1 | tee -a "$LOG_FILE"
    else
      log "$pkg already installed globally, skipping"
    fi
  done <"$DOTFILES_DIR/npm/packages.txt"
}

install_obsidian() {
  log "Setting up Obsidian vimrc config..."
  local obsidian_dir="$HOME/myobs"

  if [ ! -d "$obsidian_dir" ]; then
    log "Obsidian directory $obsidian_dir not found, skipping"
    return 0
  fi

  backup_and_link "$obsidian_dir/.obsidian.vimrc" "$DOTFILES_DIR/obsidian/.obsidian.vimrc"
}

install_amazonq() {
  log "Setting up Amazon Q config..."
  mkdir -p "$HOME/.aws/amazonq"
  backup_and_link "$HOME/.aws/amazonq/mcp.json" "$DOTFILES_DIR/aws/amazonq/mcp.json"
  mkdir -p "$HOME/.amazonq"
  backup_and_link "$HOME/.amazonq/rules" "$DOTFILES_DIR/amazonq/rules"
}

main() {
  if [ $# -eq 0 ]; then
    echo "Usage: $0 [all|zsh|nvim|tmux|lazygit|brew|aqua|gitconfig|iterm2|claude|gemini|codex|intellij|npm|obsidian|amazonq]"
    exit 1
  fi

  for arg in "$@"; do
    case "$arg" in
    all)
      install_brew
      install_openjdk_symlink
      install_zsh
      install_tmux
      install_aqua
      install_npm_global
      install_gitconfig
      install_lazygit
      install_iterm2
      install_nvim
      install_claude
      install_gemini
      install_codex
      install_intellij
      install_obsidian
      install_amazonq
      ;;
    zsh) install_zsh ;;
    nvim) install_nvim ;;
    tmux) install_tmux ;;
    lazygit) install_lazygit ;;
    brew)
      install_brew
      install_openjdk_symlink
      ;;
    aqua) install_aqua ;;
    gitconfig) install_gitconfig ;;
    iterm2) install_iterm2 ;;
    claude) install_claude ;;
    gemini) install_gemini ;;
    codex) install_codex ;;
    intellij) install_intellij ;;
    npm) install_npm_global ;;
    obsidian) install_obsidian ;;
    amazonq) install_amazonq ;;
    *)
      echo "Unknown option: $arg"
      exit 1
      ;;
    esac
  done

  log "Setup completed."
}

main "$@"
