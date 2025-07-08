"PLUGIN CONFIGURATIONS
" vim-obsession "
" start tracking session
nnoremap <Leader>0 :Obsess<CR>
" stop tracking session and delete session file
nnoremap <Leader>9 :Obsess!<CR>

" startify "
" don't CD when opening file
let g:startify_change_to_dir=0

"FZF
set rtp+=~/.fzf/bin/fzf
nnoremap <Leader>p :GFiles<Cr>
nnoremap <Leader>P :GFiles?<Cr>
nnoremap <Leader>[ :History<Cr>
nnoremap <Leader>\ :Buffers<Cr>
nnoremap <Leader>] :Tags<Cr>
nnoremap <Leader>o :Ag<Cr>

command! BuffersDelete call fzf#run(fzf#wrap({
  \ 'source': functions#ListBuffers(),
  \ 'sink*': { lines -> functions#DeleteBuffers(lines) },
  \ 'options': '--multi --reverse --bind ctrl-a:select-all+accept' 
  \ }))


let g:camelcasemotion_key = '<leader>'
" Remap standard motions to CamelCaseMotion equivalents
nmap w <Plug>CamelCaseMotion_w
nmap b <Plug>CamelCaseMotion_b
nmap e <Plug>CamelCaseMotion_e
xmap w <Plug>CamelCaseMotion_w
xmap b <Plug>CamelCaseMotion_b
xmap e <Plug>CamelCaseMotion_e
omap w <Plug>CamelCaseMotion_w
omap b <Plug>CamelCaseMotion_b
omap e <Plug>CamelCaseMotion_e

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

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }
let g:fzf_preview_window = ['right:50%', 'ctrl-_']
" command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, $AG_DEFAULT_OPTIONS . '--hidden --ignore "*.ipynb" --ignore-dir deps --ignore-dir node_modules --ignore-dir .git --ignore-dir .worktrees --ignore-dir target', fzf#vim#with_preview(), <bang>0)


" vim-test
" <Plug> vim-test {{{
" setup mappings
nnoremap <silent> <localleader>tn :TestNearest<CR>
nnoremap <silent> <localleader>tf :TestFile<CR>
nnoremap <silent> <localleader>tt :TestSuite<CR>
nnoremap <silent> <localleader>tl :TestLast<CR>
"}}}:
"
"
" VISTA
"
"" How each level is indented and what to prepend.
" This could make the display more compact or more spacious.
" e.g., more compact: ["▸ ", ""]
" Note: this option only works for the kind renderer, not the tree renderer.
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]

" Executive used when opening vista sidebar without specifying it.
" See all the avaliable executives via `:echo g:vista#executives`.
let g:vista_default_executive = 'coc'

" To enable fzf's preview window set g:vista_fzf_preview.
" The elements of g:vista_fzf_preview will be passed as arguments to fzf#vim#with_preview()
" For example:
let g:vista_fzf_preview = ['down:30%']

" Open Vista finder with ,mf
nnoremap <leader>mf :Vista finder<CR>

" Toggle Vista with ,mm
nnoremap <leader>mm :Vista!!<CR>

" coc-fzf
let g:coc_fzf_preview = 'up:90%'

