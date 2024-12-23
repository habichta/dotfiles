########################################
# Basic Setup
########################################
[ -z "$ZPROF" ] || zmodload zsh/zprof

export TERM=tmux-256color
if [ -z "$TMUX" ]
then
    tmux attach -t Shell || tmux new -s Shell
fi

eval `ssh-agent` > /dev/null

export EDITOR="nvim"

# deactivate ctrl-s XOFF
stty -ixon 
# Ignore EOF; use 'exit' to quit the shell
setopt IGNORE_EOF  

# Ignore Gnome Emoji Picker
gsettings set org.freedesktop.ibus.panel.emoji hotkey "[]"

# Remapping Capslock to ESC
setxkbmap -option caps:escape

#Add custom scripts to PATH
export PATH="$HOME/.dotfiles/scripts:$PATH"

# History
HISTSIZE=10000
SAVEHIST=10000
setopt share_history


########################################
# Theme / Oh my ZSH
########################################

export ZSH="/home/$USER/.oh-my-zsh"

#Colorscheme for Dirs
eval "$(dircolors ~/.gruvbox.dircolors)"

ZSH_THEME="spaceship"
SPACESHIP_PROMPT_ORDER=(user host dir git venv line_sep char)
SPACESHIP_USER_SHOW=always
ZSH_DISABLE_COMPFIX="true" # Disable compfix for faster startup

# Turn off power status when using spaceship prompt
export SPACESHIP_BATTERY_SHOW=false

# Optimizations
NVM_LAZY_LOAD=true
export NVM_LAZY_LOAD_EXTRA_COMMANDS=('nvim')
DISABLE_UPDATE_PROMPT=true # automatically update oh-my-zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

ZSH_COMPDUMP="$ZSH/completions/.zcompdump"

fpath=($ZSH/completions $fpath)

plugins=(
  zsh-nvm
  zsh-autosuggestions
  z
    )

source $ZSH/oh-my-zsh.sh
########################################
# PIPX
########################################
export PATH="$PATH:~/.local/bin"


########################################
# YARN Binaries
########################################
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"


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

#Alias cat to batcat
alias cc="clear"

#Alias cat to batcat
alias g="git"

########################################
# Programming Languages 
########################################

# SNAP
export PATH="$PATH:/snap/bin"

# Rust 
export PATH="$PATH:~/.cargo/bin"
. "$HOME/.cargo/env"

# Go
export PATH="$PATH:/usr/local/go/bin"

#Python + PyEnv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"

alias pyenv_activate="eval \"\$(pyenv init - zsh)\" && eval \"\$(pyenv virtualenv-init - zsh)\""
alias python=python3
alias vact="source venv/bin/activate"

########################################
# FZF 
########################################
export PATH="$HOME/.fzf/bin:$PATH"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


FD_OPTIONS="--follow -E .git -E node_modules"
export FZF_DEFAULT_COMMAND="fd --type f --type l $FD_OPTIONS"
export FZF_DEFAULT_OPTS='--height 80% --layout=reverse --border --info=inline
--bind "?:toggle-preview,ctrl-f:half-page-down,ctrl-b:half-page-up,ctrl-a:select-all+accept"'


########################################
# ZSH Hooks and Functions
########################################
# source ~/.zsh/functions.zsh
#ZSH hooks
add-zsh-hook chpwd update-tmux-window-name

########################################
# HELPANY
########################################
#Fix DNS for WSL 2
alias helpany_fix_dns=~/.dotfiles/scripts/sedimentum_dns/fix-resolv-conf.sh

#Update Python Dependencies of a Service Repo for Development
function helpany_update_dev_python_deps {
    # Path to requirements file
    requirements_file="requirements/dev.txt"

    # Check if in virtualenv
    if [[ -z "$VIRTUAL_ENV" ]]; then
        echo "No virtual environment found. Please activate one before running this function."
        return 1
    fi

    # Check if deps/ directory exists
    if [[ -d "deps" ]]; then
        echo "Installing dependencies from submodules in deps/"

        for dir in deps/*/; do
            if [[ -d "$dir" ]]; then
                echo "Installing dependencies from $dir"
                pip install "$dir"
            fi
        done
    else
        echo "No deps/ directory found."
    fi
    # Check if requirements file exists
    if [[ ! -f "$requirements_file" ]]; then
        echo "requirements/dev.txt not found."
        return 1
    fi

    # Install dependencies from requirements file, ignoring lines starting with -e file:///
    grep -v '^-e file:///' "$requirements_file" | pip install -r /dev/stdin
}



[ -z "$ZPROF" ] || zprof
