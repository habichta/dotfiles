
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


" delete the current buffer if it is not the last one, first checking if it is
" a quickfix or location list
function! functions#DeleteBufferOrExit()
    windo call functions#CheckWinType()

  if g:has_quickfix
      call functions#CloseAllQuickfixLists()
      return

  elseif g:has_location
      call functions#CloseAllLocLists()
      return

  else
      if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) > 1
        try
          Bdelete
        catch
          bd
        endtry
      endif
  endif

endfunction

function! functions#CheckWinType()
    let win_info = getwininfo(win_getid())[0]
    let g:has_quickfix = 0
    let g:has_location = 0
    if win_info['quickfix'] && !win_info['loclist']
        let g:has_quickfix = 1
    elseif win_info['loclist']
        let g:has_location = 1
    else
        return
    endif
endfunction

function! functions#CloseAllQuickfixLists()
    " Iterate over all windows 
    try
    windo execute "if &buftype == 'quickfix' | cclose | endif"
    catch
        echo "Quickfix List is last window"
    endtry
  
endfunction

function! functions#CloseAllLocLists()
    " Iterate over all windows / buftype is quickfix as well
    try
    windo execute "if &buftype == 'quickfix' | lclose | endif"
    catch
        echo "Location List is last window"
    endtry
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
endfunction

function! functions#ListBuffers()
  redir => list
  silent ls
  redir END
  return split(list, "\n")
endfunction

function! functions#DeleteBuffers(lines)
  execute 'bwipeout' join(map(a:lines, {_, line -> split(line)[0]}))
endfunction

