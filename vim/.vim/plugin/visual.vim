
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

" vim-airline "{{{
" tell airline to use symbols of the powerline font
let g:airline_powerline_fonts = 1
" display buffers instead of tabs if no tabs are used
let g:airline#extensions#tabline#enabled = 1
" display 'straight' tabs
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
" also count words in 'notes' files - list appending doesn't seem to work anymore
let g:airline#extensions#wordcount#filetypes =
    \ ['help', 'markdown', 'rst', 'org', 'text', 'asciidoc', 'tex', 'mail', 'notes']
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
" use this to denote indentation
let g:indentLine_char = '┆'
"}}}
"

" Add numbers to each line on the left-hand side."
set number
set relativenumber
" Do not let cursor scroll below or above N number of lines when scrolling.
set scrolloff=20
" Do not wrap lines. Allow long lines to extend as far as the line goes.
set nowrap

" Fix issue with DevIcons (remove brackets around icons in nerdtree)
if exists('g:loaded_webdevicons')
    call webdevicons#refresh()
endif
