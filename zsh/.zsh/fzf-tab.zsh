########################################
# fzf-tab tuning
#
# Loaded right after the plugin itself. `menu select` from completion.zsh is
# superseded by fzf-tab, but is kept there as the fallback if the plugin is
# ever removed.
########################################

# Keep the group label visible (tells you *what* you are picking).
zstyle ':fzf-tab:*' show-group full
zstyle ':completion:*:descriptions' format '[%d]'

# fzf-tab reads this rather than FZF_DEFAULT_OPTS.
# --preview-window=wrap so long lines fold instead of being clipped; the help
# script also reflows man to $FZF_PREVIEW_COLUMNS, this is the safety net for
# anything it cannot reflow (tables, pre-formatted blocks).
zstyle ':fzf-tab:*' fzf-flags --height=60% --layout=reverse --border --ansi \
  --preview-window=wrap
zstyle ':fzf-tab:*' fzf-min-height 12

# Accept with Enter, cancel with Esc; keep Tab for fzf's own multi-select.
zstyle ':fzf-tab:*' continuous-trigger '/'
zstyle ':fzf-tab:*' switch-group '<' '>'

# One preview for everything. The trailing zstyle component is the completion
# argument/tag (e.g. argument-rest, option--mixed-1), which varies per command
# and cannot be pattern-matched reliably — so match '*' and let the script
# dispatch on $word: options get help text, paths get a listing/head.
# $words is dumped into the preview shell by fzf-tab's lib/-ftb-preview.tpl,
# so ${words[1]}/${words[2]} give the command and subcommand.
# The script lives in $DOTFILES/scripts, which .zshenv puts on PATH — it must
# be on PATH because fzf runs previews in a NON-interactive zsh that never
# sources .zshrc, so a shell function would not be visible there.
# NOTE: do NOT use ${words[1]} here — _git and friends shift $words for
# subcommands, so it would be "reset" rather than "git". $curcontext is
# ":complete:git-reset:argument-rest", whose 2nd field is the command as zsh
# knows it, which doubles as the man page name. zstyle -e evaluates at lookup
# time, while $curcontext is still in scope.
# Use $_ftb_curcontext, NOT $curcontext: fzf-tab saves it early precisely
# because $curcontext is no longer reliable by the time -ftb-fzf runs. It also
# has the leading ':' stripped, so field 2 is the command ("git-reset") —
# with $curcontext the leading ':' makes field 2 "complete" instead.
# $words[1] is passed too, for when zsh reports plain "git" and the "reset"
# half has to come from the word array.
# Plain ${words}, NOT ${(q)words}: inside double quotes (q) joins the array
# into one string and *then* escapes it, yielding "git\ reset\ --" — a single
# argument, so the man page lookup became "git-git reset --". Plain expansion
# joins with spaces and splits back into separate words, which is what the
# script wants (it ignores anything starting with "-" anyway).
zstyle -e ':fzf-tab:complete:*:*' fzf-preview \
  'reply=("ftb-option-help ${${(s.:.)_ftb_curcontext}[2]} ${words}")'
zstyle ':fzf-tab:complete:(-command-|):*' fzf-preview ''

# The ff completion already renders "<alias>  <url>", so no preview pane.
zstyle ':fzf-tab:complete:ff:*' fzf-preview ''
