"let g:black_linelength = 120
"let g:black_virtualenv = '~/.config/nvim/venv'
"autocmd BufWritePre *.py execute ':Black'
autocmd BufWritePre *.py execute ':Isort'

" configure the test runner 
let test#python#runner = 'pytest'
let test#python#pytest#options = '--ignore=deps --exitfirst --failed-first --new-first --capture=no -v'
let test#python#pytest#file_pattern = '\v(test_[^/]+|[^/]+_tests)\.py$'
function! DockerTransform(cmd) abort
  return ' docker-compose -f docker-compose.test.yml run --rm tests ' . a:cmd
endfunction

let g:test#custom_transformations = {'docker': function('DockerTransform')}
let g:test#transformation = 'docker'
