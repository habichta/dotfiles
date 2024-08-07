-- Copilot use <C-Space> to trigger completion
vim.keymap.set('i', '<M-b>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.keymap.set('i', '<M-c>', 'copilot#AcceptWord("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.keymap.set('i', '<M-v>', 'copilot#AcceptLine("\\<CR>")', {
  expr = true,
  replace_keycodes = false
})
vim.keymap.set('i', '<M-n>', 'copilot#Next()', {
  expr = true,
  replace_keycodes = false
})
vim.keymap.set('i', '<M-m>', 'copilot#Previous()', {
  expr = true,
  replace_keycodes = false
})
vim.keymap.set('i', '<M-x>', 'copilot#Suggest()', {
  expr = true,
  replace_keycodes = false
})

vim.g.copilot_no_tab_map = true
