-- General Mappings
vim.api.nvim_set_keymap('n', ',gv', ':vertical wincmd f<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ',gh', ':wincmd f<CR>', { noremap = true, silent = true })

-- Function to search visually selected text using :Ag with fzf
function VisualAg()
  -- Get the selected text in visual mode
  local _, start_line, start_col, _ = unpack(vim.fn.getpos("'<"))
  local _, end_line, end_col, _ = unpack(vim.fn.getpos("'>"))

  -- Adjust end_col for correct indexing
  end_col = end_col + 1

  -- Get the lines in the visual selection
  local lines = vim.fn.getline(start_line, end_line)

  -- Handle single line selection
  if #lines == 1 then
    lines[1] = string.sub(lines[1], start_col, end_col)
  else
    lines[1] = string.sub(lines[1], start_col)
    lines[#lines] = string.sub(lines[#lines], 1, end_col)
  end

  -- Join the lines into a single search string
  local search_term = table.concat(lines, "\n")

  -- Escape special characters for searching
  search_term = vim.fn.escape(search_term, '\\*[]')

  -- Run the :Ag command with the selected text
  vim.cmd('Ag ' .. search_term)
end

-- Map the key combination for visual mode
vim.api.nvim_set_keymap('v', '<leader>ag', ':lua VisualAg()<CR>', { noremap = true, silent = true })
