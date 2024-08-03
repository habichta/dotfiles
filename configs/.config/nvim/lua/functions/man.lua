-- Function to open man pages
local function open_man_page(executable)
  -- If no argument is given, show a message
  if executable == nil or executable == "" then
    print("Please provide an executable for the man page")
    return
  end
  -- Construct the command to open the man page
  local cmd = "man " .. executable
  -- Execute the command
  vim.cmd(cmd)
end

-- Create the :Man command in Vim
vim.api.nvim_create_user_command(
  'Man',
  function(opts)
    open_man_page(opts.args)
  end,
  { nargs = 1 }
)
