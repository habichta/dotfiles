-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- folding options
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.wo.foldlevel = 99

-- swap file options
vim.opt.directory = '/tmp/nvim/swap//'

-- File format
vim.opt.fileformats = { "unix" }

vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    pcall(vim.treesitter.start)
  end,
})

--Required
require('functions.carriage-return')
require('functions.global-replace')
require('functions.python')
require('functions.swap-files')
require('functions.neovim')
require('functions.wsl')
require('functions.usage-stats')
require('functions.indent-guides')
require('plugins.gruvbox-material')
require('plugins.copilot')
require('plugins.rust')
require('plugins.coc')
require('plugins.nvim-tree')
require('plugins.lualine')
-- require('plugins.treesitter')
require('plugins.gitsigns')
require('plugins.colorizer')
require('plugins.claude-code')
require('plugins.codecompanion')
-- require('plugins.avante')
