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
" a little more breathing room on the left than the default 3
let g:startify_padding_left = 4
" drop the [e] <empty buffer> / [q] <quit> rows; the keys still work, and the
" footer advertises them
let g:startify_enable_special = 0

" Jump targets, reachable by their letter instead of an index
let g:startify_bookmarks = [
      \ {'v': '~/.dotfiles/vim/.vimrc'},
      \ {'i': '~/.dotfiles/configs/.config/nvim/init.vim'},
      \ {'l': '~/.dotfiles/configs/.config/nvim/lua/init.lua'},
      \ {'p': '~/.dotfiles/vim/.vim/plugin/plugins.vim'},
      \ {'z': '~/.dotfiles/zsh/.zshrc'},
      \ {'d': '~/.dotfiles'},
      \ ]

" Left-aligned ASCII title with the running version after it.  startify#pad
" indents by g:startify_padding_left, so it lines up with the section headers
" below; the trailing empties are breathing room (startify adds one of its own).
function! StartifyTitle() abort
  " \S matches newlines in Vim regex (only space/tab are \s), hence [^ \n]
  let ver = matchstr(execute('version'), 'NVIM v\zs[^ \n]\+')
  return startify#pad([
        \ ' _   _  _         _           _    _                   _ ',
        \ '| | | |(_)       / \    _ __ | |_ | |__   _   _  _ __ | |',
        \ '| |_| || |      / _ \  | ''__|| __|| ''_ \ | | | || ''__|| |',
        \ '|  _  || |     / ___ \ | |   | |_ | | | || |_| || |   |_|',
        \ '|_| |_||_|    /_/   \_\|_|    \__||_| |_| \__,_||_|   (_)  v'. ver,
        \ '',
        \ '',
        \ ])
endfunction
let g:startify_custom_header = 'StartifyTitle()'

" Set as a string so startify re-evaluates it on every redraw.  Padded, not
" centred, to sit flush with the title and the section headers.
function! StartifyFooter() abort
  return startify#pad([
        \ 'e empty   q quit',
        \ ])
endfunction
let g:startify_custom_footer = 'StartifyFooter()'

" Plain-text lists rendered on the start screen.  Each entry opens its file on
" its own line, so editing is just <index><edit><:w>.
let g:startify_todo_file      = expand('~/.dotfiles/TODO.md')
let g:startify_reminders_file = expand('~/.dotfiles/REMINDERS.md')
" hide reminders further out than this many days; set to -1 to show them all
let g:startify_reminders_horizon = 30

" Every unticked line of a markdown checklist, as startify entries.
function! s:Checklist(file) abort
  if !filereadable(a:file)
    return [{'line': '('. fnamemodify(a:file, ':t') .' does not exist yet - open to create)',
          \  'cmd': 'edit', 'path': a:file, 'type': 'file'}]
  endif
  let entries = []
  let lnum = 0
  for raw in readfile(a:file)
    let lnum += 1
    let text = trim(raw)
    " only bullets count, so prose and headings in the file are free; skip
    " anything already ticked off
    if text !~# '^[-*]\s' || text =~? '^[-*]\s*\[x\]'
      continue
    endif
    let text = substitute(text, '^[-*]\s*\(\[ \]\s*\)\=', '', '')
    call add(entries, {'line': text, 'cmd': 'edit +'.lnum,
          \            'path': a:file, 'type': 'file'})
  endfor
  return entries
endfunction

function! StartifyTodo() abort
  return s:Checklist(g:startify_todo_file)[:7]
endfunction

" Days since the epoch for an ISO date (Hinnant's days_from_civil), so due
" dates can be compared without depending on strptime().
function! s:DayNumber(iso) abort
  let [y, m, d] = map(split(a:iso, '-'), 'str2nr(v:val)')
  let y -= m <= 2
  let era = (y >= 0 ? y : y - 399) / 400
  let yoe = y - era * 400
  let doy = (153 * (m + (m > 2 ? -3 : 9)) + 2) / 5 + d - 1
  let doe = yoe * 365 + yoe / 4 - yoe / 100 + doy
  return era * 146097 + doe - 719468
endfunction

" Reminders are TODO lines carrying an optional leading ISO date:
"   - [ ] 2026-08-01 Renew the passport
" Dated ones sort by urgency and get an overdue/today/Nd tag; undated ones
" trail behind as a plain someday list.
function! StartifyReminders() abort
  let today = s:DayNumber(strftime('%Y-%m-%d'))
  let dated = []
  let undated = []
  for entry in s:Checklist(g:startify_reminders_file)
    let parts = matchlist(entry.line, '^\(\d\{4}-\d\d-\d\d\)\s\+\(.*\)$')
    if empty(parts)
      let entry.line = printf('%-8s %s', '', entry.line)
      call add(undated, entry)
      continue
    endif
    let days = s:DayNumber(parts[1]) - today
    if g:startify_reminders_horizon >= 0 && days > g:startify_reminders_horizon
      continue
    endif
    let tag = days < 0 ? 'overdue' : (days == 0 ? 'today' : days .'d')
    let entry.line = printf('%-8s %s', tag, parts[2])
    call add(dated, {'days': days, 'entry': entry})
  endfor
  call sort(dated, {a, b -> a.days - b.days})
  return map(dated, 'v:val.entry') + undated[:7 - len(dated)]
endfunction

" Recently used files - this directory first, then everywhere - then the fixed
" jump targets.  The reminders, todo and sessions sections are one line each
" away from coming back; see the functions above.
let s:pad = repeat(' ', g:startify_padding_left)
let g:startify_lists = [
      \ { 'header': [s:pad .'▸ here  '. fnamemodify(getcwd(), ':~')],
      \   'type': 'dir' },
      \ { 'header': [s:pad .'▸ recent'],    'type': 'files' },
      \ { 'header': [s:pad .'▸ bookmarks'], 'type': 'bookmarks' },
      \ ]

" Open either list for editing from anywhere
command! Todo execute 'edit' g:startify_todo_file
command! Reminders execute 'edit' g:startify_reminders_file

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

