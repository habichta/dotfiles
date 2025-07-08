########################################
# DOTFILES 
########################################
export DOTFILES="$HOME/.dotfiles"

########################################
# PATH  
########################################
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$HOME/.fzf/bin"
export PATH="$PATH:$DOTFILES/scripts"

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

FZF_EXCLUDES=(
  --glob '!.git'
  --glob '!node_modules'
  --glob '!.cache'
  --glob '!*.pyc'
  --glob '!__pycache__'
  --glob '!.venv'
  --glob '!dist'
  --glob '!build'
)

RG_OPTIONS="--files --hidden --follow ${FZF_EXCLUDES[*]}"
export FZF_DEFAULT_COMMAND="rg $RG_OPTIONS"
export FZF_DEFAULT_OPTS='--height 80% --layout=reverse --border --info=inline --bind "?:toggle-preview,ctrl-f:half-page-down,ctrl-b:half-page-up,ctrl-a:select-all+accept,ctrl-y:preview-up,ctrl-e:preview-down"'

########################################
# EDITOR 
########################################
export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER='nvim +Man!'

