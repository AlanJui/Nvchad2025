# EnvCheck 變更規劃

## 摘要

原 utils/envcheck.lua 程式碼需為除錯，進行變更。此程式碼之變更，將連帶
影響以下 2 支程式碼：

- utils/env.lua: utils/envcheck.lua 需引用 env.lua 之産出，以進行後續作業；

- mappings.lua: 此處之程式碼需引用，utils.env 程式舘之産出，才能正常運作。

【註】：nvim 目錄結構

```sh
~/.config/nvim/
├── lua/
│   ├── plugins/
│   │   ├── ...
│   │   └── init.lua
│   ├── configs/
│   │   ├── ...
│   │   ├── conform.lua
│   │   └── lspconfig.lua
│   ├── utils/
│   │   ├── ...
│   │   ├── envcheck.lua
│   │   └── env.lua
│   ├── mappings.lua
│   ├── options.lua
│   └── chadrc.lua
└── init.lua
```

## 變更規劃

### 規劃描述

󰈚 No Name 󰅖  󰅖
1 =========================================
1 🚧 Neovim 作業環境檢測報告
2 =========================================
3
4 📌 系統環境資訊：
5 • 🪟 作業系統：Windows (原生)
8 • 系統介面（Shell）：PowerShell
6
7 📌 Shell 環境設定：
8 • 使用的 Shell：bash.exe
9 • Shell 指令參數：-s
10 📌 子目錄設定：
11 • 目錄分隔符號：\

1. 新增第 8 行，此行可能顯示結果：

   - CMD
   - WSL2
   - MSYS2
   - Git Bash (MSW)
   - Bash / Zsh

2. 新增第 10、11 行：顯示在此【系統介面（Shell）】
   應使用之【目錄分隔符號】。判斷時應以 Shell 判斷；
   而不要以【作業系統】判斷，否則，就會如以下 mappings.lua
   所展示之程式碼，在執行時期發生以下之執行錯誤：

   ```sh
   AlanJui@NucBox_M6 MINGW64 /c/work/cpp/MinGW (main)
   $ gcc -o demo.exe demo.c && .\demo.exe
   bash: .demo.exe: command not found
   ```

   經實地在 Git Bash 及 MSYS2 之測試，透過 ToggleTerm 産生之
   終端機，只要將 .\demo.exe 改正成 ./demo.exe 便能正確執行。

   【~/.config/nvim/lua/mappings.lua】：

   ```lua
   ...
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
    ...
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
    ...
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
     enp
     -- 透過 toggleterm 執行編譯/執行指令
     -- vim.cmd(":terminal " .. cmd_str)
     require("toggleterm").exec(cmd_str)
   end, { desc = "Compile and Run" })
   ```

## 工作目標

1. 修訂 utils/env.lua 程式碼；
2. 修訂 utils/envcheck.lua 程式碼。原 function 改名；show_env_check() -->
   show_report()；
3. 須確認 envcheck.lua 變更後，在 options.lua 檔中所設定之 EnvCheck 指令
   仍能正常執行。

【註】：上述 3. ，若遇 :EnvCheck 無法順利執行，可能是因 Nvim 的快取(Cache)
機制，仍保有舊版資料，需重啟 nvim ；或以指令先清空 Cache 再執行 EnvCheck：

```sh
:lua package.loaded["utils.envcheck"] = nil
:EnvCheck
```
