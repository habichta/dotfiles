bindkey -v #vi mode
export KEYTIMEOUT=1 # make switch between modes faster

# Allow Emacs bindings in vi mode
bindkey "^A"   beginning-of-line
bindkey "^B"   backward-char
bindkey "^F"   forward-char
bindkey "^E"   end-of-line
bindkey "^K"   kill-line
bindkey -M viins "^D"  backward-delete-char
bindkey "^[d"  kill-word
bindkey "^[b" backward-word
bindkey "^[f" forward-word
bindkey '^X^E' edit-command-line

bindkey -M viins '\e[1;5D' backward-word    # Ctrl + Left
bindkey -M viins '\e[1;5C' forward-word     # Ctrl + Right

bindkey -M vicmd '\e[1;5D' backward-word    # Ctrl + Left in command mode
bindkey -M vicmd '\e[1;5C' forward-word     # Ctrl + Right in command mode

# Widgets
bindkey -M viins '^[s' vf
bindkey -M vicmd '^[s' vf

bindkey -M vicmd '^[x' d

bindkey -M viins '^[\[' ssh_with_fzf
bindkey -M vicmd '^[\[' ssh_with_fzf

bindkey -M viins '^[z' fzf_z_widget
bindkey -M vicmd '^[z' fzf_z_widget

bindkey -M viins '^[g' gb
bindkey -M vicmd '^[g' gb

# bindkey -M viins '^[p' lpass_fzf_widget
# bindkey -M vicmd '^[p' lpass_fzf_widget

# Use hjlk in menu selection (during completion)
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect '^xg' clear-screen
bindkey -M menuselect '^xi' vi-insert
bindkey -M menuselect '^xh' accept-and-hold
bindkey -M menuselect '^xn' accept-and-infer-next-history 
bindkey -M menuselect '^xu' undo                           
