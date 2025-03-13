--------------------------------------------------------------------
-- Compile and Run
--------------------------------------------------------------------
local env = require "utils.env"

map("n", "<leader>rn", function()
  local path_sep = env.path_sep

  local file_type = vim.bo.filetype
  local file_path = vim.fn.expand "%:p"
  local file_name = vim.fn.expand "%:t"
  local main_file_name = vim.fn.expand "%:t:r"
  local output = main_file_name .. ".exe"
  -- local output = vim.fn.expand "%:p:r" .. ".exe"
  local cmd_str = ""

  if env.is_win or env.is_cmd then
    -----------------------------------------------------------------------------------
    -- Windows 作業系統 + cmd / powershell shell
    -----------------------------------------------------------------------------------
    if file_type == "c" then
      -- "Compile and Run C file (.exe)",
      -- 指令格式：gcc -o %:t:r.exe %:t && .\%:t:r.exe
      -- cmd_str = "gcc -o %:t:r.exe %:t && ." .. path_sep .. "%:t:r.exe"
      cmd_str = "gcc -o " .. output .. " " .. file_name .. " && ." .. path_sep .. output
    elseif file_type == "cpp" then
      -- "Compile and Run C++ file (.exe)",
      -- 指令格式：g++ -g -o %:t:r.exe %:t && .\%:t:r.exe
      -- local compile_cmd = { "g++", "-g", "-o", output, file_path }
      -- cmd_str = table.concat(compile_cmd, " ")
      -- cmd_str = "g++ -g -o %:t:r.exe %:t && ." .. path_sep .. "%:t:r.exe"
      cmd_str = "g++ -g -o " .. output .. " " .. file_name .. " && ." .. path_sep .. output
    end
  elseif env.is_msys2 or env.is_git_bash then
    -----------------------------------------------------------------------------------
    -- Windows 作業系統 + MSYS2 / Git Bash shell
    -----------------------------------------------------------------------------------
    if file_type == "c" then
      -- "Compile and Run C file (.exe)",
      -- 指令格式：gcc -g -o %:t:r.exe %:t && ./%:t:r.exe
      -- cmd_str = "gcc -o %:t:r.exe %:t && ." .. path_sep .. "%:t:r.exe"
      cmd_str = "gcc -o " .. output .. " " .. file_name .. " && ." .. path_sep .. output
    elseif file_type == "cpp" then
      -- "Compile and Run C++ file (.exe)",
      -- 指令格式：g++ -g -o %:t:r.exe %:t && ./%:t:r.exe
      -- cmd_str = g++ -g -o %:t:r %:t && ." .. path_sep .. "%:t:r"
      cmd_str = "g++ -g -o " .. output .. " " .. file_name .. " && ." .. path_sep .. output
    end
  elseif env.is_wsl or env.is_linux then
    -----------------------------------------------------------------------------------
    -- Linux 作業系統 + zsh / bash shell
    -- Windows 作業系統 + WSL2
    -----------------------------------------------------------------------------------
    if file_type == "c" then
      -- "Compile and Run C file (無副檔名 .exe)",
      -- 指令格式：gcc -g -o %:t:r %:t && ./%:t:r
      -- cmd_str = "gcc -o %:t:r %:t && ." .. path_sep .. "%:t:r"
      cmd_str = "gcc -o " .. main_file_name .. " " .. file_name .. " && ." .. path_sep .. main_file_name
    elseif file_type == "cpp" then
      -- "Compile and Run C++ file (無副檔名.exe)",
      -- 指令格式：g++ -g -o %:t:r %:t && ./%:t:r
      -- vim.cmd(":terminal g++ -g -o %:t:r %:t && ." .. path_sep .. "%:t:r")
      cmd_str = "g++ -g -o " .. main_file_name .. " " .. file_name .. " && ." .. path_sep .. main_file_name
    end
  else
    -----------------------------------------------------------------------------------
    -- 無需編譯，透過直譯器便能執行的程式語言
    -----------------------------------------------------------------------------------
    if file_type == "lua" then
      -- vim.cmd(":terminal lua " .. file_name)
      cmd_str = "lua " .. file_path
    elseif file_type == "python" then
      -- vim.cmd(":terminal python " .. file_name)
      cmd_str = "python " .. file_path
    end
  end
  -- 透過 toggleterm 執行編譯/執行指令
  -- vim.cmd(":terminal " .. cmd_str)
  require("toggleterm").exec(cmd_str)
end, { desc = "Compile and Run" })
