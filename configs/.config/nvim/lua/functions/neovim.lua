local function source_files(directory, filetype)
  local pattern = directory .. '/**/*.' .. filetype
  local files = vim.split(vim.fn.glob(pattern), '\n')

  for _, file in ipairs(files) do
    if vim.fn.filereadable(file) == 1 then
      if filetype == 'vim' then
        vim.cmd('source ' .. file)
      elseif filetype == 'lua' then
        vim.cmd('luafile ' .. file)
      end
      print('Sourced: ' .. file)
    end
  end
end

function SourceAll()
  local config_directory = '~/.config/nvim/'
  local vim_directory = '~/.dotfi'
  local config_dir = vim.fn.stdpath('config')
  print("Configuration directory is: " .. config_dir)
  -- source_files(directory, 'vim')
  -- source_files(directory, 'lua')
end

vim.api.nvim_create_user_command('SourceAll', function()
  SourceAll()
end, {})
