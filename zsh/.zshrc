# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="robbyrussell"

# Which plugins would you like to load?
plugins=(git zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/xiaodan/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/xiaodan/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/xiaodan/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/xiaodan/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Environment Variables
export TESSDATA_PREFIX=/opt/homebrew/share/tessdata/
export EDITOR="nvim"
export VISUAL="nvim"

# Aliases
alias vim="nvim"
alias vi="nvim"
alias v="nvim"
alias note='jupyter notebook'
alias lab='jupyter lab'
alias del="trash"

# Starship prompt
eval "$(starship init zsh)"

# Autojump
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

# Docker CLI completions
fpath=(/Users/xiaodan/.docker/completions $fpath)
autoload -Uz compinit
compinit

# Yazi shell integration
function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

# FZF integration
eval "$(fzf --zsh)"
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# Zoxide integration (smart cd)
eval "$(zoxide init zsh)"

# Yazi wrapper function that changes directory on exit
function yy() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}
