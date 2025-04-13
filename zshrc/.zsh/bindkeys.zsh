bindkey -v #vi mode

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

# Widgets
bindkey -M viins '^[s' vf
bindkey -M vicmd '^[s' vf

bindkey -M vicmd '^[x' d

bindkey -M vicmd '^[\[' ssh_with_fzf

bindkey -M viins '^[z' fzf_z_widget
bindkey -M vicmd '^[z' fzf_z_widget

bindkey -M viins '^[g' gb
bindkey -M vicmd '^[g' gb

# bindkey -M viins '^[p' lpass_fzf_widget
# bindkey -M vicmd '^[p' lpass_fzf_widget
