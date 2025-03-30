#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
LOG_FILE="$DOTFILES_DIR/setup.log"
BACKUP_SUFFIX=".bak.$(date +%Y%m%d%H%M%S)"

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
  log "Setting git global config for delta..."
  git config --global core.pager delta
  git config --global interactive.diffFilter 'delta --color-only'
  git config --global delta.navigate true
  git config --global merge.conflictStyle zdiff3
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
lua
neovim
node
openjdk@21
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

main() {
  if [ $# -eq 0 ]; then
    echo "Usage: $0 [all|zsh|nvim|tmux|lazygit|brew|aqua|gitconfig|iterm2]"
    exit 1
  fi

  for arg in "$@"; do
    case "$arg" in
    all)
      install_zsh
      install_nvim
      install_tmux
      install_lazygit
      install_brew
      install_openjdk_symlink
      install_aqua
      install_gitconfig
      install_iterm2
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
    *)
      echo "Unknown option: $arg"
      exit 1
      ;;
    esac
  done

  log "Setup completed."
}

main "$@"
