########################################
# Terminal, tmux, ssh-agent, audio
########################################

export TERM=tmux-256color
if [ -z "$TMUX" ]
then
    tmux attach -t Shell || tmux new -s Shell
fi

export SSH_AUTH_SOCK="$HOME/.ssh/agent.sock"
ssh-add -l &>/dev/null
if [ $? -eq 2 ]; then
  rm -f "$SSH_AUTH_SOCK"
  (umask 077; ssh-agent -a "$SSH_AUTH_SOCK" >/dev/null)
fi

# deactivate ctrl-s XOFF
stty -ixon

# uv / ~/.local/bin environment
. "$HOME/.local/bin/env"
