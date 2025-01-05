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
# Neovim 
########################################
export PATH="$PATH:/opt/nvim-linux64/bin"
export EDITOR="nvim"

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
DISABLE_UPDATE_PROMPT=true # automatically update oh-my-zsh
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

ZSH_COMPDUMP="$ZSH/completions/.zcompdump"

fpath=($ZSH/completions $fpath)

plugins=(
  zsh-autosuggestions
  mise
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

########################################
# FZF 
########################################
export PATH="$HOME/.fzf/bin:$PATH"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh


FD_OPTIONS="--follow -E .git -E node_modules"
export FZF_DEFAULT_COMMAND="fd --type f --type l $FD_OPTIONS"
export FZF_DEFAULT_OPTS='--height 80% --layout=reverse --border --info=inline
--bind "?:toggle-preview,ctrl-f:half-page-down,ctrl-b:half-page-up,ctrl-a:select-all+accept,ctrl-y:preview-up,ctrl-e:preview-down"'


########################################
# ZSH Hooks and Functions
########################################
source ~/.zsh/functions.zsh

#ZSH hooks - changes TMUX windows name when changing directories
add-zsh-hook chpwd update-tmux-window-name

########################################
# HELPANY
########################################
#Fix DNS for WSL 2
alias helpany_fix_dns=~/.dotfiles/scripts/sedimentum_dns/fix-resolv-conf.sh

[ -z "$ZPROF" ] || zprof
eval "$(/home/habichta/.local/bin/mise activate zsh)"
