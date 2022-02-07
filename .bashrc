#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Run SSH Agent

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent -t 1h > "$XDG_RUNTIME_DIR/ssh-agent.env"
fi
if [[ ! "$SSH_AUTH_SOCK" ]]; then
    source "$XDG_RUNTIME_DIR/ssh-agent.env" >/dev/null
fi

# Alias

alias ls='ls --color=auto'
alias ll='ls --color=auto -lh'
alias  l='ls --color=auto -lah'

alias config='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Update packages' mirrors
# alias mirror-update=
PS1='[\u@\h \W]\$ '

export PATH="${PATH}:${HOME}/.local/bin:${HOME}/.emacs.d/bin"

