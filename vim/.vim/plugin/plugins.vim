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
nnoremap <C-x> :Buffers<Cr>
nnoremap <M-[> :Ag<Cr>

"
let g:camelcasemotion_key = '<leader>'

" wilder
" Use wilder for command-line completion
call wilder#setup({'modes': [':', '/', '?']})
call wilder#set_option('renderer', wilder#popupmenu_renderer(wilder#popupmenu_border_theme({
      \ 'highlights': {
      \   'border': 'Normal',
      \ },
      \ 'border': 'rounded',
      \ 'pumblend': 20,
      \ 'left': [
      \   ' ', wilder#popupmenu_devicons(),
      \ ],
      \ 'right': [
      \   ' ', wilder#popupmenu_scrollbar(),
      \ ],
      \ 'max_width': '80%',
      \ 'max_height': '15%',
      \ })))


let g:fzf_preview_window = ['right:50%', 'ctrl-_']
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, $AG_DEFAULT_OPTIONS . ' --ignore "*.ipynb" --ignore-dir deps', fzf#vim#with_preview(), <bang>0)


" vim-test
" <Plug> vim-test {{{
" setup mappings
nnoremap <silent> <localleader>tn :TestNearest<CR>
nnoremap <silent> <localleader>tf :TestFile<CR>
nnoremap <silent> <localleader>tt :TestSuite<CR>
nnoremap <silent> <localleader>tl :TestLast<CR>
"}}}:
