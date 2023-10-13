########################################
# Setup
########################################

export TERM=tmux-256color
if [ -z "$TMUX" ]
then
    tmux attach -t TMUX || tmux new -s TMUX
fi

eval `ssh-agent` > /dev/null

export EDITOR="nvim"

# deactivate ctrl-s XOFF
stty -ixon 

########################################
# Theme / Oh my ZSH
########################################
#
#Colorscheme for Dirs
eval "$(dircolors ~/.gruvbox.dircolors)"

# Path to your oh-my-zsh installation.
export ZSH="/home/$USER/.oh-my-zsh"

ZSH_THEME="spaceship"
SPACESHIP_USER_SHOW=always
SPACESHIP_PROMPT_DIR_TRUNC=0

# Turn off power status when using spaceship prompt
export SPACESHIP_BATTERY_SHOW=false

plugins=(
    z
    )

source $ZSH/oh-my-zsh.sh


########################################
# NVM
########################################
#
export NVM_DIR=~/.nvm
[[ -s "$NVM_DIR/nvm.sh" ]] && \. "$NVM_DIR/nvm.sh" # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

########################################
# YARN Binaries
########################################
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
export PATH="$PATH:$(yarn global bin)"

########################################
# Alias
########################################

#Lazygit
alias lg="lazygit"

#VIM
alias v="nvim"
alias vim="nvim"

#rmr
alias rmr="rm -r"

#Show all
alias lsa="ls -la"

#Reload Shell
alias reload="exec $SHELL"

#Python
#Activate virtual env
alias python=python3
alias vact="source venv/bin/activate"

# copy pwd to clip board
alias cpwd="pwd | xclip -sel clip"

########################################
# Programming Languages 
########################################

# SNAP
export PATH="$PATH:/snap/bin"

# Rust 
export PATH="$PATH:~/.cargo/bin"

# Go
export PATH="$PATH:/usr/local/go/bin"

#PyEnv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"


########################################
# FZF 
########################################
export PATH="$HOME/.local/bin:$PATH"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


FD_OPTIONS="--follow -E .git -E node_modules"
export FZF_DEFAULT_COMMAND="fd --type f --type l $FD_OPTIONS"
export FZF_DEFAULT_OPTS='--height 80% --layout=reverse --border --info=inline
--bind "?:toggle-preview,ctrl-f:half-page-down,ctrl-b:half-page-up,ctrl-a:select-all+accept"'

export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
export FZF_CTRL_T_OPTS="--preview '(batcat -n --color=always {} || tree -C {}) 2> /dev/null | head -200' --select-1 --exit-0"

export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"


# Quick way do go to previously visited directories
d() {
  ddir="$(dirs -v | awk '{print $2}' | fzf)"
  ddir=${ddir/#\~/${HOME}} 
  cd "$ddir"
}


# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() {
  IFS=$'\n' out=("$(fzf --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR} "$file"
  fi
}

# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
fkill() {
    local pid 
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi  

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi  
}

# use CTRL+G/CTRL+? to select git things with FZF
# https://junegunn.kr/2016/07/fzf-git/
_is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

gb() {
  _gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1 | tr -d '\n'"
  _viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy'"
  git log --graph --abbrev-commit --decorate --date=short --color=always --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all |
    fzf --no-sort --reverse --tiebreak=index --no-multi \
    --ansi --preview="$_viewGitLogLine" \
    --header "enter to view, alt-c to copy hash to clipboard" \
    --bind "enter:execute:$_viewGitLogLine | less -R" \
    --bind "alt-c:execute:$_gitLogLineToHash | xclip -i -sel c"
}

gh() {
  _is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
    fzf --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always' |
    grep -o "[a-f0-9]\{7,\}"
}

########################################
# Sedimentum 
########################################
alias fdns=~/.dotfiles/scripts/sedimentum_dns/fix-resolv-conf.sh
