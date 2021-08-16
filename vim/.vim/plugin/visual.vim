
""""""""""""""""""""""""
" Visual configuration "
""""""""""""""""""""""""
" Contains configuration for:
" - colorscheme
" - vim-airline
" - general visual stuff

" Colorscheme "{{{
" set up and load colorscheme
let g:gruvbox_contrast_dark='medium'
let g:gruvbox_invert_selection='0'
let g:gruvbox_number_column='bg1'
let g:gruvbox_improved_warnings='1'
set background=dark
colorscheme gruvbox
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
