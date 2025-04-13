-- General Mappings
vim.api.nvim_set_keymap('n', ',gvv', ':vertical wincmd f<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ',gvh', ':wincmd f<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ',gdv', ':vsplit<CR>:normal gd<CR>',
  { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ',gdh', ':split<CR>:normal gd<CR>',
  { noremap = true, silent = true })

function VisualAg()
  -- Check if we are in visual mode or normal mode
  local mode = vim.fn.mode()

  local search_term = ""

  if mode == "v" then
    -- In visual mode: Get the selected text in visual mode
    local _, start_line, start_col, _ = unpack(vim.fn.getpos("'<"))
    local _, end_line, end_col, _ = unpack(vim.fn.getpos("'>"))

    -- Get the lines in the visual selection
    local lines = vim.fn.getline(start_line, end_line)

    -- Handle single line selection
    if #lines == 1 then
      lines[1] = string.sub(lines[1], start_col, end_col)       -- Adjust for correct indexing
    else
      lines[1] = string.sub(lines[1], start_col)                -- Start from start_col
      lines[#lines] = string.sub(lines[#lines], 1, end_col - 1) -- End at end_col - 1
    end

    -- Join the lines into a single search string
    search_term = table.concat(lines, " ")
  else
    -- In normal mode: Get the word under the cursor
    search_term = vim.fn.expand("<cword>")
  end

  -- Escape special characters for searching
  search_term = vim.fn.escape(search_term, '\\*[](){}?+|^$')

  -- Check if the search term is empty
  if search_term == "" then
    print("No text selected.")
    return
  end

  -- Run the :Ag command with the selected text
  vim.cmd('Ag ' .. search_term)
end

-- Map the key combination for normal and visual mode
vim.api.nvim_set_keymap('n', '<leader>P', ':lua VisualAg()<CR>', { noremap = true, silent = true }) --
vim.api.nvim_set_keymap('v', '<leader>P', ':lua VisualAg()<CR>', { noremap = true, silent = true }) --


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
