# zmodload zsh/zprof
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# Dependancies You Need for this Config
# zsh-syntax-highlighting - syntax highlighting for ZSH in standard repos
# autojump - jump to directories with j or jc for child or jo to open in file manager
# zsh-autosuggestions - Suggestions based on your history

# Initial Setup
# touch "$HOME/.cache/zshhistory
# Setup Alias in $HOME/zsh/aliasrc
# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
# echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>! ~/.zshrc

# Enable colors and change prompt:
autoload -U colors && colors
# PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

# Custom Variables
export EDITOR=nvim
export PATH="$HOME/.local/bin:$PATH"
export SHELL=$(which zsh)

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zshhistory
setopt appendhistory

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)               # Include hidden files.

# Custom ZSH Binds
bindkey '^ ' autosuggest-accept
bindkey -s ^f '~/dotfiles/scripts/tmux-sessionizer.sh\n'
bindkey -s ^a 'tmux a\n'

# Load aliases and shortcuts if existent.
[ -f "$HOME/aliasrc" ] && source "$HOME/aliasrc"

# Load ; should be last.
if [ -f /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
fi
if [ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
# source ~/powerlevel10k/powerlevel10k.zsh-theme

# # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export COLORTERM=truecolor
export TERM='screen-256color'
export RANRC=1

if [ -f ~/.zsh_secrets ]; then
  source ~/.zsh_secrets
fi

# Starship
eval "$(starship init zsh)"

# fnm
export PATH="/Users/jurajpetras/Library/Application Support/fnm:$PATH"
# check if fnm is installed
if command -v fnm > /dev/null; then
  eval "`fnm env`"
fi

if command -v pyenv > /dev/null; then
  eval "$(pyenv init -)"
fi


# CTRL + Backspace
bindkey '^H' backward-kill-word

export LDFLAGS="-L/usr/local/opt/tcl-tk/lib"
export CPPFLAGS="-I/usr/local/opt/tcl-tk/include"
export PATH=$PATH:/usr/local/opt/tcl-tk/bin

# bun completions
[ -s "/Users/jurajpetras/.bun/_bun" ] && source "/Users/jurajpetras/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"


[ -f "$HOME/export-esp.sh" ] && source $HOME/export-esp.sh

# function to source .env file
function sourceenv() {
  if [ -f .env ]; then
    export $(cat .env | sed 's/#.*//g' | xargs)
  fi
}

alias lsbm="list-submit"
alias lls="/bin/ls"

source <(fzf --zsh)

# Zig
export PATH="$HOME/zig:$PATH"

# Odin
export PATH="$HOME/odin:$PATH"

# Deno
export DENO_INSTALL="/Users/jurajpetras/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# Roc
export PATH="/Users/jurajpetras/roc_nightly-macos_apple_silicon-2024-07-13-070d14a5d60:$PATH"
eval "$(mise activate zsh)"

# zprof


