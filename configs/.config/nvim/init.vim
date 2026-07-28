" Configuration for Vim -> Neovim transition
" https://neovim.io/doc/user/nvim.html#nvim-from-vim
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc

"Vim PLUG

call plug#begin()
  Plug 'bkad/CamelCaseMotion'
  Plug 'famiu/bufdelete.nvim'
  Plug 'github/copilot.vim'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'lfv89/vim-interestingwords'
  Plug 'mhinz/vim-startify'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'nvim-lualine/lualine.nvim'
  Plug 'nvim-tree/nvim-tree.lua'
  Plug 'nvim-tree/nvim-web-devicons'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate', 'branch' : 'main'}
  Plug 'sainnhe/gruvbox-material'
  Plug 'tpope/vim-obsession'
  Plug 'tpope/vim-surround'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'tpope/vim-fugitive'
  Plug 'vim-test/vim-test'
  Plug 'mg979/vim-visual-multi', {'branch': 'master'}
  Plug 'brenoprata10/nvim-highlight-colors'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'greggh/claude-code.nvim'
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
  Plug 'nvim-treesitter/nvim-treesitter-context',
  Plug 'olimorris/codecompanion.nvim', {'tag': 'v19.13.0'}
 call plug#end()

luafile ~/.config/nvim/lua/init.lua
