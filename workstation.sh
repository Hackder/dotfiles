#!/usr/bin/env bash

# This script is used to configure a portable workstation.
# It will download binaries for all the tools and set them up
# in PATH. It will also stow all the dotfiles.

export PATH="$HOME/.local/bin:$PATH"
if command -v curl &> /dev/null; then
  curl -L https://github.com/Hackder/workstation/releases/latest/download/workstation-x86_64-unknown-linux-musl.tar.gz -o /tmp/workstation.tar.gz
else
  wget -O /tmp/workstation.tar.gz https://github.com/Hackder/workstation/releases/latest/download/workstation-x86_64-unknown-linux-musl.tar.gz
fi
mkdir -p /tmp/workstation
tar -xzf /tmp/workstation.tar.gz -C /tmp/workstation
mkdir -p ~/.local/bin
mv /tmp/workstation/workstation ~/.local/bin/workstation

workstation -r https://raw.githubusercontent.com/Hackder/dotfiles/main/workstation.toml setup

if ! command -v git &> /dev/null; then
  mkdir -p ~/miniconda3
  curl https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -L -o ~/miniconda3/miniconda.sh
  bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
  rm ~/miniconda3/miniconda.sh
  ~/miniconda3/bin/conda init bash
  ~/miniconda3/bin/conda install -y git
  PATH="$HOME/miniconda3/bin:$PATH"
fi

# ZSH
echo "2
n" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh-bin/master/install)"

fnm install --latest

curl https://mise.run | sh
mise settings set python_compile false
mise install python
mise use --global python

cd ~
if ! command -v git &> /dev/null; then
  curl -L -O https://github.com/Hackder/dotfiles/archive/main.zip
  unzip main.zip -d dotfiles
  (shopt -s dotglob; mv dotfiles/dotfiles-main/* dotfiles/.)
  rmdir dotfiles/dotfiles-main
else
  git clone https://github.com/Hackder/dotfiles.git
fi

link_files() {
    local target_dir="$1"

    local current_dir=$(pwd)

    # Check if the target directory is provided and exists
    if [[ -z "$target_dir" || ! -d "$target_dir" ]]; then
        echo "Please provide a valid directory."
        return 1
    fi

    # Use `fd` to find all files recursively in the target directory
    fd -H --base-directory="$target_dir" -t f . | while read -r file; do
        # Determine the destination path in $HOME
        dest="$HOME/$file"

        # Create the parent directory of the destination if it doesn't exist
        mkdir -p "$(dirname "$dest")"

        # Create the symlink
        ln -sf "$current_dir/$target_dir/$file" "$dest"
    done
}

# tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

cd dotfiles
link_files nvim
link_files zsh
link_files tmux
link_files kitty
link_files starship
link_files clang
link_files bottom
link_files git

# nocheckin pre-commit hook
git config --global core.hooksPath "$HOME/.git-hooks"

curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/JetBrainsMono.zip -o /tmp/JetBrainsMono.zip
unzip /tmp/JetBrainsMono.zip -d ~/.fonts

# Install cmake
if ! command -v cmake &> /dev/null; then
  curl -L https://github.com/Kitware/CMake/releases/download/v3.31.5/cmake-3.31.5-linux-x86_64.tar.gz -o /tmp/cmake.tar.gz
  mkdir -p /tmp/cmake
  tar -xzf /tmp/cmake.tar.gz -C /tmp/cmake --strip-components=1
  mv /tmp/cmake/bin/* ~/.local/bin
  mv /tmp/cmake/share/* ~/.local/share
fi

source <(fnm env)
npm i -g tldr

cd ~
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
ln -sf "$HOME/.local/kitty.app/bin/kitty" "$HOME/.local/bin/kitty"
ln -sf "$HOME/.local/kitty.app/bin/kitten" "$HOME/.local/bin/kitten"

# kitty.conf is symlinked into the dotfiles repo, so override the shell
# on the command line instead of editing the tracked file
echo 'alias kitty="$HOME/.local/bin/kitty -o shell=$HOME/.local/bin/zsh"' >> ~/.bashrc

cd ~
git clone https://github.com/Vl4dk0/sysprogdocs.git
