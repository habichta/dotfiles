--- Perform a global search and replace operation in Git-tracked files.
---
--- This function searches for a given pattern in Git-tracked files and replaces all occurrences
--- with a specified replacement string. It supports case-sensitive search and prompts for
--- confirmation before replacing each occurrence. It does not safe the changes use :wa
---
--- @param args table: A table containing the arguments passed to the function.
---   args.fargs[1] (string): The search pattern.
---   args.fargs[2] (string): The replacement pattern.
---   args.fargs[3+] (string): Filetypes to include in the search (e.g., "lua", "txt").
---
--
function GitTrackedGlobalReplace(args)
  if not args.fargs[1] or not args.fargs[2] then
    print("Error: Search pattern and replacement pattern are mandatory.")
    return
  end
  local find_pattern = args.fargs[1]
  local replace_pattern = args.fargs[2]
  local filetypes = table.concat(args.fargs, " ", 3)

  local git_ls_files_cmd = "git ls-files " .. filetypes
  local git_tracked_files = vim.fn.systemlist(git_ls_files_cmd)

  if vim.v.shell_error ~= 0 then
    print("Failed to get Git tracked files")
    return
  end

  local vimgrep_cmd = "vimgrep /" .. find_pattern .. "/gj " .. table.concat(git_tracked_files, " ")

  -- Run vimgrep command
  local ok, _ = pcall(vim.api.nvim_exec, vimgrep_cmd, true)
  if not ok or #vim.fn.getqflist() == 0 then
    print("No matches found for pattern: " .. find_pattern)
  else
    vim.cmd("copen")  -- Open the quickfix window if matches were found
    local cfdo_cmd = "cfdo %s/\\C" .. find_pattern .. "/" .. replace_pattern .. "/gc"
    vim.cmd(cfdo_cmd) -- Perform steps, confirm each replacement
  end
end

vim.api.nvim_create_user_command("GR", GitTrackedGlobalReplace, { nargs = "+" })
