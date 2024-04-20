-- Copilot use <C-Space> to trigger completion
vim.keymap.set('i', '<M-c>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.g.copilot_no_tab_map = true
