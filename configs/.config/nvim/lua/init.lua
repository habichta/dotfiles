-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- folding options
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'
vim.wo.foldlevel = 99

-- swap file options
vim.opt.directory = '/tmp/nvim/swap//'

-- File format
vim.opt.fileformats = { "unix" }

--Required
require("bufferline").setup {}
require('functions.carriage-return')
require('functions.global-replace')
require('functions.python')
require('functions.swap-files')
require('plugins.aerial')
require('plugins.coc')
require('plugins.copilot')
require('plugins.ident-blankline')
require('plugins.lualine')
require('plugins.gruvbox-material')
require('plugins.nvim-tree')
require('plugins.treesitter')
require('plugins.gitsigns')
