local dap = require "dap"
local dap_adapter = require "dap-python"
--------------------------------------------------------------

local function get_venv_python_path()
  local workspace_folder = vim.fn.getcwd()
  local is_win = (vim.fn.has "win32" == 1 or vim.fn.has "win64" == 1)

  if is_win then
    -- Windows 的 venv 位置 (優先找 .venv\Scripts\python.exe)
    if vim.fn.executable(workspace_folder .. "\\.venv\\Scripts\\python.exe") == 1 then
      return workspace_folder .. "\\.venv\\Scripts\\python.exe"
    elseif vim.fn.executable(workspace_folder .. "\\venv\\Scripts\\python.exe") == 1 then
      return workspace_folder .. "\\venv\\Scripts\\python.exe"
    elseif os.getenv "VIRTUAL_ENV" then
      -- 若 VIRTUAL_ENV 已設置，也要找 Scripts\python.exe
      local env_path = os.getenv "VIRTUAL_ENV" .. "\\Scripts\\python.exe"
      if vim.fn.executable(env_path) == 1 then
        return env_path
      end
    end
    -- 若都找不到，就退回系統 Python (或你自訂)
    return "C:\\Program Files\\Python313\\python.exe"
  else
    -- Linux / macOS
    if vim.fn.executable(workspace_folder .. "/.venv/bin/python") == 1 then
      return workspace_folder .. "/.venv/bin/python"
    elseif vim.fn.executable(workspace_folder .. "/venv/bin/python") == 1 then
      return workspace_folder .. "/venv/bin/python"
    elseif os.getenv "VIRTUAL_ENV" then
      local env_path = os.getenv "VIRTUAL_ENV" .. "/bin/python"
      if vim.fn.executable(env_path) == 1 then
        return env_path
      end
    end
    return "/usr/bin/python" -- 或你自訂
  end
end
--------------------------------------------------------------

-- 1. 判斷並取得 debugpy 路徑
local is_win = (vim.fn.has "win32" == 1 or vim.fn.has "win64" == 1)
local debugpy_python_path = is_win
    and (vim.fn.stdpath "data" .. "\\mason\\packages\\debugpy\\venv\\Scripts\\python.exe")
  or (vim.fn.stdpath "data" .. "/mason/packages/debugpy/venv/bin/python")

dap_adapter.setup(debugpy_python_path)

-- 2. 取得 venv 的 python 路徑
local venv_python_path = get_venv_python_path()

-- 3. 設定 DAP Adapter
dap.adapters.python = {
  type = "executable",
  command = debugpy_python_path, -- debugpy 的 python
  args = { "-m", "debugpy.adapter" },
}

-- 4. 設定 DAP Configurations
dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    pythonPath = venv_python_path,
  },
  {
    type = "python",
    request = "launch",
    name = "Launch Django Server",
    cwd = "${workspaceFolder}",
    program = "${workspaceFolder}/manage.py",
    args = { "runserver", "--noreload" },
    console = "integratedTerminal",
    justMyCode = true,
    pythonPath = venv_python_path,
  },
  {
    type = "python",
    request = "launch",
    name = "Python: Django Debug Single Test",
    program = "${workspaceFolder}/manage.py",
    args = { "test", "${relativeFileDirname}" },
    django = true,
    console = "integratedTerminal",
    pythonPath = venv_python_path,
  },
}
