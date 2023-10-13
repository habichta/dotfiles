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
nnoremap <C-p> :Files<Cr>
nnoremap <C-]> :History<Cr>

"DAP
nnoremap <silent> <F5> <Cmd>lua require'dap'.continue()<CR>
nnoremap <silent> <F6> <Cmd>lua require'dap'.step_over()<CR>
nnoremap <silent> <F7> <Cmd>lua require'dap'.step_into()<CR>
nnoremap <silent> <F8> <Cmd>lua require'dap'.step_out()<CR>
nnoremap <silent> <Leader>b <Cmd>lua require'dap'.toggle_breakpoint()<CR>
nnoremap <silent> <Leader>B <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
nnoremap <silent> <Leader>lp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
nnoremap <silent> <Leader>dr <Cmd>lua require'dap'.repl.open()<CR>
nnoremap <silent> <Leader>dl <Cmd>lua require'dap'.run_last()<CR>
vnoremap <M-k> <Cmd>lua require("dapui").eval()<CR>
