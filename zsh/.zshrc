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
export PATH="$HOME/.local/mygit/git/usr/bin:$HOME/.local/bin:$PATH"
export SHELL=$(which zsh)

# History in cache directory:
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.cache/zshhistory
setopt appendhistory

# Basic auto/tab complete:
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)               # Include hidden files.

bindkey -e

# Custom ZSH Binds
bindkey '^j' autosuggest-accept
bindkey -s "^f" "~/dotfiles/scripts/tmux-sessionizer.sh^M"
bindkey -s "^ " "tmux a^M"

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
export TERM='xterm-256color'
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
  eval "`fnm env --use-on-cd --shell zsh`"
fi

if command -v pyenv > /dev/null; then
  eval "$(pyenv init -)"
fi


# CTRL + Backspace
bindkey '^H' backward-kill-word

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

export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.config/gcloud/application_default_credentials.json"

# Zig
export PATH="$HOME/zig:$PATH"

# Deno
export DENO_INSTALL="/Users/jurajpetras/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# Roc
export PATH="/Users/jurajpetras/roc_nightly-macos_apple_silicon-2024-07-13-070d14a5d60:$PATH"
eval "$(mise activate zsh)"

# yazi
function yy() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

if command -v brew &> /dev/null; then
  export DYLD_LIBRARY_PATH="$(brew --prefix)/lib:$DYLD_LIBRARY_PATH"
fi

alias sci-mark="~/dev/sci-markdown/.venv/bin/python ~/dev/sci-markdown/src/sci_markdown/__main__.py"

eval "$(zoxide init zsh)"

# zprof

[ -f "/Users/jurajpetras/.ghcup/env" ] && . "/Users/jurajpetras/.ghcup/env" # ghcup-env

export PATH="$PATH:/Users/jurajpetras/.modular/bin"
export PATH="/opt/homebrew/opt/binutils/bin:$PATH"

alias loglang="/Users/jurajpetras/school/logic/log_lang/.venv/bin/python /Users/jurajpetras/school/logic/log_lang/main.py"
alias lc="/Users/jurajpetras/school/verification/lc/.venv/bin/python /Users/jurajpetras/school/verification/lc/lc.py"

export DELTA_FEATURES=+side-by-side

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/jurajpetras/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/jurajpetras/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/jurajpetras/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/jurajpetras/google-cloud-sdk/completion.zsh.inc'; fi
