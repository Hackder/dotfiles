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
  echo "2
n" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh-bin/master/install)"
else
  echo "2
n" | sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh-bin/master/install)"
fi

export PATH="$HOME/.local/bin:$PATH"

if [ -f ~/.bash_profile ]; then
  cp ~/.bash_profile ~/.bash_profile.bak
fi
echo "
export SHELL=~/.local/bin/zsh
exec ~/.local/bin/zsh -l
" >> ~/.bash_profile

if [ -f ~/.profile ]; then
  cp ~/.profile ~/.profile.bak
fi
echo "
export SHELL=/bin/zsh
[ -z "$ZSH_VERSION" ] && exec /bin/zsh -l
" >> ~/.profile

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
brew install ripgrep fd fzf tmux neovim yazi starship

curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
