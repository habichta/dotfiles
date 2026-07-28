
""""""""""""""""""""""""
" Visual configuration "
""""""""""""""""""""""""
" Contains configuration for:
" - colorscheme
" - vim-airline
" - general visual stuff
set background=dark
colorscheme gruvbox-material
"}}}

" General "{{{
" always show the status line
set laststatus=2
" display tabs and linebreaks
set list
" change whitespace character representation
set listchars=trail:~,tab:»·,eol:⏎
" display symbol for wrapped lines on new line
set showbreak=↪
" indent guides are added to 'listchars' per-buffer by lua/functions/indent-guides.lua
"}}}
"

" Add numbers to each line on the left-hand side."
set number
set relativenumber
" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=20
" Do not wrap lines. Allow long lines to extend as far as the line goes.
set nowrap
