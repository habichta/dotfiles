vim.api.nvim_create_user_command(
  "SwapClear",
  function()
    local swap_dir = vim.opt.directory:get()[1] -- Get the first directory in the list
    local command = "find " .. swap_dir .. " -type f -name '*.swp' -delete"
    vim.fn.system(command)
    if vim.v.shell_error ~= 0 then
      print("Failed to clear swap files.")
    else
      print("Swap files cleared.")
    end
  end,
  { desc = "Remove swap files from the swap directory" }
)
