set runtimepath^=~/.vim runtimepath+=~/.vim/after
source ~/.vimrc

"Vim PLUG
 
call plug#begin()
Plug 'bkad/CamelCaseMotion'
Plug 'famiu/bufdelete.nvim'
Plug 'fisadev/vim-isort', {'on': 'Isort'}
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
Plug 'psf/black', {'on': 'Black'}
Plug 'ryanoasis/vim-devicons'
Plug 'sainnhe/gruvbox-material'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-surround'
Plug 'gelguy/wilder.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'tpope/vim-fugitive', {'on': 'G'}
Plug 'vim-test/vim-test'
Plug 'christoomey/vim-tmux-navigator'
Plug 'rhysd/vim-clang-format'
Plug 'liuchengxu/vista.vim', {'on': 'Vista'}
Plug 'mg979/vim-visual-multi', {'branch': 'master'}
Plug 'antoinemadec/coc-fzf', {'branch': 'release'}
call plug#end()

luafile ~/.config/nvim/lua/init.lua

