########################################
# Setup
########################################
# zmodload zsh/zprof
export TERM=tmux-256color
if [ -z "$TMUX" ]
then
    tmux attach -t TMUX || tmux new -s TMUX
fi

eval `ssh-agent` > /dev/null

export EDITOR="nvim"

# deactivate ctrl-s XOFF
stty -ixon 
# Ignore EOF; use 'exit' to quit the shell
setopt IGNORE_EOF  

# Ignore Gnome Emoji Picker
gsettings set org.freedesktop.ibus.panel.emoji hotkey "[]"

#Add custom scripts to PATH
export PATH="$HOME/.dotfiles/scripts:$PATH"

########################################
## ZSH Autoloads and Completions
########################################

#Only compile completions if necessary
# autoload -Uz compinit

# if [[ ! -f ~/.zcompdump.zwc || ~/.zcompdump -nt ~/.zcompdump.zwc ]]; then
#     compinit -i
#     zcompile -U -z ~/.zcompdump
# else
#     compinit -C -i
# fi


autoload -U add-zsh-hook

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
    web-search
    dirhistory
    )

source $ZSH/oh-my-zsh.sh


########################################
# NVM
########################################
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

#VIM
alias v="nvim"
alias vim="nvim"
# open last file
alias vl="nvim -c \"normal '0\""

#rmr
alias rmr="rm -r"

#Show all
alias lsa="ls -la"

#Reload Shell
alias reload="exec $SHELL"

# copy pwd to clip board
alias cpwd="pwd | xclip -sel clip"

#Alias cat to batcat
alias cat="batcat"

########################################
# Programming Languages 
########################################

# SNAP
export PATH="$PATH:/snap/bin"

# Rust 
export PATH="$PATH:~/.cargo/bin"

# Go
export PATH="$PATH:/usr/local/go/bin"

#Python + PyEnv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
export PYENV_VIRTUALENV_DISABLE_PROMPT=1

alias python=python3
alias vact="source venv/bin/activate"

#Mojo
export MODULAR_HOME="$HOME/.modular"
export PATH="$MODULAR_HOME/pkg/packages.modular.com_mojo/bin:$PATH"


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


########################################
# ZSH Hooks and Functions
########################################
source ~/.zsh/functions.zsh

#ZSH hooks
add-zsh-hook chpwd update-tmux-window-name

########################################
# Sedimentum 
########################################
alias fdns=~/.dotfiles/scripts/sedimentum_dns/fix-resolv-conf.sh
# zprof
