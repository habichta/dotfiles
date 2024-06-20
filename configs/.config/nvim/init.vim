set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
ln -s ~/.config/nvim/bin/node /usr/bin/node
source ~/.vimrc

"Vim PLUG
 
call plug#begin()
Plug 'akinsho/bufferline.nvim', { 'tag': '*' }
Plug 'bkad/CamelCaseMotion'
Plug 'christoomey/vim-tmux-navigator'
Plug 'famiu/bufdelete.nvim'
Plug 'fisadev/vim-isort'
Plug 'github/copilot.vim'
Plug 'jremmen/vim-ripgrep'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'lfv89/vim-interestingwords'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'mhinz/vim-startify'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'nvim-lualine/lualine.nvim'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'psf/black'
Plug 'ryanoasis/vim-devicons'
Plug 'sainnhe/gruvbox-material'
Plug 'stevearc/aerial.nvim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-surround'
Plug 'gelguy/wilder.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive', {'on':'G'}
call plug#end()

luafile ~/.config/nvim/lua/init.lua

