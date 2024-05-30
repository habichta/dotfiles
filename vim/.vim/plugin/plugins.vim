"PLUGIN CONFIGURATIONS
" vim-obsession "
" start tracking session
nnoremap <Leader>o :Obsess<CR>
" stop tracking session and delete session file
nnoremap <Leader>O :Obsess!<CR>

" startify "
" don't CD when opening file
let g:startify_change_to_dir=0

"FZF
set rtp+=~/.fzf/bin/fzf
nnoremap <C-p> :GFiles<Cr>
nnoremap <M-]> :History<Cr>
nnoremap <Leader>b :Buffers<Cr>
nnoremap <M-[> :Ag<Cr>

"
let g:camelcasemotion_key = '<leader>'
