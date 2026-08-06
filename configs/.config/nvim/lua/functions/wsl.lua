-- Clipboard on WSL2.
--
-- Copy goes through OSC 52: an escape sequence written to the terminal, so it
-- spawns no process at all. win32yank costs ~36ms per call because each one
-- starts a Windows process, and that is what stalls under load. tmux 3.4 here
-- has set-clipboard=external, so it forwards the sequence to Windows Terminal.
--
-- Paste stays on win32yank. OSC 52 *reads* are refused by most terminals
-- (Windows Terminal included) as an exfiltration guard, so a query would just
-- hang. Pasting is rarer than yanking, so the ~38ms lands in the quieter path.
--
-- Two things measured and rejected: relocating win32yank.exe to ext4 (132ms vs
-- 38ms -- Windows reloads it back over the 9p share), and xclip against WSLg
-- (fast at 4ms, but one propagation test in three never reached the Windows
-- clipboard at all).
if vim.fn.has("wsl") == 1 then
  local osc52 = require('vim.ui.clipboard.osc52')
  local win32yank = '/mnt/c/Windows/System32/win32yank.exe'

  vim.g.clipboard = {
    name = 'osc52-copy/win32yank-paste',
    copy = {
      ['+'] = osc52.copy('+'),
      ['*'] = osc52.copy('*'),
    },
    paste = {
      ['+'] = { win32yank, '-o', '--lf' },
      ['*'] = { win32yank, '-o', '--lf' },
    },
    -- Was 0, which re-ran the 38ms paste command on every access of the
    -- register. 1 lets nvim serve back what it just copied without shelling
    -- out; the tradeoff is that a copy made *outside* nvim may not be seen
    -- until the register is invalidated.
    cache_enabled = 1,
  }
end
