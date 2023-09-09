-- DAP Debugger Confiduration

local dap, dapui = require("dap"), require("dapui")

dap.adapters.codelldb = {
  type = 'server',
  port = "${port}",
  executable = {
    command = '/home/habichta/.local/bin/lldb/extension/adapter/codelldb',
    args = {"--port", "${port}"},
  }
}

dap.configurations.c= {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {}
  },
}

dapui.setup({})


dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
