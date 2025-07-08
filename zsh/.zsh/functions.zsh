function update-tmux-window-name() {
if [ -n "$TMUX" ]; then
     update-tmux-window-name.sh
fi
}

##### Improve ZSH Vi mode with text objects and vim-surround mechanics
autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in viopp visual; do
  bindkey -M $km -- '-' vi-up-line-or-history
  for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}; do
    bindkey -M $km $c select-quoted
  done
  for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
    bindkey -M $km $c select-bracketed
  done
done

autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround

# Quick way do go to previously visited directories
function d() {
  ddir="$(dirs -v | awk '{print $2}' | fzf)"
  ddir=${ddir/#\~/${HOME}} 
  cd "$ddir"
  zle reset-prompt
}
zle -N d

# Check if inside a Git repository, if not a git repository, use rg to search
# Search and open with neovim or cd, depending on file type
function vf() {
  local item
  local excludes=(
    '-g' '!downloads/'
    '-g' '!.local/'
    '-g' '!.cache/'
    '-g' '!**/node_modules/**'
    '-g' '!**/.venv/**'
    '-g' '!.tmux/plugins/'
    '-g' '!.config/coc/'
    '-g' '!.fzf/'
    '-g' '!.git/'
    '-g' '!.npm/'
  )

  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    item=$(git ls-files -z | fzf --read0 \
      --preview '[[ -f {} ]] && (batcat --style=numbers --color=always {} || cat {}) || tree -C {}' \
      --preview-window=right:50%:wrap)
  else
    item=$(rg --files --hidden --follow "${excludes[@]}" 2>/dev/null | \
      fzf --preview '[[ -f {} ]] && (batcat --style=numbers --color=always {} || cat {}) || tree -C {}' \
          --preview-window=right:50%:wrap)
  fi

  if [[ -n "$item" ]]; then
    if [[ -d "$item" ]]; then
      cd "$item"
    elif [[ -f "$item" ]]; then
      nvim "$item"
    fi
  fi

  zle reset-prompt
}
zle -N vf

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
      awk 'NF' |  sort -u
  ))

  # Use fzf to select a host
  selected_host=$(printf "%s\n" "${all_hosts[@]}" | fzf )

  # SSH into the selected host
  if [[ -n "$selected_host" ]]; then
        BUFFER="ssh $selected_host" # Note that calling ssh within a widget does not work since it is not attached to a terminal
        zle accept-line  # This simulates pressing Enter, executing the command
  fi
  zle reset-prompt
}

zle -N ssh_with_fzf

fzf_z_widget() {
  local selected_dir
  selected_dir=$(z -l 2>&1 | fzf --no-preview | awk '{print $2}')
  if [[ -n "$selected_dir" ]]; then
    cd $selected_dir
  fi
  zle reset-prompt
}

zle -N fzf_z_widget

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
    --bind "alt-c:execute-silent:$_gitLogLineToHash | clip.exe"
    --preview-window=right:40%
  zle reset-prompt
}
zle -N gb

# Search LastPass for a password
lpass_fzf_widget() {
  password=$(lpass ls | fzf --query '!Archive ' | awk '{print $(NF)}' | sed 's/\]//g')
  if [[ -n "$password" ]]; then
    lpass show -c --password "$password"
  fi

  zle reset-prompt
}

# Register the widget
zle -N lpass_fzf_widget

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


# Rg() {
#   local query="${1:-}"
#   if [[ -n "$query" ]]; then
#     local item=$(git ls-files | xargs rg --json --json-seq |
#       jq -r "select(.data.lines.text | test(\"$query\")) | \"\(.data.path):\(.data.line_number)\"" 2>/dev/null |
#       fzf --preview 'batcat --style=numbers --color=always {1} | rg --context 10 -F {2} {1}' --preview-window=right:70%:wrap --height 40% --header="Files containing: $query")

#     if [[ -n "$item" ]]; then
#       local filename=$(echo "$item" | cut -d':' -f1)
#       local line_number=$(echo "$item" | cut -d':' -f2)
#       nvim "+${line_number}" "$filename"
#     fi
#   fi
# }



is_valid_tz() {
    [[ -f "/usr/share/zoneinfo/$1" || -L "/usr/share/zoneinfo/$1" ]]
}

convert_timezone() {
    local input_time="$1"
    local from_tz="${2:-$(date +%Z)}"
    local to_tz="$3"

    if [ -z "$to_tz" ]; then
        echo "Usage: convert_timezone [<time>] [<from_timezone>] <to_timezone>"
        return 1
    fi

    # Validate from_tz
    if ! is_valid_tz "$from_tz"; then
        echo "Invalid from timezone: $from_tz"
        return 1
    fi

    # Validate to_tz
    if ! is_valid_tz "$to_tz"; then
        echo "Invalid to timezone: $to_tz"
        return 1
    fi

    local today=$(date +%Y-%m-%d)
    input_time="${input_time:-now}"

    if [[ "$input_time" =~ ^[0-9]{1,2}:[0-9]{2}(:[0-9]{2})?$ ]]; then
        input_time="$today $input_time"
    fi

    local utc_epoch
    utc_epoch=$(TZ="$from_tz" date -d "$input_time" +%s) || {
        echo "Invalid input time or timezone"
        return 1
    }

    TZ="$to_tz" date -d "@$utc_epoch" +"%Y-%m-%d %H:%M:%S %Z"
}


function pipx_install() {
  read -p "Enter the package: " package
  read -p "Enter the python version: " python_version
  read -p "Enter the version (optional): " version

  python_path=$(mise where python@$python_version)/bin/python
  
  if [ -z "$version" ]; then
    pipx install $package --python $python_path
  else
    pipx install $package==$version --python $python_path
  fi
}
#Update Python Dependencies of a Service Repo for Development
function helpany_update_dev_python_deps {
    # Path to requirements file
    requirements_file="requirements/dev.txt"

    # Check if in virtualenv
    if [[ -z "$VIRTUAL_ENV" ]]; then
        echo "No virtual environment found. Please activate one before running this function."
        return 1
    fi

    # Check if deps/ directory exists
    if [[ -d "deps" ]]; then
        echo "Installing dependencies from submodules in deps/"

        for dir in deps/*/; do
            if [[ -d "$dir" ]]; then
                echo "Installing dependencies from $dir"
                pip install "$dir"
            fi
        done
    else
        echo "No deps/ directory found."
    fi
    # Check if requirements file exists
    if [[ ! -f "$requirements_file" ]]; then
        echo "requirements/dev.txt not found."
        return 1
    fi

    # Install dependencies from requirements file, ignoring lines starting with -e file:///
    grep -v '^-e file:///' "$requirements_file" | pip install -r /dev/stdin
}
