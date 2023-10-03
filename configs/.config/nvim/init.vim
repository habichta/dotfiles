set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
ln -s ~/.config/nvim/bin/node /usr/bin/node
source ~/.vimrc

"Vim PLUG
 
call plug#begin()
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
call plug#end()


luafile ~/.config/nvim/lua/init.lua

