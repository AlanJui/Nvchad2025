return {
  {
    "milanglacier/minuet-ai.nvim",
    event = "InsertEnter",
    opts = {
      -- provider = "claude", -- 或 "openai" / "gemini"
      provider = "openai",

      provider_options = {
        claude = {
          model = "claude-haiku-4-5", -- 補全用小模型較省、較快
          api_key = "ANTHROPIC_API_KEY",
        },
        openai = {
          model = "gpt-5.4-nano",
          api_key = "OPENAI_API_KEY",
          -- api_key = function()
          --   return secrets.OPENAI_API_KEY
          -- end,
          -- RIME 詞庫常包含大量短行與候選詞，AI 自動補全可能頻繁觸發；
          -- 若發現請求太密集，可只保留手動觸發，或增加 Minuet 的
          -- throttle 與 debounce：
          throttle = 1500,
          debounce = 600,
          optional = {
            max_completion_tokens = 128,
            reasoning_effort = "none",
          },
        },
      },
      virtualtext = {
        auto_trigger_ft = {
          "python",
          "lua",
          "typescript",
          "javascript",
          "go",
          "rust",
          "yaml",
        },
        keymap = {
          accept = "<C-]>", -- 對齊你以前 copilot 的 accept
          accept_line = "<C-End>",
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-e>",
        },
      },
    },
  },
}
