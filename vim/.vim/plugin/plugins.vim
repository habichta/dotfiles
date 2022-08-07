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

try
    nmap <silent> [c :call CocAction('diagnosticNext')<cr>
    nmap <silent> ]c :call CocAction('diagnosticPrevious')<cr>
endtry

"Tagbar
nmap <script> <silent> <unique> <F4> :TagbarToggle<CR>


"Choose Windows
nmap - <Plug>(choosewin)
let g:choosewin_overlay_enable = 1
