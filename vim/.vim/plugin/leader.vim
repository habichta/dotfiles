"LEADER MAPPINGS
"
"
"" save (and/or) close
nnoremap <Leader>Q :qa<CR>
nnoremap <Leader>x :x<CR>

" edit another file in the same directory as the current file
nnoremap <Leader>e :e <C-R>=escape(expand("%:p:h"),' ') . '/'<CR>

" open alternate ile in split
nnoremap <Leader>sh :split #<CR>
nnoremap <Leader>sv :vnew #<CR>

" unhighlight search results
nnoremap <silent> <Leader>q :nohlsearch<CR>

" zoom/unzoom current window
nnoremap <Leader>z <C-w>\|<C-w>_
nnoremap <Leader>Z <C-w>=

" rename file (prompts for new filename)
nnoremap <Leader>rn :call functions#RenameFile()<CR>

"Close Window if it is not the last
nnoremap <Leader>cw :close<CR>

"Close Buffer, keeping split
nnoremap <Leader>cb :Bdelete<CR>

"Undo to last saved state
nnoremap <Leader>u :e!<CR>

