"PLUGIN CONFIGURATIONS

"NvimTree
" define map for opening NvimTree
nnoremap <Leader>nn :NvimTreeToggle<CR>
" vim-obsession "
" start tracking session
nnoremap <Leader>o :Obsess<CR>
" stop tracking session and delete session file
nnoremap <Leader>O :Obsess!<CR>

" startify "
" don't CD when opening file
let g:startify_change_to_dir=0


"Tagbar
nmap <script> <silent> <unique> <F4> :TagbarToggle<CR>


"Choose Windows
nmap - <Plug>(choosewin)
let g:choosewin_overlay_enable = 1

"FZF
set rtp+=~/.fzf/bin/fzf
nnoremap <C-p> :GFiles<Cr>
nnoremap <M-]> :History<Cr>
nnoremap <Leader>b :Buffers<Cr>
nnoremap <M-[> :Ag<Cr>

"
let g:camelcasemotion_key = '<leader>'
