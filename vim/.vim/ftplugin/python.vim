"" Format Python with Black via CoC
command! Black :call CocAction('format')
command! Isort :call CocAction('runCommand', 'python.sortImports')

" Or create a combined command
command! Format :call CocAction('format') | :call CocAction('runCommand', 'python.sortImports')

" configure the test runner
let test#python#runner = 'pytest'
let test#python#pytest#options = '--ignore=deps --exitfirst --failed-first --new-first --capture=no -v'
let test#python#pytest#file_pattern = '\v(test_[^/]+|[^/]+_tests)\.py$'
function! DockerTransform(cmd) abort
  return ' docker-compose -f docker-compose.test.yml run --rm tests ' . a:cmd
endfunction

function! HelpanyDockerTransform(cmd) abort
  let parent_path = expand('~/repos/helpany/')" Path to Helpany parent directory
  let cwd = getcwd()

  if cwd =~ '^' . parent_path
  " Remove 'uv run' if present
    let cmd = substitute(a:cmd, '^uv run\s*', '', '')
    return 'docker-compose -f docker-compose.test.yml run --rm tests ' . cmd
  else
    return a:cmd
  endif
endfunction

let g:test#custom_transformations = {'docker': function('HelpanyDockerTransform')}
let g:test#transformation = 'docker'

nnoremap <silent> <localleader>p oimport pdb; pdb.set_trace()<Esc>
