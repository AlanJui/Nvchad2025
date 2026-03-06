require "nvchad.mappings"
local tbl = require "utils.table"

-- add yours here

local map = vim.keymap.set

-- 針對 HTML 文件的快捷鍵
-- map("n", "<leader>tls", "<cmd>LiveServerStart %<cr>", { desc = "Start Live Server for current file" })
-- map("n", "<leader>tlx", "<cmd>LiveServerStop<cr>", { desc = "Exit Live Server" })

-- 1. 先定義功能快捷鍵
map("n", "<leader>tls", "<cmd>LiveServerStart %<cr>", { desc = "Start Live Server" })
map("n", "<leader>tlx", "<cmd>LiveServerStop<cr>", { desc = "Exit Live Server" })

-- 2. 再定義 which-key 的選單名稱 (建議放在 mappings.lua 最後面)
local present, wk = pcall(require, "which-key")
if present then
  -- 針對 HTML 文件的快捷鍵（或你想限制的檔案類型）
  wk.add {
    mode = { "n" },
    -- 如果只想在 html 檔案出現，可以加上條件
    -- cond = function() return vim.bo.filetype == "html" end,

    -- 定義群組及使用開關型圖示
    {
      "<leader>tl",
      group = "Live Server",
      icon = { icon = "󰔡", color = "blue" },
    },

    {
      "<leader>tls",
      "<cmd>LiveServerStart %<cr>",
      desc = "Start Live Server",
      icon = { icon = "󰨞 ", color = "green" }, -- 這裡設定圖示
    },
    {
      "<leader>tlx",
      "<cmd>LiveServerStop<cr>",
      desc = "Stop Live Server",
      icon = { icon = "󰩈 ", color = "red" }, -- 這裡設定圖示
    },
  }
end

-- 常用快捷鍵
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map("n", "<leader>ff", "<cmd> Telescope <cr>")

-- multiple modes
map({ "i", "n" }, "<C-k>", "<Up>", { desc = "Move up" })
map({ "i", "n" }, "<C-j>", "<Down>", { desc = "Move down" })

-- mapping with a lua functionG
map("n", "<A-i>", function()
  -- do something
end, { desc = "Terminal toggle floating" })

-- Disable mappings
local nomap = vim.keymap.del

nomap("i", "<C-k>")
nomap("n", "<C-k>")

--------------------------------------------------------------------
-- DAP
--------------------------------------------------------------------
-- map("n", "<leader>db", "<cmd> DapToggleBreakpoint <CR>", { desc = "Add breakpoint at line" })
-- map("n", "<leader>dr", "<cmd> DapContinue <CR>", { desc = "Start or continue the debugger" })

--------------------------------------------------------------------
-- Editing
--------------------------------------------------------------------
map("i", "jj", "<Esc>")
map("i", "jk", "<Esc>")

-- Newline in insert mode
map("i", "<A-k>", "<C-o>O")
map("i", "<A-j>", "<C-o>o")

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- better indenting
map("v", "<", "<gv", { desc = "Un-indent line" })
map("v", ">", ">gv", { desc = "Indent line" })

-- better up/down
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move Lines
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move up" })

map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

--------------------------------------------------------------------
-- System Clipboard
--------------------------------------------------------------------
map("n", "<localleader>y", '"*y')
map("n", "<localleader>p", '"*p')

--------------------------------------------------------------------
-- Buffers
--------------------------------------------------------------------

-- buffers
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
map("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
-- map("n", "gT", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
-- map("n", "gt", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })

map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

--------------------------------------------------------------------
-- Tab navigation
--------------------------------------------------------------------
-- map("n", "to", ":tabnew<CR>") -- open new tab
-- map("n", "tx", ":tabclose<CR>") -- close current tab
-- map("n", "tn", ":tabn<CR>") --  go to next tab
-- map("n", "tp", ":tabp<CR>") --  go to previous tab
--
-- map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
-- map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
-- map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
-- map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
-- map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
-- map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / clear hlsearch / diff update" }
)

map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

--------------------------------------------------------------------
-- Files operations
--------------------------------------------------------------------
-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- save file
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- quit file
map("n", "<leader>bq", "<cmd>qa<cr>", { desc = "Quit All" })
map("n", "<leader>bQ", "<cmd>qa!<cr>", { desc = "Discard All and Quit" })

--------------------------------------------------------------------
-- Diagnostic navigation
--------------------------------------------------------------------
-- map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
-- map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

-- map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
-- map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })

--------------------------------------------------------------------
-- Windows navigation
--------------------------------------------------------------------
-- Split window
map("n", "<localleader>sh", ":split<CR>")
map("n", "<localleader>sv", ":vsplit<CR>")
map("n", "<leader>w-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>w|", "<C-W>v", { desc = "Split window right" })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below" })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right" })
map("n", "<leader>wh", "<CMD>split<CR>", { desc = "H-Split" })
map("n", "<leader>wv", "<CMD>vsplit<CR>", { desc = "V-Split" })

-- Window Resize
map("n", "<M-Up>", "<cmd>wincmd -<CR>")
map("n", "<M-Down>", "<cmd>wincmd +<CR>")
map("n", "<M-Left>", "<cmd>wincmd <<CR>")
map("n", "<M-Right>", "<cmd>wincmd ><CR>")
map("n", "<leader>w=", "<C-w>=", { desc = "Equal Width" })
map("n", "<leader>wi", "<CMD>tabnew %<CR>", { desc = "Zoom-in Window" })
map("n", "<leader>wo", "<CMD>tabclose<CR>", { desc = "Zoom-out Window" })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Window navigation
map("n", "<localleader>w", "<C-W>p", { desc = "Other window" })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window" })
map("n", "<leader>wm", "<CMD>MaximizerToggle<CR>", { desc = "Max/Org Window" })
map("n", "<leader>wc", "<CMD>close<CR>", { desc = "Close Window" })

-- Move cursor to window using the <ctrl> hjkl keys
map("n", "<c-k>", ":wincmd k<CR>", { desc = "Go to left window" })
map("n", "<c-j>", ":wincmd j<CR>", { desc = "Go to lower window" })
map("n", "<c-h>", ":wincmd h<CR>", { desc = "Go to upper window" })
map("n", "<c-l>", ":wincmd l<CR>", { desc = "Go to right window" })

--------------------------------------------------------------------
-- Misc.
--------------------------------------------------------------------
-- lazy
map("n", "<leader>l", "<cmd>:Lazy<cr>", { desc = "Lazy" })

-- Terminal toggle options
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
--------------------------------------------------------------------
-- Compile and Run
--------------------------------------------------------------------
local env = require "utils.env"

map("n", "<leader>rn", function()
  local path_sep = env.path_sep

  local file_type = vim.bo.filetype
  local file_name = vim.fn.expand "%:t"
  local main_file_name = vim.fn.expand "%:t:r"
  local output = main_file_name .. (env.is_win and ".exe" or "")
  local cmd_str = ""

  if file_type == "c" then
    cmd_str = string.format("gcc -o %s %s && .%s%s", output, file_name, path_sep, output)
  elseif file_type == "cpp" then
    cmd_str = string.format("g++ -g -o %s %s && .%s%s", output, file_name, path_sep, output)
  elseif file_type == "lua" then
    cmd_str = "lua " .. file_name
  elseif file_type == "python" then
    cmd_str = "python " .. file_name
  elseif file_type == "rust" then
    cmd_str = "cargo build "
  end

  require("toggleterm").exec(cmd_str)
end, { desc = "Compile and Run" })

-- icon = "󰨞 "     -- 像播放/啟動的圖示
-- icon = "󰩈 "     -- 停止／關閉的圖示
-- icon = " "      -- 伺服器／網路相關
-- icon = " "      -- 閃電（快速啟動）
-- icon = " "      -- 齒輪（設定／工具）
