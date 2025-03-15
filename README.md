# dotfiles

## How to add "dotfiles" to this repository

Assuming this repository is cloned in your home directory like:
```$HOME/dotfiles```

Example of adding ```~/.config/nvim```:

```bash
# Backup existing files (just in case)
mkdir -p ~/dotfiles_backup/.config/
mv ~/.config/nvim/ ~/dotfiles_backup/.config/

# Create symbolic link
ln -s ~/dotfiles/.config/nvim ~/.config/nvim
```

Commit & push within the dotfiles directory.
