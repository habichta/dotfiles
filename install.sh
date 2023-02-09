sudo apt update
sudo apt install git-all
sudo apt install python3
sudo apt install python3-pip
sudo apt install neovim

#BASIC
sudo apt install build-essential zlib1g-dev libffi-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev liblzma-dev


pip install virtualenv

cd ~/.dotfiles
git submodule update --init --recursive

#PYENV
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv

#TMUX
sudo apt install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
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
deactivate

##Update Plugins
cd ~/.dotfiles/vim/.vim/pack/plugins/start
./update.sh

## COC Plugin
cd ~/.dotfiles/vim/.vim/pack/plugins/start/coc.nvim
yarn install

vim -c "CocInstall coc-pyright | CocInstall coc-snippets | 
  CocInstall coc-actions | CocInstall coc-eslint | CocInstall coc-prettier | 
  CocInstall coc-tsserver | CocInstall coc-json | CocInstall coc-yaml | 
  CocInstall coc-html | CocInstall coc-go | CocInstall coc-rust-analyzer"


# CTAGS
ln -sf ~/.dotfiles/ctags/.ctags ~/.ctags

#GIT
ln -sf ~/.dotfiles/git/.gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/git/.git-templates ~/ 



