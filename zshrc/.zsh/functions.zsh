function update-tmux-window-name() {
if [ -n "$TMUX" ]; then
     update-tmux-window-name.sh
fi
}

# Quick way do go to previously visited directories
function d() {
  ddir="$(dirs -v | awk '{print $2}' | fzf)"
  ddir=${ddir/#\~/${HOME}} 
  cd "$ddir"
  zle reset-prompt
}
zle -N d
bindkey '^d' d

# Check if inside a Git repository, if not a git repository, use fd to search
# Search and open with neovim or cd, depending on file type
function vf() {
    if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        # Customize fzf for Git repositories
        local item=$(git ls-files | fzf --preview '[[ -f {} ]] && (batcat --style=numbers --color=always {} || cat {}) || tree -C {}' --preview-window=right:50%:wrap )
    else
        # Standard fzf behavior
        local item=$(fd --type f --type d -H . | grep -I . | fzf --preview 'if [[ -d {} ]]; then tree -C {}; elif [[ -f {} ]]; then batcat --style=numbers --color=always {} || cat {}; fi' --preview-window=right:50%:wrap)
    fi
    if [ -n "$item" ]; then
        if [ -d "$item" ]; then
            cd "$item"
        elif [ -f "$item" ]; then
            v "$item"
        fi
    fi
    zle reset-prompt
}
zle -N vf
bindkey '^s' vf


# Gather hosts from 'step ssh hosts' if available and remove sedimentum internal
function gather_step_hosts() {
    if command -v step >/dev/null 2>&1; then
      step ssh hosts | tail -n +2 | tr -d \\t | grep -v '.sedimentum.internal$'
    fi
}

function ssh_with_fzf() {
  # Gather hosts from SSH config
  config_hosts=$(awk '$1 == "Host" && $2 !~ /\*/ {print $2}' ~/.ssh/config)

  # Include hosts from 'step ssh hosts' if available
  step_hosts=$(gather_step_hosts)

  # Combine all hosts and remove duplicates
  all_hosts=($(
      echo "${config_hosts[@]}" "${step_hosts[@]}" |
      awk 'NF' |                # Remove empty lines
      sort -u                  # Sort and remove duplicates
  ))

  # Use fzf to select a host
  selected_host=$(printf "%s\n" "${all_hosts[@]}" | fzf )

  # SSH into the selected host
  if [[ -n "$selected_host" ]]; then
        BUFFER="ssh $selected_host" # Note that calling ssh within a widget does not work since it is not attached to a terminal
        zle accept-line  # This simulates pressing Enter, executing the command
  fi
}

zle -N ssh_with_fzf
bindkey '^f' ssh_with_fzf

fzf_z_widget() {
  local selected_dir
  selected_dir=$(z -l 2>&1 | sed '1d' | fzf --no-preview | awk '{print $2}')
  if [[ -n "$selected_dir" ]]; then
    BUFFER="cd $selected_dir"
    zle accept-line
  fi
}

zle -N fzf_z_widget
bindkey '^z' fzf_z_widget

# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
function fo() {
  IFS=$'\n' out=("$(fzf --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR} "$file"
  fi
}

# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
function fkill() {
    local pid 
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    fi  

    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi  
}

# use CTRL+G/CTRL+? to select git things with FZF
# https://junegunn.kr/2016/07/fzf-git/
function _is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

#Git history v1
function gb() {
  _gitLogLineToHash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1 | tr -d '\n'"
  _viewGitLogLine="$_gitLogLineToHash | xargs -I % sh -c 'git show --color=always % | diff-so-fancy'"
  git log --graph --abbrev-commit --decorate --date=short --color=always --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%ad%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all |
    fzf --no-sort --reverse --tiebreak=index --no-multi \
    --ansi --preview="$_viewGitLogLine" \
    --header "enter to view, alt-c to copy hash to clipboard" \
    --bind "enter:execute:$_viewGitLogLine | less -R" \
    --bind "alt-c:execute:$_gitLogLineToHash | xclip -i -sel c" \
    --preview-window=right:40%
}
zle -N gb
bindkey '^g' gb

#Git history v2
function ghi() {
  _is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
    fzf --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always' |
    grep -o "[a-f0-9]\{7,\}"
}

# Quickly load an env file into the current shell
function load_env_file() {
    if [ "$#" -ne 1 ]; then
        echo "Usage: load_env <path_to_env_file>"
        return 1
    fi

    local env_file=$1

    if [ -f "$env_file" ]; then
        set -a
        source "$env_file"
        set +a
        echo "Environment variables from $env_file have been loaded."
    else
        echo "Error: File '$env_file' not found!"
        return 1
    fi
}

Ag() {
    local query="${1:-}"

    if [[ -n "$query" ]]; then
        # Perform the search and format the output for fzf
        local item=$(git ls-files | xargs ag --hidden --ignore "*.ipynb" --ignore-dir deps --ignore-dir node_modules  "$query" |
        awk -F':' -v query="$query" '{printf "%s:\n", $0}' | 
        fzf --preview 'batcat --style=numbers --color=always --line-range :300 $(echo {} | cut -d ":" -f 1)' --preview-window=right:50%:wrap --height 40% --header="Files containing: $query")

        if [[ -n "$item" ]]; then
            # Extract the filename and line number from the selected item
            local filename=$(echo "$item" | cut -d':' -f1)
            local line_number=$(echo "$item" | cut -d':' -f2)
            vim "+${line_number}" "$filename"  # Open Vim at the specific line
        fi
    fi
}
