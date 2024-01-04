-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

--Required
require('plugins.treesitter')
require('plugins.dap')
require("plugins.ident-blankline")
require("plugins.nvim-tree")
require('plugins.lualine')
require('dap-python').setup('~/.dotfiles/venvs/debugpy/bin/python')
