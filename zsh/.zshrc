#######################################
# BASIC 
########################################
[ -z "$ZPROF" ] || zmodload zsh/zprof

export TERM=tmux-256color
if [ -z "$TMUX" ]
then
    tmux attach -t Shell || tmux new -s Shell
fi

eval `ssh-agent` > /dev/null
emulate ksh -c "source ssh-find-agent" 
ssh-add -l >&/dev/null || ssh-find-agent -a || eval $(ssh-agent) > /dev/null

# deactivate ctrl-s XOFF
stty -ixon 

########################################
# ZSH AUTOLOAD / SETOPT
########################################
# Should be called before compinit
zmodload zsh/complist
autoload -U compinit add-zsh-hook edit-command-line; compinit

zle -N edit-command-line

setopt IGNORE_EOF # Ignore EOF; use 'exit' to quit the shell
setopt SHARE_HISTORY # Share history between all sessions
setopt AUTO_PUSHD # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS # Do not store duplicates in the stack.
setopt PUSHD_SILENT # Do not print the directory stack after pushd or popd.

#Colorscheme for Dirs
eval "$(dircolors ~/.gruvbox.dircolors)"

########################################
# ZSH Hooks and Functions
########################################
source ~/.zsh/plugins/zsh-z/zsh-z.plugin.zsh
source ~/.zsh/functions.zsh
source ~/.zsh/bindkeys.zsh
source ~/.zsh/completion.zsh

#ZSH hooks - changes TMUX windows name when changing directories
add-zsh-hook chpwd update-tmux-window-name

eval "$(starship init zsh)"

########################################
# MISE
########################################
eval "$(/home/habichta/.local/bin/mise activate zsh)"

########################################
# PIPX 
########################################
eval "$(register-python-argcomplete pipx)"


########################################
# Alias
########################################

#VIM
alias v="nvim"
alias vi="nvim"
alias vim="nvim"
alias vl="nvim -c \"normal '0\"" # open last file
alias ls='ls --color=auto'
alias ll="ls -la --color=auto"
alias rmr="rm -r"
alias lsa="ls -la"
alias reload="exec $SHELL"
alias cpwd="pwd | xclip -sel clip" # copy pwd to clip board
alias cat="batcat"
alias cc="clear"
alias g="git"
alias ai=aider # Aider AI

#Download / Watch Youtube Video
#alias youtubed='PYTHONPATH=~/projects/youtube-dl python -m youtube_dl -o "$HOME/Downloads/%(title)s.%(ext)s"'
#alias vlc="/mnt/c/Program\ Files/VideoLAN/VLC/vlc.exe"

[ -z "$ZPROF" ] || zprof
