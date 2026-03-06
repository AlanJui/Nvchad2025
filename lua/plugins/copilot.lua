-- lua/plugins/copilot.lua
return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",

  config = function()
    require("copilot").setup {
      panel = {
        enabled = true, -- :Copilot panel 可以開側邊視窗看建議
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>",
        },
      },

      suggestion = {
        enabled = true, -- 啟用「灰色 ghost text」那種 inline 補全
        auto_trigger = true, -- 自動出現建議，不用每次手動觸發
        debounce = 75,
        keymap = {
          accept = "<C-]>",
          accept_word = "<C-Right>",
          accept_line = "<C-End>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-[>",
          -- accept = "<M-l>", -- Alt + l 接受建議
          -- accept_word = "<M-w>", -- Alt + w 接受一個字
          -- accept_line = "<M-;>", -- Alt + ; 接受一整行（我幫你改成比較好按的）
          -- next = "<M-]>", -- Alt + ] 下一個建議
          -- prev = "<M-[>", -- Alt + [ 上一個建議
          -- dismiss = "<C-]>", -- Ctrl + ] 關閉建議
        },
      },

      filetypes = {
        markdown = true,
        gitcommit = true,
        yaml = true,
        lua = true,
        python = true,
        javascript = true,
        typescript = true,
        -- 不想開 Copilot 的檔案類型在這裡設成 false
        help = false,
        ["*"] = true, -- 其餘預設開啟
      },

      -- 基本上不用改這裡，除非要客製 LSP server 參數
      server_opts_overrides = {},
    }
  end,
}
