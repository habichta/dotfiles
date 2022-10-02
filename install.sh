cd ~/.dotfiles
git submodule update --init --recursive

#TMUX
ln -s ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf

#ZSHRC
ln -s ~/.dotfiles/zshrc/.zshrc ~/.zshrc
ln -s ~/.dotfiles/zshrc/.dircolors ~/.dircolors 

#FZF
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

#NVIM
ln -s ~/.dotfiles/vim/.vimrc ~/.vimrc
ln -s ~/.dotfiles/configs/.config/nvim ~/.config/
ln -s ~/.dotfiles/vim/.vim ~/ 

## NVIM Python
cd ~/.dotfiles/configs/.config/nvim
virtualenv venv
vact
pip install neovim
pip install rope
pip install black

##Update Plugins
~/.dotfiles/vim/.vim/pack/plugins/start
./update.sh

## COC Plugin
cd ~/.dotfiles/vim/.vim/pack/plugins/start/coc.nvim
yarn install

vim -c "CocInstall coc-pyright"
vim -c "CocInstall coc-snippets"
vim -c "CocInstall coc-actions"


# CTAGS
ln -s ~/.dotfiles/ctags/.ctags ~/.ctags

#GIT
ln -s ~/.dotfiles/git/.gitconfig ~/.gitconfig
ln -s ~/.dotfiles/git/.git-templates ~/ 



