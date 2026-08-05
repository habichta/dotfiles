########################################
# Aliases
########################################

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
alias jup="uv run --with jupyter jupyter lab" # Jupyter Lab via uv, using current virtualenv
alias ipy="ipython"

#Download / Watch Youtube Video / Install yt-dlp using uv tool and stable commit from repo
alias youtubed='yt-dlp -f "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]" -o "$HOME/Downloads/%(title)s.%(ext)s"'
