########################################
# Loader — modules live in ~/.zsh/
#
#   basic.zsh      terminal, tmux, ssh-agent, ~/.local/bin env
#   options.zsh    zmodload / autoload / compinit / setopt
#   functions.zsh  shell functions
#   bindkeys.zsh   key bindings
#   completion.zsh completion styling
#   cache.zsh      cached_eval + starship/mise/uv init
#   aliases.zsh    general aliases
#   wsl.zsh        Windows interop: vpn, ff, explorer, vlc
#   web.zsh        web-* page shortcuts (needs ff from wsl.zsh)
#
# Order matters: options.zsh runs compinit, which completion.zsh builds on,
# and basic.zsh sets PATH bits that cache.zsh needs to find uv/uvx.
########################################
[ -z "$ZPROF" ] || zmodload zsh/zprof

# Byte-compile each module to <file>.zwc. `source foo.zsh` transparently reads
# foo.zsh.zwc whenever it is newer, and silently falls back to the plain file
# when it is stale — so a missed recompile costs speed, never correctness.
# This differs from the .zcompdump case in options.zsh, which was a loss only
# because compinit rewrites the dump on every start; these modules are static.
() {
  local f
  for f in ~/.zsh/*.zsh(N) ~/.zsh/plugins/*/*.zsh(N) ~/.zsh/plugins/*/*/*.zsh(N); do
    [[ -s $f.zwc && $f.zwc -nt $f ]] || zcompile -- $f 2>/dev/null
  done
}

source ~/.zsh/basic.zsh
source ~/.zsh/options.zsh

source ~/.zsh/plugins/zsh-z/zsh-z.plugin.zsh
source ~/.zsh/functions.zsh
source ~/.zsh/bindkeys.zsh
source ~/.zsh/completion.zsh

# fzf-tab must come after compinit (options.zsh) and after the completion
# zstyles above, since it wraps the completion widget.
source ~/.zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
source ~/.zsh/fzf-tab.zsh

#ZSH hooks - changes TMUX windows name when changing directories
add-zsh-hook chpwd update-tmux-window-name

source ~/.zsh/cache.zsh
source ~/.zsh/aliases.zsh
source ~/.zsh/wsl.zsh
source ~/.zsh/web.zsh

[ -z "$ZPROF" ] || zprof
