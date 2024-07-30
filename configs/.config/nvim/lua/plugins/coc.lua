local coc_extensions = {
  "coc-actions",
  "coc-css",
  "coc-eslint",
  "coc-html",
  "coc-prettier",
  "coc-rust-analyzer",
  "coc-tsserver",
  "coc-clangd",
  "coc-docker",
  "coc-go",
  "coc-json",
  "coc-pyright",
  "coc-snippets",
  "coc-yaml",
  "coc-lua"
}

local function InstallCocExtensions()
  local extensions_str = table.concat(coc_extensions, ' ')
  vim.cmd('CocInstall ' .. extensions_str)
end

-- Create new command 'CocSetup'
vim.api.nvim_create_user_command('CocSetup', InstallCocExtensions, {
  desc = "Install predefined CoC extensions"
})

-- Create new command 'Prettier'
vim.api.nvim_create_user_command(
  'Prettier',
  function()
    vim.cmd('CocCommand prettier.forceFormatDocument')
  end,
  { desc = "Format document using CoC Prettier" }
)

function CocListGlobalErrors()
  vim.cmd('CocList diagnostics --error')
end

vim.api.nvim_set_keymap('n', '<leader>gg', ':lua CocListGlobalErrors()<CR>', { noremap = true, silent = true })
vim.api.nvim_create_user_command('CocListGlobalErrors', CocListGlobalErrors,
  { desc = "List global errors using CoC" })

function CocListBufferErrors()
  vim.cmd('CocDiagnostics --level error')
end

vim.api.nvim_set_keymap('n', '<leader>gb', ':lua CocListBufferErrors()<CR>', { noremap = true, silent = true })
vim.api.nvim_create_user_command('CocListBufferErrors', CocListBufferErrors,
  { desc = "List buffer errors using CoC" })
