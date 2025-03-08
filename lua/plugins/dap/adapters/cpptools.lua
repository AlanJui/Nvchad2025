-- Ref:
-- (1) 【安裝指引】：https://github.com/mfussenegger/nvim-dap/wiki/C-C---Rust-(gdb-via--vscode-cpptools)
-- (2) 【參考範例】：https://www.cnblogs.com/Searchor/p/17320768.html
-- Guide:
-- (*) Download an available version for your OS and architecture: VS Code extension (cpptools-windows-x64.vsix)
--     Download Site: https://github.com/microsoft/vscode-cpptools/releases/tag/v1.24.2
-- (*) Unpack it. .vsix is a zip file and you can use unzip to extract the contents.
-- (*) Ensure extension/debugAdapters/bin/OpenDebugAD7 is executable.
-- Debug Adapter:
-- (*) Windows: cppdbg (OpenDebugAD7)
-- (*) WSL2/Linux: 原生 gdb (gdb -i dap)
-- Compiling to debug:
-- 使用 MinGW (gcc, g++) 編譯程式碼，加上 debug symbols (-g)：
-- 指令： g++ -g -o main.exe main.cpp

local dap = require "dap"

local is_win = (vim.fn.has "win32" == 1 or vim.fn.has "win64" == 1)

local sub_dir = is_win and "\\" or "/"

if is_win then
  -- Windows: 使用 cppdbg (VSCode cpptools/OpenDebugAD7)
  dap.adapters.cppdbg = {
    id = "cppdbg",
    type = "executable",
    command = "C:\\Users\\AlanJui\\.vscode\\extensions\\ms-vscode.cpptools-1.23.6-win32-x64\\debugAdapters\\bin\\OpenDebugAD7.exe",
    options = {
      detached = false,
    },
  }

  dap.configurations.cpp = {
    {
      name = "Launch file (Windows) via vscode-cpptools",
      type = "cppdbg",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. sub_dir, "file")
      end,
      cwd = "${workspaceFolder}",
      stopAtEntry = false,
    },
  }
else
  -- WSL2/Linux: 使用原生 GDB DAP
  dap.adapters.gdb = {
    type = "executable",
    command = "gdb",
    args = { "-i", "dap" },
  }

  dap.configurations.cpp = {
    {
      name = "Launch file (Linux/WSL2) via vscode-cpptools",
      type = "gdb",
      request = "launch",
      program = function()
        return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. sub_dir, "file")
      end,
      cwd = "${workspaceFolder}",
      stopAtEntry = false,
    },
  }
end

dap.configurations.c = dap.configurations.cpp
