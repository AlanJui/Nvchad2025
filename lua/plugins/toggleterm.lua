return {
  "akinsho/toggleterm.nvim",
  dependencies = {
    "kdheepak/lazygit.nvim",
    "nvim-lua/plenary.nvim",
  },
  lazy = false,
  cmd = { "ToggleTerm", "TermExec", "LazyGit" },
  keys = {
    { [[<C-t>]], "<cmd>ToggleTerm size=10 direction=horizontal<CR>", { desc = "Horizontal Terminal" } },
    { "<leader>tv", "<cmd>ToggleTerm size=80 direction=vertical<CR>", { desc = "Vertical Terminal" } },
    {
      "<leader>2",
      "<cmd>2ToggleTerm<CR>",
      desc = "Terminal #2",
    },
  },
  config = function()
    ---------------------------------------------------------------------
    -- 變更 Shell 為 Git Bash (MINGW64)
    ---------------------------------------------------------------------
    local function setup_for_git_bash()
      require("toggleterm").setup {
        open_mapping = "<C-\\>",
        start_in_insert = true,
        direction = "float",
      }
    end
    ---------------------------------------------------------------------
    -- 變更 Shell 為 Windows PowerShell
    ---------------------------------------------------------------------
    local function setup_for_powershell()
      require("toggleterm").setup {
        size = 20,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = {
          border = "curved",
          winblend = 0,
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      }
    end

    ---------------------------------------------------------------------
    -- 設置 ToggleTerm 引用 Shell 環境設定
    ---------------------------------------------------------------------
    local is_win_nt = vim.loop.os_uname().sysname == "Windows_NT"
    local has_powershell = vim.fn.executable "powershell.exe" == 1

    if is_win_nt and has_powershell then
      -- 偵測是否在 Git Bash 環境啟動 (檢查環境變數 MSYSTEM 是否存在)
      if vim.fn.getenv "MSYSTEM" ~= vim.NIL then
        -- 若在 Git Bash 啟動，則使用 Git Bash
        setup_for_git_bash()
      else
        -- 預設： Windows PowerShell
        setup_for_powershell()
      end
    end

    function _G.set_terminal_keymaps()
      local opts = { buffer = 0 }
      vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
      vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
      vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
      vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
      vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
      vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
      vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
    end

    -- if you only want these mappings for toggle term use term://*toggleterm#* instead
    vim.cmd "autocmd! TermOpen term://* lua set_terminal_keymaps()"

    ---------------------------------------------------------------------
    -- 設置常用終端機
    ---------------------------------------------------------------------
    -- 載入設定檔 LazyGit Terminal
    require "configs.lazygit"
    -- 載入設定檔 Node.js Console Terminal
    require "configs.nodejs_console"
    -- 載入設定檔 Python Console Terminal
    require "configs.python_console"
  end,
}
