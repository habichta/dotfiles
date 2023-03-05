"""""""""""""""""""""""""
" More general mappings "
"""""""""""""""""""""""""
"Focus on Window, Keep structure
nnoremap <C-W>O :call functions#MaximizeToggle()<CR>
nnoremap <C-W>o :call functions#MaximizeToggle()<CR>
nnoremap <C-W><C-O> :call functions#MaximizeToggle()<CR>

" Bulk Changes over multiple files with RipGrep
nnoremap <Leader>P :Rg

" Saving, closing, ... "{{{
" use common Ctrl-shortcuts
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>

nnoremap <C-c> :q<CR>

nnoremap <C-q> :qa<CR>

" Backspace deletes buffer.
nnoremap <silent> <BS> :call functions#DeleteBufferOrExit()<CR>:bd<CR>

noremap <silent> <F5> :e<CR>

" Navigation "{{{
" easier window navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" easier map to open the alternate file
nnoremap <Leader><Tab> <C-^>

" use <C-\> to return after tag jump with <C-]>
" (<C-[> is something with alt/esc...)
nnoremap <C-\> :pop<CR>

" make <C-e>/<C-y> scroll faster
nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>
"}}}

" Visual mode "{{{
" visual mode: < and > indent block and re-select previous indentation too
vnoremap < <gv
vnoremap > >gv

" select just-pasted text
noremap gV `[v`]

" duplicate visual mode selection
vnoremap D y'>p

" Press Shift+P while in visual mode to replace the selection without
" overwriting the default register
vnoremap P p:call setreg('+', getreg('0'))<CR>
"}}}

" Editing "{{{

" Bubble single lines
nnoremap <silent> <C-Up>   :move-2<CR>==
nnoremap <silent> <C-Down> :move+<CR>==
" Bubble multiple lines
xnoremap <silent> <C-Up>   :move-2<CR>gv=gv
xnoremap <silent> <C-Down> :move'>+<CR>gv=gv

" rewire n and N to highlight the current match
nnoremap <silent> n nzv:call functions#HighlightNext(0.2)<CR>
nnoremap <silent> N Nzv:call functions#HighlightNext(0.2)<CR>

" use F7 for pasting
set pastetoggle=<F7>

" use F6 for mouse mode
nnoremap <F6> :call functions#ToggleMouse()<CR>

" go automatically to the end of the text after yanking/pasting
vnoremap <silent> y y`]
vmap <silent> p p`]
nmap <silent> p p`]
vmap <silent> P P`]
nmap <silent> P P`]

" show me when I use `gu` because that's mostly by accident
noremap gu gu:echoerr 'Did you just intend to lowercase?'<CR>

"Cycle through buffers
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>

"Autoclosing Parenthesis
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>

"Deleting in insert mode
inoremap <C-d> <Esc>xi
inoremap <C-f> <Esc>lxi

"Moving in insert mode
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-k> <Up>
inoremap <C-j> <Down>

inoremap <A-h> <C-Left>
inoremap <A-l> <C-Right>
inoremap <A-k> <C-Up>
inoremap <A-j> <C-Down>
