require("nvim_aider").setup({
  -- Command that executes Aider
  aider_cmd = "aider",
  -- Command line arguments passed to aider
  args = {
    "--pretty",
  },
  -- Automatically reload buffers changed by Aider (requires vim.o.autoread = true)
  auto_reload = true,
  -- Theme colors (automatically uses Catppuccin flavor if available)
  theme = {
    user_input_color = "#a6da95",
    tool_output_color = "#8aadf4",
    tool_error_color = "#ed8796",
    tool_warning_color = "#eed49f",
    assistant_output_color = "#c6a0f6",
    completion_menu_color = "#cad3f5",
    completion_menu_bg_color = "#24273a",
    completion_menu_current_color = "#181926",
    completion_menu_current_bg_color = "#f4dbd6",
  },
  -- snacks.picker.layout.Config configuration
  picker_cfg = {
    preset = "vscode",
  },
  -- Other snacks.terminal.Opts options
  config = {
    os = { editPreset = "nvim-remote" },
    gui = { nerdFontsVersion = "3" },
  },
  win = {
    wo = { winbar = "Aider" },
    style = "nvim_aider",
    position = "right",
  },
})

local api = require("nvim_aider").api

function AddFilesToAider()
  local fzf_opts = {
    source = 'git ls-files',
    sinklist = function(selected)
      for _, file in ipairs(selected) do
        local abs_path = vim.fn.fnamemodify(file, ":p")
        api.add_file(abs_path)
      end
    end,
    options = '--multi --preview "batcat --style=numbers --color=always {}"',
  }

  vim.fn['fzf#run'](vim.fn['fzf#wrap'](fzf_opts))
end

vim.api.nvim_set_keymap('n', '<leader>AZ', ':lua AddFilesToAider()<CR>', {
  noremap = true,
  silent = true,
  desc = "Add Git-tracked Files to Aider via FZF"
})

vim.api.nvim_set_keymap('n', '<leader>AA', ':Aider toggle<CR>', { noremap = true, silent = true, desc = "Toggle Aider" })
vim.api.nvim_set_keymap('n', '<leader>AC', ':Aider command<CR>',
  { noremap = true, silent = true, desc = "Aider Commands" })
vim.api.nvim_set_keymap('n', '<leader>AS', ':Aider send<CR>', { noremap = true, silent = true, desc = "Send to Aider" })
vim.api.nvim_set_keymap('n', '<leader>AB', ':Aider buffer<CR>', { noremap = true, silent = true, desc = "Send Buffer" })
vim.api.nvim_set_keymap('n', '<leader>AF', ':Aider add<CR>', { noremap = true, silent = true, desc = "Add File" })
vim.api.nvim_set_keymap('n', '<leader>AD', ':Aider drop<CR>', { noremap = true, silent = true, desc = "Drop File" })
vim.api.nvim_set_keymap('n', '<leader>AR', ':Aider add readonly<CR>',
  { noremap = true, silent = true, desc = "Add Read-Only" })
vim.api.nvim_set_keymap('n', '<leader>AX', ':Aider reset<CR>',
  { noremap = true, silent = true, desc = "Reset Context" })


-- Set up buffer-local keymaps for nvim-tree
vim.api.nvim_create_autocmd("FileType", {
  pattern = "NvimTree",
  callback = function()
    vim.keymap.set('n', '<Leader>AF', ':AiderTreeAddFile<CR>', {
      buffer = true,
      noremap = true,
      silent = true,
      desc = "Add File from Tree to Aider"
    })
    vim.keymap.set('n', '<Leader>AD', ':AiderTreeDropFile<CR>', {
      buffer = true,
      noremap = true,
      silent = true,
      desc = "Drop File from Tree from Aider"
    })
  end
})
