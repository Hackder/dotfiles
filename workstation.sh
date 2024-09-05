#!/usr/bin/env bash

# This script is used to configure a portable workstation.
# It will download binaries for all the tools and set them up
# in PATH. It will also stow all the dotfiles.

# Install Homebrew
cd ~
mkdir homebrew
curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip-components 1 -C homebrew

eval "$(homebrew/bin/brew shellenv)"
brew update --force --quiet
# chmod -R go-w "$(brew --prefix)/share/zsh"

# If git is not installed, install it
if ! command -v git &> /dev/null; then
    brew install git
fi

brew install stow
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
