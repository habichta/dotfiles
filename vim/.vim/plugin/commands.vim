"Close Buffer but keep Split
command Bd bp\|bd \#

"VimDiff Alias
command! -complete=file -nargs=1 Vd vert diffsplit <args>

" Clos Buffers with FZF
command! DeleteBuffers call fzf#run(fzf#wrap({
            \ 'source': functions#ListBuffers(),
            \ 'sink*': function('functions#DeleteBuffers'),
            \ 'options': '--ansi --multi --prompt="Select buffers to delete> " --preview "batcat --style=numbers --color=always --line-range :500 {3}"',
            \ 'window': {
                \ 'width': 0.9,
                \ 'height': 0.6,
                \ 'border': 'sharp',
            \ }
            \ }))



" Command to reload the configuration
command! ReloadConfig call functions#ReloadConfig()
