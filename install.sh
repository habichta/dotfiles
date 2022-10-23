cd ~/.dotfiles
git submodule update --init --recursive

#TMUX
ln -sf ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf

#ZSHRC
ln -sf ~/.dotfiles/zshrc/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/zshrc/.dircolors ~/.dircolors 

#FZF
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

#Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install --no-install-recommends yarn

#NVIM
ln -sf ~/.dotfiles/vim/.vimrc ~/.vimrc
ln -sf ~/.dotfiles/configs/.config/nvim ~/.config/
ln -sf ~/.dotfiles/vim/.vim ~/ 

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
vim -c "CocInstall coc-eslint"
vim -c "CocInstall coc-prettier"
vim -c "CocInstall coc-tsserver"
vim -c "CocInstall coc-json"
vim -c "CocInstall coc-rust-analyzer"


# CTAGS
ln -sf ~/.dotfiles/ctags/.ctags ~/.ctags

#GIT
ln -sf ~/.dotfiles/git/.gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/git/.git-templates ~/ 



