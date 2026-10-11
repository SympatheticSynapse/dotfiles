# --- fzf ---
source <(fzf --zsh)

# --- Vi mode ---
bindkey -v
export KEYTIMEOUT=1
export VI_MODE_SET_CURSOR=true

# Press 'v' in normal mode to edit the current command line
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# --- Clipboard yank (vi-mode) ---
# macOS: pbcopy. Linux with a display: wl-copy or xclip. Anywhere else
# (a container, an SSH session): OSC 52, which asks the terminal itself
# to set the clipboard, so a yank inside a devcontainer still lands on
# the machine in front of you. Never an error if none of them works.
function vi-yank-clipboard {
  zle vi-yank
  if (( $+commands[pbcopy] )); then
    echo "$CUTBUFFER" | pbcopy -i
  elif (( $+commands[wl-copy] )) && [[ -n $WAYLAND_DISPLAY ]]; then
    print -rn -- "$CUTBUFFER" | wl-copy
  elif (( $+commands[xclip] )) && [[ -n $DISPLAY ]]; then
    print -rn -- "$CUTBUFFER" | xclip -selection clipboard
  elif [[ -w /dev/tty ]]; then
    printf "\e]52;c;%s\a" "$(print -rn -- "$CUTBUFFER" | base64 | tr -d "\n")" > /dev/tty
  fi
}
zle -N vi-yank-clipboard
bindkey -M vicmd 'y' vi-yank-clipboard

# --- Aliases ---
alias ls='ls --color'
alias lss='ls --color | sort -V'
alias ll='ls -lah --color'
alias home='cd'
alias godir='cd ~/Workspace/go'
alias devpod=/Applications/DevPod.app/Contents/MacOS/devpod-cli
alias k='kubectl'
alias v='nvim'
alias cat='bat'
alias fuzz="fzf --preview 'cat {}'"
alias rip='rg --line-number --with-filename --color=always . | fzf --ansi --delimiter : --preview "bat --color=always {1} --highlight-line {2}" --preview-window ~8,+{2}-5'
alias tf='terraform'
alias tfp='terraform plan'
alias tfa='terraform apply'
alias tfd='terraform destroy'

# --- Editor environment ---
export VISUAL=nvim
export EDITOR="$VISUAL"

# --- History ---
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt extended_history hist_expire_dups_first hist_ignore_dups hist_ignore_space hist_verify share_history inc_append_history

# --- PATH ---
export PATH="$PATH:$HOME/go/bin"
export PATH="$PATH:$HOME/scripts"

# --- Starship (prompt) ---
eval "$(starship init zsh)"

autoload -Uz add-zsh-hook
add-zsh-hook precmd () {
  zle && zle reset-prompt
}

export PATH="$HOME/.local/bin:$PATH"
export KUBECONFIG=~/.kube/rke2-homelab.yaml
export PATH="/usr/local/sbin:$PATH"
