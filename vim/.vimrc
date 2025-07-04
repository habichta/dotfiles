" GENERAL
" Disable compatibility with vi which can cause unexpected issues.
set nocompatible
" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on
" Enable plugins and load plugin for the detected file type.
filetype plugin on
" Load an indent file for the detected file type.
filetype indent on
" Turn syntax highlighting on."
syntax on
" use default linux encoding in vim
set encoding=utf8
" share the plus register with the system clipboard
set clipboard=unnamedplus
" Map Leader
let mapleader = ","
" Local Map Leader
let localmapleader = "\\"

" number of spaces that a <Tab> counts for
set tabstop=2
" number of spaces to use for each step of (auto)indent
set shiftwidth=2
" same like those above, more or less - maybe...
set softtabstop=2
" expand all tabs to spaces
set expandtab
" make <Tab> work a bit better - I think...
set smarttab
" indent to a multiple of shiftwidth instead of inserting (expanded) <Tab>s
set shiftround
" copy indent from current line when starting a new line
" but discard the indentation if the line remains empty
set copyindent
set autoindent

" Allow per project .vimrc/.nvimrc files
set exrc


" SEARCH
"
" While searching though a file incrementally highlight matching characters
" as you type.
set incsearch
" Use highlighting when doing a search.
set hlsearch
" Override the ignorecase option if searching for capital letters.
" This will allow you to search specifically for capital letters.
set ignorecase

"COMMAND LINE
set smartcase
" Show partial command you type in the last line of the screen.
set showcmd
" Show the mode you are on the last line.
set showmode
" Show matching words during a search.
set showmatch
" Set the commands to save in history default number is 20.
set history=1000
set undolevels=1000
" Enable auto completion menu after pressing TAB.
set wildmenu
" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest
" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx


"SPLIT PANES
" open new split panes to right and bottom
set splitbelow
set splitright

"AUTOREAD
" Automatically reload files that have been changed outside of Vim.
set autoread

"CTAGS
exec 'set tags+=' . findfile('.git/tags', ';')

"Python3
let g:python3_host_prog = '~/.config/nvim/venv/bin/python3'

"Node - Does not work, there is an issue with project yarn being used instead
"of global yarn, need to set copilot node command explicitly
let g:node_host_prog = expand('~/.local/share/mise/installs/node/22.12.0/bin/neovim-node-host')
let $YARN_PATH = '/usr/bin/yarn'
let g:copilot_node_command = '~/.local/share/mise/installs/node/22.12.0/bin/node'
