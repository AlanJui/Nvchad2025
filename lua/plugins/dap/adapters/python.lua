local dap = require "dap"
local dap_python = require "dap-python"

-- 獲取 debugpy 的安裝路徑，這裡假設你使用 mason 安裝了 debugpy
-- local mason_path = vim.fn.stdpath "data" .. "/mason/packages/debugpy/
local mason_path = vim.fn.stdpath "data" .. "/mason/packages/debugpy/venv/"
local is_win = vim.fn.has "win32" == 1

-- 根據操作系統選擇 debugpy 的執行檔路徑
local debugpy_path = is_win and mason_path .. "Scripts/python.exe" or mason_path .. "bin/python"

-- 修正：在 Windows 作業系統中，將路徑中的正斜線替換為反斜線，以避免路徑解析問題
debugpy_path = debugpy_path:gsub("/", "\\")

--------------------------------------------------------------
-- 自動偵測專案中的虛擬環境 (venv)
--------------------------------------------------------------
local function get_venv_python()
  local cwd = vim.fn.getcwd()
  local venv_path = is_win and (cwd .. "\\.venv\\Scripts\\python.exe") or (cwd .. "/.venv/bin/python")

  if vim.fn.executable(venv_path) == 1 then
    return venv_path
  end
  -- 如果找不到專案 venv，退而求其次使用系統 python
  return "python"
end

--------------------------------------------------------------
-- 執行設定 (天秤座式的簡潔)
--------------------------------------------------------------

-- 只要呼叫這個，dap-python 就會自動幫你設定好 dap.adapters.python
-- 不再需要手動寫 dap.adapters.python = { ... }
dap_python.setup(debugpy_path)

-- 設定 Debug 規格
dap.configurations.python = {
  -- 1. 標準模式：直接執行目前的檔案
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    pythonPath = get_venv_python,
    console = "integratedTerminal",
  },

  -- 2. 互動模式：執行時詢問參數 (這就是你要的！)
  {
    type = "python",
    request = "launch",
    name = "Launch with Arguments",
    program = "${file}",
    pythonPath = get_venv_python,
    -- 關鍵點：使用 function 呼叫 input 視窗
    args = function()
      local args_str = vim.fn.input "請輸入執行參數 (例如: test.md): "
      -- 將字串依照空白拆分成 table
      return vim.split(args_str, " +")
    end,
    console = "integratedTerminal",
  },

  -- 3. Django 模式 (保持不變)
  {
    type = "python",
    request = "launch",
    name = "Django: Runserver",
    program = "${workspaceFolder}/manage.py",
    args = { "runserver", "--noreload" },
    pythonPath = get_venv_python,
    django = true,
    console = "integratedTerminal",
  },
}
