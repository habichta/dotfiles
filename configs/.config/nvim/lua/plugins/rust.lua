-- Uses coc-rust-analyzer to peek tests of function under cursor
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    vim.api.nvim_set_keymap('n', '<leader>t', ':CocCommand rust-analyzer.peekTests<CR>',
      { noremap = true, silent = true })
  end
})
