local function load_mistral_key(env_file)
  local f = io.open(env_file, "r")
  if not f then return nil end
  for line in f:lines() do
    local key, value = line:match("^([%w_]+)=(.+)$")
    if key == "MISTRAL_API_KEY" then
      f:close()
      return value:gsub("^%s*[\"']?(.-)%s*[\"']?%s*$", "%1")
    end
  end
  f:close()
end

local env_file = vim.fn.expand("~/.vibe/.env")
vim.env.MISTRAL_API_KEY = load_mistral_key(env_file)

require("codecompanion").setup({
  adapters = {
    mistral = function()
      return require("codecompanion.adapters").extend("mistral", {
        env = {
          api_key = "MISTRAL_API_KEY",
        },
      })
    end,
  },
  display = {
    action_palette = {
      width = 0.9,
      height = 0.8,
      opts = {
        title = "CodeCompanion Actions",
        show_preset_actions = true,
        show_preset_prompts = true,
        preview = {
          layout = "right:50%",
          scrollbar = false,
        },
        winopts = {
          width = 0.9,
          height = 0.8,
          row = 0.5,
          col = 0.5,
        },
      },
    },
  },
  interactions = {
    chat = {
      adapter = "mistral",
      model= "mistral-large-latest",
    },
    inline = {
      adapter = "mistral",
      model= "mistral-large-latest",
    },
    background = {
      adapter = "mistral",
      model= "mistral-small-latest",
    },
    cmd = {
      adapter = "mistral",
      model= "mistral-small-latest",
    },
    cli = {
      agent = "mistral_vibe",
      agents = {
        mistral_vibe = {
          cmd = "vibe",
          args = {},
          description = "Mistral Vibe CLI",
          provider = "terminal",
        },
      },
      opts = {
        auto_insert = true, -- Enter insert mode when focusing the CLI terminal
        reload = true, -- Reload buffers when an agent modifies files on disk
      },
      window = {
        opts = {
          list= false
        }}

    },
  },
})

vim.keymap.set({ "n", "v" }, "<Leader>CA", "<cmd>CodeCompanionActions<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<Leader>CI", "<cmd>CodeCompanion<cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<Leader>CL", "<cmd>CodeCompanionCLI<C-h><cr>", { noremap = true, silent = true })
vim.keymap.set({ "n", "v" }, "<Leader>CH", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })
