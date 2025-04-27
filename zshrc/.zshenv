# Skip, done by ZIM
skip_global_compinit=1

# FZF
export PATH="$HOME/.fzf/bin:$PATH"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [ -e /home/habichta/.nix-profile/etc/profile.d/nix.sh ]; then . /home/habichta/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
