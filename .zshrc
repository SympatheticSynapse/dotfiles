set -o vi 

source <(fzf --zsh)

# alias 

alias ls='ls --color'
alias lss='ls --color | sort -V'
alias ll='ls -lah --color'

alias home='cd'
alias godir='cd ~/Workspace/go'

# Starship
if [[ "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select" || \
      "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select-wrapped" ]]; then
    zle -N zle-keymap-select "";
fi

eval "$(starship init zsh)"
