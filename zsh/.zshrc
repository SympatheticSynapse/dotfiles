source <(fzf --zsh)

# Vi mode
bindkey -v # enabvle vi keybindings
export KEYTIMEOUT=1

# Press 'v' in normal mode to launch Vim with current line
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

export VI_MODE_SET_CURSOR=true

function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]]; then
    echo -ne '\e[2 q' # block
  else
    echo -ne '\e[6 q' # beam
  fi
}
zle -N zle-keymap-select

function zle-line-init() {
  zle -K viins
  echo -ne '\e[6 q'
}
zle -N zle-line-init

# Yank to system clipboard
function vi-yank-clipboard {
  zle vi-yank
  echo "$CUTBUFFER" | pbcopy -i
}
zle -N vi-yank-clipboard
bindkey -M vicmd 'y' vi-yank-clipboard

# alias

alias ls='ls --color'
alias lss='ls --color | sort -V'
alias ll='ls -lah --color'

alias home='cd'
alias godir='cd ~/Workspace/go'
alias v='nvim'
alias cat='bat'

alias fuzz="fzf --preview 'cat {}'"

alias rip='rg --line-number --with-filename --color=always . | fzf --ansi --delimiter : --preview "bat --color=always {1} --highlight-line {2}" --preview-window ~8,+{2}-5'

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
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/scripts
