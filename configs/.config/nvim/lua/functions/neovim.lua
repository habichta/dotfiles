-- General Mappings
vim.api.nvim_set_keymap('n', ',gvv', ':vertical wincmd f<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ',gvh', ':wincmd f<CR>', { noremap = true, silent = true })


-- Function to move the rest of the line up
function MoveLineUp()
  local current_pos = vim.api.nvim_win_get_cursor(0)
  vim.cmd("normal! d$")
  vim.cmd("normal! k")
  vim.cmd("normal! o")
  vim.cmd("normal! P")
  vim.api.nvim_win_set_cursor(0, { current_pos[1] - 1, 0 })
end

vim.api.nvim_set_keymap('n', '<leader>J', ':lua MoveLineUp()<CR>', { noremap = true, silent = true })

-- Function to print the full file path
function ShowCurrentFilePath()
  print(vim.fn.expand("%:p"))
end

vim.api.nvim_create_user_command("ShowFilePath", ShowCurrentFilePath, {})
vim.keymap.set("n", "<leader>F", ShowCurrentFilePath, { noremap = true, silent = true })


function close_other_buffers(force)
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if bufnr ~= vim.api.nvim_get_current_buf() then
      local is_modified = vim.api.nvim_buf_get_option(bufnr, 'modified')
      if force or not is_modified then
        vim.api.nvim_buf_delete(bufnr, { force = true })
      end
    end
  end
end

-- Map the function to a key, with an optional force-close option
vim.api.nvim_set_keymap('n', '<leader>co', ':lua close_other_buffers(false)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>cO', ':lua close_other_buffers(true)<CR>', { noremap = true, silent = true })

vim.keymap.set("n", "<leader>Gd", ":Gdiffsplit master<CR>", { desc = "Git diff with master" })


function RemoveUnusedImports()
  local filetype = vim.bo.filetype
  if filetype == 'python' then
    local file_path = vim.fn.expand('%:p')
    local python3_host_prog = vim.g.python3_host_prog
    local autoflake_path = python3_host_prog:gsub('python3$', 'autoflake')
    local cmd = autoflake_path .. ' --remove-all-unused-imports --in-place ' .. file_path
    vim.fn.system(cmd)
    vim.cmd('e!')
  elseif filetype == 'javascript' or filetype == 'typescript' or filetype == 'typescriptreact' or filetype == 'javascriptreact' then
    vim.cmd('CocCommand editor.action.organizeImport')
  else
    print("Unsupported filetype for RemoveUnusedImports")
  end
end

vim.api.nvim_create_user_command('RemoveUnusedImports', RemoveUnusedImports, {})

vim.api.nvim_set_keymap('n', '<leader>af', ':RemoveUnusedImports<CR>', { noremap = true, silent = true })

-- Reverse Lines
vim.api.nvim_set_keymap(
  'v',
  '<leader>[',
  [[:!tac<CR>]],
  { noremap = true, silent = true }
)
