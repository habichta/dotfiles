bindkey -v #vi mode
# 10ms. Low on purpose: it is what lets Alt-combos (^[s, ^[g, ...) resolve
# instantly while keeping ESC's switch to command mode snappy. Do not raise it.
export KEYTIMEOUT=1

# ESC toggles between the two modes rather than only entering command mode, so
# a mistaken ESC costs one keystroke to undo.
#
# Entering command mode shifts the cursor one column left (genuine vi), so
# toggling straight back with `vi-insert` would leave you off by one. We
# remember the insert-mode column and restore it -- but only when the cursor
# has not moved since, otherwise a deliberate ESC, navigate, ESC would yank you
# back to a stale position.
typeset -g _VI_ESC_COL=-1 _VI_ESC_AT=-1

function vi-esc-to-cmd {
  local before=$CURSOR
  zle vi-cmd-mode
  _VI_ESC_COL=$before
  _VI_ESC_AT=$CURSOR
}

function vi-esc-to-insert {
  zle vi-insert
  if (( _VI_ESC_COL >= 0 && _VI_ESC_AT == CURSOR )); then
    CURSOR=$_VI_ESC_COL
  fi
  _VI_ESC_COL=-1
}

zle -N vi-esc-to-cmd
zle -N vi-esc-to-insert
bindkey -M viins '^[' vi-esc-to-cmd
bindkey -M vicmd '^[' vi-esc-to-insert

# Mode indicator: block cursor in command mode, beam in insert. Without this
# there is nothing on screen saying which mode you are in. tmux advertises the
# Ss/Se capabilities, so the escapes reach the terminal through it.
function zle-keymap-select {
  case $KEYMAP in
    vicmd)      print -n '\e[2 q' ;;  # block
    viins|main) print -n '\e[6 q' ;;  # beam
  esac
}
zle -N zle-keymap-select

# Each new prompt starts in insert mode, and a command that left the cursor as
# a block (vim, less) should not leak that shape into the next prompt.
function _vi_beam_cursor { print -n '\e[6 q' }
add-zsh-hook precmd _vi_beam_cursor

# Emacs-style bindings, in BOTH keymaps.
#
# These used to be plain `bindkey`, which only touches the *current* keymap --
# viins, after `bindkey -v` above -- so none of them existed in command mode.
# zsh's vicmd leaves ^A/^B/^E/^F unbound (it has no page-scroll on ^B/^F the
# way vim does), so claiming them here costs no vi behaviour.
for km in viins vicmd; do
  bindkey -M $km "^A"    beginning-of-line
  bindkey -M $km "^B"    backward-char
  bindkey -M $km "^F"    forward-char
  bindkey -M $km "^E"    end-of-line
  bindkey -M $km "^[d"   kill-word
  bindkey -M $km "^[b"   backward-word
  bindkey -M $km "^[f"   forward-word
  bindkey -M $km '^X^E'  edit-command-line
done
unset km

bindkey -M viins "^D"  backward-delete-char

# ^K/^J walk history. Deliberately viins-only: in command mode j/k already do
# this, and ^J is LF, which some terminals send for Enter.
# (A `bindkey "^K" kill-line` used to sit above and was silently overwritten
# here -- kill-line was never actually reachable.)
bindkey -M viins '^K' up-line-or-history
bindkey -M viins '^J' down-line-or-history

bindkey -M viins '\e[1;5D' backward-word    # Ctrl + Left
bindkey -M viins '\e[1;5C' forward-word     # Ctrl + Right

bindkey -M vicmd '\e[1;5D' backward-word    # Ctrl + Left in command mode
bindkey -M vicmd '\e[1;5C' forward-word     # Ctrl + Right in command mode

# Widgets
# vf on both Alt-s and Ctrl-S. Ctrl-S is only free because basic.zsh runs
# `stty -ixon` to disable XOFF flow control; without that the key would freeze
# the terminal instead. Until now it was falling through to self-insert, which
# is why pressing it typed a literal ^S.
bindkey -M viins '^[s' vf
bindkey -M vicmd '^[s' vf
bindkey -M viins '^S'  vf
bindkey -M vicmd '^S'  vf

bindkey -M viins '^[S' vig
bindkey -M vicmd '^[S' vig

bindkey -M vicmd '^[x' d

# Was Alt-[ -- but Alt-[ IS the byte pair ESC [, the CSI introducer that starts
# nearly every special key. Any CSI sequence not bound explicitly (PageUp,
# PageDown, Home/End variants, Ctrl-Delete ...) fell back to this binding and
# launched the ssh picker. Moved to Alt-r; do not put anything on ESC [.
bindkey -M viins '^[r' ssh_with_fzf
bindkey -M vicmd '^[r' ssh_with_fzf

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

# Enable menu selection
bindkey '^[[Z' reverse-menu-complete  # Shift-Tab for backward
