-- Set Clipboard to use WSL clipboard for performance. Important, may not work for non wsl users
if vim.fn.has("wsl") == 1 then
  vim.g.clipboard = {
    name = 'wsl_clipboard',
    copy = {
      ["+"] = 'clip.exe', -- For the system clipboard
      ["*"] = 'clip.exe', -- For the selection clipboard
    },
    paste = {
      -- Note: `win32yank.exe` is required for clipboard support and must be out in Windows PATH, e.g. Windows/System32
      ["+"] = 'win32yank.exe -o | sed "s/\r//g"', -- Remove carriage returns (^M) when pasting
      ["*"] = 'win32yank.exe -o | sed "s/\r//g"',
    },
    cache_enabled = true,
  }
end
