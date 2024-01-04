set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
ln -s ~/.config/nvim/bin/node /usr/bin/node
source ~/.vimrc

"Vim PLUG
 
call plug#begin()
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'famiu/bufdelete.nvim'
Plug 'mfussenegger/nvim-dap-python'
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-web-devicons'
call plug#end()

luafile ~/.config/nvim/lua/init.lua

