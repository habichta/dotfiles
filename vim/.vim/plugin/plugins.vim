"PLUGIN CONFIGURATIONS
" vim-obsession "
" start tracking session
nnoremap <Leader>0 :Obsess<CR>
" stop tracking session and delete session file
nnoremap <Leader>9 :Obsess!<CR>

" startify "
" don't CD when opening file
let g:startify_change_to_dir=0
let g:startify_files_number = 8
let g:startify_relative_path = 1
let g:startify_fortune_length = 0

" Jump targets, reachable by their letter instead of an index
let g:startify_bookmarks = [
      \ {'v': '~/.dotfiles/vim/.vimrc'},
      \ {'i': '~/.dotfiles/configs/.config/nvim/init.vim'},
      \ {'l': '~/.dotfiles/configs/.config/nvim/lua/init.lua'},
      \ {'p': '~/.dotfiles/vim/.vim/plugin/plugins.vim'},
      \ {'d': '~/.dotfiles'},
      \ ]

" A plain-text TODO list rendered on the start screen.  Each entry opens the
" file on its own line, so editing it is just <index><edit><:w>.
let g:startify_todo_file = expand('~/.dotfiles/TODO.md')

function! StartifyTodo() abort
  if !filereadable(g:startify_todo_file)
    return [{'line': '(no TODO file yet - open to create)', 'cmd': 'edit',
          \  'path': g:startify_todo_file, 'type': 'file'}]
  endif
  let entries = []
  let lnum = 0
  for raw in readfile(g:startify_todo_file)
    let lnum += 1
    let text = trim(raw)
    " skip blanks, markdown headings, and anything already ticked off
    if empty(text) || text =~# '^#' || text =~? '^[-*]\=\s*\[x\]'
      continue
    endif
    let text = substitute(text, '^[-*]\s*\(\[ \]\s*\)\=', '', '')
    call add(entries, {'line': text, 'cmd': 'edit +'.lnum,
          \            'path': g:startify_todo_file, 'type': 'file'})
    if len(entries) >= 8
      break
    endif
  endfor
  return entries
endfunction

" Order: what I was just doing here, then everywhere, then TODO, then jumps.
let g:startify_lists = [
      \ { 'header': ['   MRU '. getcwd()], 'type': 'dir' },
      \ { 'header': ['   MRU'],            'type': 'files' },
      \ { 'header': ['   TODO'],           'type': function('StartifyTodo') },
      \ { 'header': ['   Bookmarks'],      'type': 'bookmarks' },
      \ { 'header': ['   Sessions'],       'type': 'sessions' },
      \ ]

" Open the TODO list for editing from anywhere
command! Todo execute 'edit' g:startify_todo_file
nnoremap <Leader>T :Todo<CR>

"FZF
set rtp+=~/.fzf/bin/fzf
nnoremap <Leader>p :GFiles<Cr>
nnoremap <Leader>P :GFiles?<Cr>
nnoremap <Leader>} :Files<Cr>
nnoremap <Leader>[ :History<Cr>
nnoremap <Leader>\ :Buffers<Cr>
nnoremap <Leader>] :Tags<Cr>

autocmd FileType fzf tnoremap <buffer> <C-j> <Down>
autocmd FileType fzf tnoremap <buffer> <C-k> <Up>
autocmd FileType fzf tnoremap <buffer> <C-d> <PageDown>
autocmd FileType fzf tnoremap <buffer> <C-u> <PageUp>

augroup no_ipynb
  autocmd!
  autocmd BufReadCmd *.ipynb echom "Refusing to open .ipynb files. Use Jupyter." | bdelete
augroup END

nnoremap <silent> <Leader>o :call fzf#vim#grep(
      \ 'rg --column --line-number --hidden --no-heading --color=always --smart-case -F --glob "!**/.git/**" -- ""',
      \ fzf#vim#with_preview({'options': ['--query', '!deps !tests '], 'dir': systemlist('git rev-parse --show-toplevel')[0]}))<Enter>

nnoremap <silent> <Leader>O :call fzf#vim#grep(
      \ 'rg --column --line-number --hidden --no-heading --color=always --smart-case -F --glob "!**/.git/**" -- ' . expand('<cword>'),
      \ fzf#vim#with_preview({'options': ['--query', '!deps !tests '], 'dir': systemlist('git rev-parse --show-toplevel')[0]}))<Enter>

vnoremap <silent> <Leader>O :<C-u>call fzf#vim#grep(
      \ 'rg --column --line-number --hidden --color=always --smart-case -F --glob "!**/.git/**" -- ' . shellescape(functions#GetVisualSelection()),
      \ fzf#vim#with_preview({'options': ['--query', '!deps !tests '], 'dir': systemlist('git rev-parse --show-toplevel')[0]}))<Enter>


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

let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.8 } }
let g:fzf_preview_window = ['right:50%', 'ctrl-_']
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
" SYMBOL OUTLINE (coc, replaces vista.vim)
"
" Fuzzy-search symbols in the current file with ,mf
nnoremap <leader>mf :CocList outline<CR>

" Toggle the outline sidebar with ,mm
nnoremap <leader>mm :CocOutline<CR>

" coc-fzf
let g:coc_fzf_preview = 'up:90%'

