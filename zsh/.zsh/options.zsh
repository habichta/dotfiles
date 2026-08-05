########################################
# ZSH autoload / setopt
########################################

# Should be called before compinit
zmodload zsh/complist
autoload -Uz compinit add-zsh-hook edit-command-line

# Run the full compinit (which invokes the slow compaudit) at most once a day,
# otherwise load straight from the dump.
#
# This MUST be an anonymous function, not `[[ -n <glob> ]]`: [[ ]] does not
# perform filename generation, so the glob qualifier stayed a literal non-empty
# string and the test was ALWAYS true — the audit ran on every shell. Passing
# the glob as an argument is what actually expands it.
#
# NB: correctness fix only, no measured startup win (compinit -uC costs the
# same as -u here). And do NOT add `typeset -U fpath FPATH` to dedupe fpath:
# measured 91ms -> 418ms. Nor zcompile the dump: compinit rewrites it every
# start, so the .zwc is rebuilt every start (91ms -> 478ms).
() {
  if (( $# )); then compinit -u; else compinit -uC; fi
} ${ZDOTDIR:-$HOME}/.zcompdump(N.mh+24)

zle -N edit-command-line

setopt IGNORE_EOF # Ignore EOF; use 'exit' to quit the shell
setopt SHARE_HISTORY # Share history between all sessions
setopt AUTO_PUSHD # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS # Do not store duplicates in the stack.
setopt PUSHD_SILENT # Do not print the directory stack after pushd or popd.

#Colorscheme for Dirs
eval "$(dircolors ~/.gruvbox.dircolors)"
