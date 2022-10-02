"PLUGIN CONFIGURATIONS

"NERDTree
" define map for opening NERDTree
nnoremap <Leader>nn :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" vim-obsession "
" start tracking session
nnoremap <Leader>o :Obsess<CR>
" stop tracking session and delete session file
nnoremap <Leader>O :Obsess!<CR>

" startify "
" don't CD when opening file
let g:startify_change_to_dir=0

"Coc Snippets
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

"Tagbar
nmap <script> <silent> <unique> <F4> :TagbarToggle<CR>


"Choose Windows
nmap - <Plug>(choosewin)
let g:choosewin_overlay_enable = 1

"FZF
set rtp+=~/.fzf/bin/fzf
nnoremap <C-p> :Files<Cr>
