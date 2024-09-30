-- Set Clipboard to use WSL clipboard for performance. Important, may not work for non wsl users
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = 'wsl_clipboard',
    copy = {
      ["+"] = 'clip.exe', -- For the system clipboard
      ["*"] = 'clip.exe', -- For the selection clipboard
    },
    paste = {
      ["+"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r",""))', -- For the system clipboard
      ["*"] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r",""))', -- For the selection clipboard
    },
    cache_enabled = true,
  }
end
