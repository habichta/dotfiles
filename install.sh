sudo apt update
sudo apt install zsh
chsh -s $(which zsh)

#Log in and out

sudo apt install git-all
sudo apt install python3
sudo apt install python3-pip
sudo apt install neovim
sudo apt install tree
sudo apt install bat
sudo apt install neofetch

#BASIC
sudo apt install build-essential zlib1g-dev libffi-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev liblzma-dev tk-dev


pip install virtualenv

cd ~/.dotfiles
git submodule update --init --recursive

mkdir ~/.config

#TERMINAL
ln -sf ~/.dotfiles/terminal/tilda ~/.config/tilda

#GIT
ln -sf ~/.dotfiles/git/.gitconfig ~/.gitconfig
ln -sf ~/.dotfiles/git/.git-templates ~/ 

#PYENV
git clone https://github.com/pyenv/pyenv.git ~/.pyenv

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

git clone https://github.com/pyenv/pyenv-virtualenv.git $(pyenv root)/plugins/pyenv-virtualenv

#TMUX
sudo apt install tmux
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -sf ~/.dotfiles/tmux/.tmux.conf ~/.tmux.conf
#source ~/tmux.conf
#Press prefix + I (capital i, as in Install) to fetch the plugin.

#OHMyZSH
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
#ZSHRC
ln -sf ~/.dotfiles/zshrc/.zshrc ~/.zshrc
ln -sf ~/.dotfiles/zshrc/.gruvbox.dircolors ~/.gruvbox.dircolors 


#FZF
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

#Yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt update && sudo apt install --no-install-recommends yarn

#NVIM
sudo snap install --beta nvim --classic
ln -sf ~/.dotfiles/vim/.vimrc ~/.vimrc
ln -sf ~/.dotfiles/configs/.config/nvim ~/.config/
ln -sf ~/.dotfiles/vim/.vim ~/ 


#Python 3.11.2
pyenv install -v 3.11.2
pyenv global 3.11.2

## NVIM Python
cd ~/.dotfiles/configs/.config/nvim
virtualenv venv
source venv/bin/activate
pip install neovim
pip install rope
pip install black
deactivate

##Update Plugins
cd ~/.dotfiles/vim/.vim/pack/plugins/start
./update.sh

## Install NVM
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
source ~/.zshrc
nvm install node

## COC Plugin
cd ~/.dotfiles/vim/.vim/pack/plugins/start/coc.nvim
yarn install

vim -c "CocInstall coc-pyright | CocInstall coc-snippets | 
  CocInstall coc-actions | CocInstall coc-eslint | CocInstall coc-prettier | 
  CocInstall coc-tsserver | CocInstall coc-json | CocInstall coc-yaml | 
  CocInstall coc-html | CocInstall coc-go | CocInstall coc-rust-analyzer"

## TODO install watchman
#https://facebook.github.io/watchman/docs/install.html
#Required for updating imports on filename changes



# CTAGS
ln -sf ~/.dotfiles/ctags/.ctags ~/.ctags

#Lazygit
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf lazygit.tar.gz lazygit
sudo install lazygit /usr/local/bin
rm lazygit, lazygit.tar.gz

## Fonts
# Select font in respective terminal
wget https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DejaVuSansMono/Regular/complete/DejaVu%20Sans%20Mono%20Nerd%20Font%20Complete.ttf -P ~/.local/share/fonts/NerdFonts

