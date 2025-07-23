set -o vi

source <(fzf --zsh)

# alias

alias ls='ls --color'
alias lss='ls --color | sort -V'
alias ll='ls -lah --color'

alias home='cd'
alias godir='cd ~/Workspace/go'
alias v='nvim'
alias cat='bat'

export VISUAL=nvim
export EDITOR="$VISUAL"

# Starship
if [[ "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select" || \
      "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select-wrapped" ]]; then
    zle -N zle-keymap-select "";
fi

# History
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt extended_history hist_expire_dups_first hist_ignore_dups hist_ignore_space hist_verify share_history inc_append_history

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
