-- custom/mappings.lua

local map = vim.keymap.set

-- 小工具：選可用的 Python 執行檔
local function pick_python()
  if vim.fn.executable "python3" == 1 then
    return "python3"
  elseif vim.fn.executable "python" == 1 then
    return "python"
  else
    return "python3" -- 退而求其次
  end
end

--======================================================
-- 自訂指令：:RunPy（浮動視窗執行目前 Python 檔）
--======================================================
vim.api.nvim_create_user_command("RunPy", function()
  require("nvchad.term").runner {
    id = "python_runner", -- 固定 terminal id
    pos = "float", -- 以浮動視窗顯示
    cmd = function()
      local file = vim.fn.expand "%"
      return string.format("%s %s", pick_python(), vim.fn.fnameescape(file))
    end,
  }
end, {})

--======================================================
-- 依檔案類型在浮動視窗執行
--======================================================
map("n", "<leader>pr", function()
  require("nvchad.term").runner {
    id = "code_runner", -- 重跑時要用同一個 id
    pos = "float",
    cmd = function()
      local file = vim.fn.expand "%"
      local escaped = vim.fn.fnameescape(file)
      local ft_cmds = {
        python = string.format("%s %s", pick_python(), escaped),
        cpp = string.format("clear && g++ -O2 -std=c++20 -o out %s && ./out", escaped),
        lua = string.format("lua %s", escaped),
      }
      return ft_cmds[vim.bo.ft] or "echo 'No runner defined for this filetype'"
    end,
  }
end, { desc = "Run current file (float terminal)" })

--======================================================
-- 快捷鍵：<leader>R（浮動視窗重跑上一次指令）
--======================================================
map("n", "<leader>pR", function()
  require("nvchad.term").runner {
    id = "code_runner", -- 必須與 <leader>r 相同
    pos = "float",
    -- 不提供 cmd，表示在同一個終端重跑上一個命令
  }
end, { desc = "Re-run last command (float terminal)" })

--======================================================
-- 依檔案類型在底端之終端機視窗執行
--======================================================
map("n", "<leader>ph", function()
  require("nvchad.term").runner {
    id = "code_runner",
    pos = "sp",
    cmd = function()
      local file = vim.fn.expand "%"
      local ft_cmds = {
        python = "python3 " .. file,
        cpp = "clear && g++ -o out " .. file .. " && ./out",
        lua = "lua " .. file,
      }
      return ft_cmds[vim.bo.ft] or "echo 'No runner defined for this filetype'"
    end,
  }
end, { desc = "Run current file in terminal" })

--======================================================
-- 依檔案類型在右端之終端機視窗執行
--======================================================
map("n", "<leader>pv", function()
  require("nvchad.term").runner {
    id = "code_runner",
    pos = "vsp",
    cmd = function()
      local file = vim.fn.expand "%"
      local ft_cmds = {
        python = "python3 " .. file,
        cpp = "clear && g++ -o out " .. file .. " && ./out",
        lua = "lua " .. file,
      }
      return ft_cmds[vim.bo.ft] or "echo 'No runner defined for this filetype'"
    end,
  }
end, { desc = "Run current file in terminal on right side" })
--======================================================
-- 快捷鍵：<Ctrl>+<\>（開/收一個浮動終端）
--======================================================
-- 取系統預設 shell（跨平台安全）
local function pick_shell()
  -- 若你想固定 bash，可改成: return "bash"
  return vim.o.shell ~= "" and vim.o.shell or "bash"
end

-- 用表格保存我們的浮動視窗 id
local ToggleTerm = { win = nil, id = "toggle_runner" }

-- 真・Toggle：存在就關掉，否則建立
local function toggle_float_term()
  if ToggleTerm.win and vim.api.nvim_win_is_valid(ToggleTerm.win) then
    pcall(vim.api.nvim_win_close, ToggleTerm.win, true)
    ToggleTerm.win = nil
    return
  end

  -- 開一個新的浮動 NvChad 終端（會自動切到該視窗）
  require("nvchad.term").runner {
    id = ToggleTerm.id, -- 固定 id，方便之後重用
    -- pos = "float",
    pos = "sp",
    cmd = function()
      return pick_shell()
    end,
    clear_cmd = false, -- 保留歷史（像一般終端一樣）
  }

  -- runner 會把焦點放到剛開的浮動窗，所以直接記錄「目前視窗」即可
  ToggleTerm.win = vim.api.nvim_get_current_win()
end

-- 重新執行終端內「上一個指令」：不開新窗、只在同一 id 裡重跑
local function rerun_last_in_term()
  require("nvchad.term").runner {
    id = ToggleTerm.id,
    pos = "float",
    -- 不給 cmd → 表示重跑上一個命令
  }
  -- 若有需要，也可以更新 ToggleTerm.win
  ToggleTerm.win = vim.api.nvim_get_current_win()
end

-- ===== 綁定快捷鍵 =====
-- 注意：Lua 字串裡的反斜線要跳脫，所以寫成 "<C-\\>"
-- Normal 模式：<C-\> 開/收 浮動終端
map("n", "<C-\\>", toggle_float_term, { desc = "Toggle NvChad float terminal" })

-- Terminal 模式也能用同一鍵：先退出 Terminal 模式，再切換
map("t", "<C-\\>", function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true), "n", true)
  toggle_float_term()
end, { desc = "Toggle NvChad float terminal (terminal mode)" })
