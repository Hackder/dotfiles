#!/usr/bin/env bash

# This script is used to configure a portable workstation.
# It will download binaries for all the tools and set them up
# in PATH. It will also stow all the dotfiles.

set -e

mkdir -p ~/.local/mygit
if ! command -v git &> /dev/null; then
  cd ~/.local/mygit
  apt-get download git
  dpkg -x git_* git
  echo "export PATH=$HOME/.local/mygit/git/usr/bin:\$PATH" >> ~/.bashrc
  # dpkg -i git_*.deb --force-not-root --root=$HOME
fi

# ZSH
if command -v curl &> /dev/null; then
  echo "2
n" | sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh-bin/master/install)"
else
  echo "2
n" | sh -c "$(wget -O- https://raw.githubusercontent.com/romkatv/zsh-bin/master/install)"
fi

export PATH="$HOME/.local/bin:$PATH"

# mkdir -p ~/.config/stew
# echo "{
#   \"stewPath\": \"$HOME/.local/share/stew\",
#   \"stewBinPath\": \"$HOME/.local/bin\"
# }" > ~/.config/stew/stew.config.json
#
# if command -v curl &> /dev/null; then
#   curl -L https://github.com/marwanhawari/stew/releases/download/v0.4.0/stew-v0.4.0-linux-amd64.tar.gz -o /tmp/stew.tar.gz
# else
#   wget -O /tmp/stew.tar.gz https://github.com/marwanhawari/stew/releases/download/v0.4.0/stew-v0.4.0-linux-amd64.tar.gz
# fi
# mkdir -p /tmp/stew
# tar -xzf /tmp/stew.tar.gz -C /tmp/stew
# mv /tmp/stew/stew ~/.local/bin/stew

if command -v curl &> /dev/null; then
  curl -L https://github.com/Hackder/workstation/releases/latest/download/workstation-x86_64-unknown-linux-musl.tar.gz -o /tmp/workstation.tar.gz
else
  wget -O /tmp/workstation.tar.gz https://github.com/Hackder/workstation/releases/latest/download/workstation-x86_64-unknown-linux-musl.tar.gz
fi
mkdir -p /tmp/workstation
tar -xzf /tmp/workstation.tar.gz -C /tmp/workstation
mkdir -p ~/.local/bin
mv /tmp/workstation/workstation ~/.local/bin/workstation

cd ~
git clone https://github.com/Hackder/dotfiles.git

# If git is not installed, install it
# if ! command -v git &> /dev/null; then
#   # TODO install git
# fi

# stew install junegunn/fzf
# stew install BurntSushi/ripgrep
# stew install sharkdp/fd
# stew install sxyazi/yazi
# stew install starship/starship
# stew install neovim/neovim
# stew install nelsonenzo/tmux-appimage

cd dotfiles
workstation setup
cd ~

fnm install --latest

curl https://mise.run | sh
mise install python
mise use --global python


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


cd dotfiles
link_files nvim
link_files zsh
link_files tmux
link_files kitty
link_files yazi
link_files starship

curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip -o /tmp/FiraCode.zip
unzip /tmp/FiraCode.zip -d ~/.fonts

# Replace shell in kitty config
echo "shell $HOME/.local/bin/zsh" >> ~/.config/kitty/kitty.conf

cd ~
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
ln -s "$HOME/.local/kitty.app/bin/kitty" "$HOME/.local/bin/kitty"
ln -s "$HOME/.local/kitty.app/bin/kitten" "$HOME/.local/bin/kitten"

