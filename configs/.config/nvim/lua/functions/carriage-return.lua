local function remove_carriage_returns()
  vim.cmd("%s/\\%x0d//g")
end

vim.api.nvim_create_user_command(
  "RCR",
  remove_carriage_returns,
  {desc = "Remove carriage returns"}
  )
