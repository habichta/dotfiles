function Autoflake()
  local filetype = vim.bo.filetype
  if filetype == 'python' then
    local file_path = vim.fn.expand('%:p')
    local python3_host_prog = vim.g.python3_host_prog
    local autoflake_path = python3_host_prog:gsub('python3$', 'autoflake')
    local cmd = autoflake_path .. ' --remove-all-unused-imports --in-place ' .. file_path
    vim.fn.system(cmd)
    vim.cmd('e!') -- Reload the file to reflect changes
  end
end

-- Create a command to run the function
vim.api.nvim_create_user_command('Autoflake', Autoflake, {})

-- Optional: Keybinding for the command
vim.api.nvim_set_keymap('n', '<leader>af', ':Autoflake<CR>', { noremap = true, silent = true })
