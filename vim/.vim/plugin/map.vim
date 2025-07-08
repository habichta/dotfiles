"""""""""""""""""""""""""
" More general mappings "
"""""""""""""""""""""""""
"Focus on Window, Keep structure
nnoremap <C-W>o :call functions#MaximizeToggle()<CR>

" Saving, closing, ... "{{{
" use common Ctrl-shortcuts
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>

" Backspace deletes buffer.
nnoremap <silent> <BS> :call functions#DeleteBufferOrExit()<CR>

noremap <silent> <F5> :e<CR>

" Navigation "{{{
" easier window navigation
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" easier window navigation in terminal mode
tnoremap <C-w> <C-\><C-n><C-w>
tnoremap <C-h> <C-\><C-n><C-w>h
tnoremap <C-j> <C-\><C-n><C-w>j
tnoremap <C-k> <C-\><C-n><C-w>k
tnoremap <C-l> <C-\><C-n><C-w>l

" easier map to open the alternate file
nnoremap <Leader><Tab> <C-^>

" Visual mode "{{{
" visual mode: < and > indent block and re-select previous indentation too
vnoremap < <gv
vnoremap > >gv

" select just-pasted text
noremap gV `[v`]

" Bracket Mappings, go to the matching bracket
nnoremap gbo :call search('[{([]', 'c')<CR>a<CR><Esc>O
nnoremap g(o :call search('[(]', 'c')<CR>a<CR><Esc>O
nnoremap g[o :call search('[[]', 'c')<CR>a<CR><Esc>O
nnoremap g{o :call search('[{]', 'c')<CR>a<CR><Esc>O

nnoremap gbi :call search('[{([]', 'c')<CR>a
nnoremap g(i :call search('[(]', 'c')<CR>a
nnoremap g[i :call search('[[]', 'c')<CR>a
nnoremap g{i :call search('[{]', 'c')<CR>a

nnoremap gbv :call search('[{([])}]', 'c')<CR>vib
nnoremap g(v :call search('[()]', 'c')<CR>vi(
nnoremap g[v :call search('[[]]', 'c')<CR>vi[
nnoremap g{v :call search('[{}]', 'c')<CR>vi{

" Press Shift+P while in visual mode to replace the selection without
" overwriting the default register
vnoremap P p:call setreg('+', getreg('0'))<CR>
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
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

" use F6 for mouse mode
nnoremap <F6> :call functions#ToggleMouse()<CR>

" go automatically to the end of the text after yanking/pasting
vnoremap <silent> y y`]
vmap <silent> p p`]
nmap <silent> p p`]
vmap <silent> P P`]
nmap <silent> P P`]

"Cycle through buffers
nnoremap ]b :bnext<CR>
nnoremap [b :bprevious<CR>

"Tabs
nnoremap <leader>T :tabnew<CR>
nnoremap ]t :tabnext<CR>
nnoremap [t :tabprevious<CR>
nnoremap <F8> :tabclose<CR>

"Deleting in insert mode
inoremap <C-d> <Esc>xi
inoremap <C-f> <Esc>lxi

"Moving in insert mode
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <C-k> <Up>
inoremap <C-j> <Down>
