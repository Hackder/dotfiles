#!/usr/bin/env bash

# This script is used to configure a portable workstation.
# It will download binaries for all the tools and set them up
# in PATH. It will also stow all the dotfiles.

# Install Homebrew
mkdir -p ~/.local/Homebrew &&
curl -L https://github.com/Homebrew/brew/tarball/master |
tar xz --strip 1 -C ~/.local/Homebrew

mkdir -p ~/.local/bin &&
ln -s ~/.local/Homebrew/bin/brew ~/.local/bin

if command -v curl &> /dev/null; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh-bin/master/install)"
else
  sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh-bin/master/install)"
fi

export PATH="$HOME/.local/bin:$PATH"

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
brew install git ripgrep fd fzf tmux neovim yazi starship

# Change shell to zsh
chsh -s /opt/homebrew/bin/zsh
