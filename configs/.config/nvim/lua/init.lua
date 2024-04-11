-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

-- folding options
vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = 'nvim_treesitter#foldexpr()'

--Required
require('plugins.treesitter')
require('plugins.ident-blankline')
require('plugins.nvim-tree')
require('plugins.lualine')
require("bufferline").setup{}
require('plugins.coc')
