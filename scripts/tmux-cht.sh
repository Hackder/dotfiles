#!/usr/bin/env bash
selected=`cat ~/dotfiles/scripts/.tmux-cht-languages ~/dotfiles/scripts/.tmux-cht-command | fzf`
if [[ -z $selected ]]; then
    exit 0
fi

read -p "Enter Query: " query

if grep -qs "$selected" ~/dotfiles/tmux/.tmux-cht-languages; then
    query=`echo $query | tr ' ' '+'`
    tmux neww bash -c "echo \"curl cht.sh/$selected/$query/\" & curl cht.sh/$selected/$query | less -r"
else
    tmux neww bash -c "curl -s cht.sh/$selected~$query | less -r"
fi

