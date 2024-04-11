-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- folding options
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

-- swap file options
vim.opt.directory = '/tmp/nvim/swap//'

--Required
require("bufferline").setup{}
require('functions.swap-files')
require('plugins.coc')
require('plugins.ident-blankline')
require('plugins.lualine')
require('plugins.nvim-tree')
require('plugins.treesitter')
