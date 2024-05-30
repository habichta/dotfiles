
"""""""""""""
" Functions "
"""""""""""""

" highlight the current search match by blinking for `blinktime` seconds
function! functions#HighlightNext(blinktime)
  let [bufnum, lnum, col, off] = getpos('.')
  let matchlen = strlen(matchstr(strpart(getline('.'),col-1),@/))
  let target_pat = '\c\%#\%('.@/.'\)'
  let ring = matchadd('ErrorMsg', target_pat, 101)
  redraw
  exec 'sleep ' . float2nr(a:blinktime * 1000) . 'm'
  call matchdelete(ring)
  redraw
endfunction

" renames the current file
function! functions#RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction

" move the cursor to the line it was on and center file
function! functions#SetLastCursorPosition()
  if &filetype !~ 'svn\|commit\c'
    if line("'\"") > 0 && line("'\"") <= line("$")
      exec "normal! g`\""
      normal! zz
    endif
  endif
endfunction

function! functions#IsQuickfixOpen()
  for win in range(1, winnr('$'))
    if getwinvar(win, '&buftype') == 'quickfix'
      return 1
    endif
  endfor
  return 0
endfunction

function! functions#DeleteBufferOrExit()
  " Close the quickfix window if it's open
  if functions#IsQuickfixOpen()
    cclose
  else
    " Check if the current buffer is empty
    if line('$') == 1 && getline(1) == ''
      " Exit Vim
      quit
    else
      " Close the location list if it's open
      lclose
      " Close the current buffer safely
      try
        Bdelete
      catch
        " Handle errors silently, e.g., if there are no more buffers to delete
      endtry
    endif
  endif
endfunction


function! functions#MaximizeToggle()
  if exists("s:maximize_session")
    exec "source " . s:maximize_session
    call delete(s:maximize_session)
    unlet s:maximize_session
    let &hidden=s:maximize_hidden_save
    unlet s:maximize_hidden_save
  else
    let s:maximize_hidden_save = &hidden
    let s:maximize_session = tempname()
    set hidden
    exec "mksession! " . s:maximize_session
    only
  endif
endfunction


function! functions#InsertPDB()
  let trace = expand("import pdb; pdb.set_trace()")
  execute "normal o".trace
endfunction

function! functions#InsertPUDB()
  let trace = expand("import pudb; pudb.set_trace()")
  execute "normal o".trace
endfunction

function! functions#TrimWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfunction

" The Silver Searcher
if executable('ag')
  " Use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

function! functions#ToggleMouse()
    " check if mouse is enabled
    if &mouse == 'a'
        " disable mouse
        set mouse=
    else
        " enable mouse everywhere
        set mouse=a
    endif
endfunc"


