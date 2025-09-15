# My Dotfiles

Personal configuration files for development environment.

## Contents

- **nvim/**: Neovim configuration
  - `init.lua`: Main Neovim configuration with LSP, DAP, file managers, and more

- **yazi/**: Yazi file manager configuration
  - `keymap.toml`: Custom keybindings with vim-like numbered navigation

- **zsh/**: Zsh shell configuration
  - `.zshrc`: Shell configuration and aliases

## Setup

### Neovim
```bash
# Backup existing config (if any)
mv ~/.config/nvim ~/.config/nvim.backup

# Create symlink
ln -s ~/dotfiles/nvim ~/.config/nvim
```

### Yazi
```bash
# Backup existing config (if any)
mv ~/.config/yazi ~/.config/yazi.backup

# Create symlink
ln -s ~/dotfiles/yazi ~/.config/yazi
```

### Zsh
```bash
# Backup existing config (if any)
mv ~/.zshrc ~/.zshrc.backup

# Create symlink
ln -s ~/dotfiles/zsh/.zshrc ~/.zshrc
```

## Features

### Neovim
- Modern plugin manager (lazy.nvim)
- LSP support with Mason
- Debugging with DAP
- File management with nvim-tree and yazi integration
- Fuzzy finding with Telescope
- Git integration
- Multiple colorschemes (catppuccin, gruvbox, snazzy)

### Yazi
- Vim-like navigation with number prefixes (5j, 10k, etc.)
- Custom keybindings for efficient file management
- Directory synchronization with Neovim

### Zsh
- Custom aliases and functions
- Enhanced shell experience

## Requirements

- Neovim >= 0.8
- Node.js (for LSP servers)
- Python 3 (for Python LSP and DAP)
- Git
- Yazi file manager
- A Nerd Font for proper icon display