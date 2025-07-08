-- Set Clipboard to use WSL clipboard for performance. Important, may not work for non wsl users
if vim.fn.has("wsl") == 1 then
   vim.g.clipboard = {
     name = 'win32yank-wsl',
     copy = {
       ['+'] = '/mnt/c/Windows/System32/win32yank.exe -i --crlf',
       ['*'] = '/mnt/c/Windows/System32/win32yank.exe -i --crlf',
     },
     paste = {
       ['+'] = '/mnt/c/Windows/System32/win32yank.exe -o --lf',
       ['*'] = '/mnt/c/Windows/System32/win32yank.exe -o --lf',
     },
     cache_enabled = 0,
   }
 end
