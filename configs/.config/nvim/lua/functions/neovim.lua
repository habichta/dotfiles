-- General Mappings
vim.api.nvim_set_keymap('n', ',gv', ':vertical wincmd f<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ',gh', ':wincmd f<CR>', { noremap = true, silent = true })

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
vim.api.nvim_set_keymap('n', '<leader>pp', ':lua VisualAg()<CR>', { noremap = true, silent = true }) --
vim.api.nvim_set_keymap('v', '<leader>pp', ':lua VisualAg()<CR>', { noremap = true, silent = true }) --


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
vim.keymap.set("n", "<leader>p", ShowCurrentFilePath, { noremap = true, silent = true })
