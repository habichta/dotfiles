########################################
# DOTFILES 
########################################
export DOTFILES="$HOME/.dotfiles"

########################################
# PATH/HOME  
########################################
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.fzf/bin"
export PATH="$PATH:$DOTFILES/scripts"
export PATH=$PATH:/mnt/c/Windows/System32:/mnt/c/Windows

. "$HOME/.cargo/env"
########################################
# ZSH 
########################################
export HISTFILE="$HOME/.zhistory"
export HISTSIZE=10000
export SAVEHIST=10000
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

########################################
# FZF 
########################################
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export FZF_DEFAULT_OPTS='--height 80% --layout=reverse --border --info=inline
--bind "ctrl-/:toggle-preview,ctrl-f:half-page-down,ctrl-b:half-page-up,ctrl-a:select-all+accept"'
# find files with `rg`
export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git'"
export FZF_CTRL_T_DEFAULT_COMMAND="$FZF_DEFAULT_COMMAND"

########################################
# EDITOR 
########################################
export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER='nvim +Man!'
