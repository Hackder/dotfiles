#!/usr/bin/env bash

# This script is used to configure a portable workstation.
# It will download binaries for all the tools and set them up
# in PATH. It will also stow all the dotfiles.

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install git stow
cd ~
git clone https://github.com/Hackder/dotfiles.git

cd dotfiles
stow kitty
stow yazi
stow starship
stow tmux
stow zsh
stow nvim

# Install git
brew install git ripgrep fd fzf zsh tmux neovim kitty yazi starship

# Change shell to zsh
chsh -s /opt/homebrew/bin/zsh
