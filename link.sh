#!/bin/bash

here=$(pwd)
echo "Current working directory is $here"
ln -s "$here/nvim" ~/.config/nvim
ln -s "$here/tmux/tmux.conf" ~/.tmux.conf
