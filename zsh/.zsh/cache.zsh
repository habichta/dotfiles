########################################
# Cached subprocess evals — refresh with `zsh-cache-refresh`
########################################

ZSH_CACHE_DIR="$HOME/.cache/zsh"
cached_eval() {
  local key=$1; shift
  local cache="$ZSH_CACHE_DIR/$key.zsh"
  if [[ ! -f "$cache" ]]; then
    mkdir -p "$ZSH_CACHE_DIR"
    "$@" > "$cache" 2>/dev/null
    zcompile "$cache" 2>/dev/null
  fi
  source "$cache"
}
zsh-cache-refresh() { rm -rf "$ZSH_CACHE_DIR" && echo "Cleared $ZSH_CACHE_DIR — restart your shell."; }

cached_eval starship starship init zsh
cached_eval mise     /home/habichta/.local/bin/mise activate zsh
cached_eval uvx      uvx --generate-shell-completion zsh
cached_eval uv       uv  --generate-shell-completion zsh
