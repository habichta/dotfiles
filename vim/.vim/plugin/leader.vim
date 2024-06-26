"LEADER MAPPINGS
"
"
"" save (and/or) close
nnoremap <Leader>qq :qa<CR>
nnoremap <Leader>x :x<CR>

" edit another file in the same directory as the current file
nnoremap <Leader>e :e <C-R>=escape(expand("%:p:h"),' ') . '/'<CR>
nnoremap <Leader>sh :split <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>
nnoremap <Leader>sv :vnew <C-R>=escape(expand("%:p:h"), ' ') . '/'<CR>

" open alternate file in split
nnoremap <Leader>shl :split #<CR>
nnoremap <Leader>svl :vnew #<CR>

" yank entire file
nnoremap <Leader>y ggVGy
" unhighlight search results
nnoremap <silent> <Leader>q :nohlsearch<CR>

" zoom/unzoom current window
nnoremap <Leader>z <C-w>\|<C-w>_
nnoremap <Leader>Z <C-w>=

" delete paranthesis under cursor and matching
nnoremap <Leader>X %x<C-o>x

" rename file (prompts for new filename)
nnoremap <Leader>rn :call functions#RenameFile()<CR>

"Remove Trailing Whitespace
nnoremap <Leader>tw :call functions#TrimWhitespace()<CR>

"Close Window if it is not the last
nnoremap <Leader>qw :close<CR>

"Show unsaved changes
nnoremap <Leader>us :w !diff % -<CR>

