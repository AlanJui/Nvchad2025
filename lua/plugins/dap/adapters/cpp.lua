local dap = require("dap")

-- To have nvim-dap connect to it, you can define an adapter like this:
-- 要讓 nvim-dap 連接到它，您可以定義一個適配器，如下所示：
dap.adapters.codelldb = {
  type = "server",
  host = "127.0.0.1",
  port = "${port}",
  executable = {
    command = vim.fn.exepath("codellb"),
    -- command = vim.fn.stdpath("data") .. "/mason/packages/codelldb/extension/adapter/codelldb",
    args = { "--port", "${port}" },
    -- On windows you may have to uncomment this:
    -- detached = false,
  },
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
  },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp
