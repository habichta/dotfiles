#!/bin/bash
update_window_name() {
  if [ -n "$TMUX" ]; then
      local REPO_NAME=$(basename "$(git rev-parse --show-toplevel 2>/dev/null)")
      if [ $? -eq 0 ] && [ -n "$REPO_NAME" ]; then
          tmux rename-window "$REPO_NAME"

      else
          tmux set-window-option automatic-rename on
      fi
  fi
}

update_window_name
