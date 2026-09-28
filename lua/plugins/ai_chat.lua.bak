-- CodeCompanion: AI 助手 (https://codecompanion.olimorris.dev)
-- API Key 來源:.env.lua 的 ANTHROPIC_API_KEY(init.lua 已載入 vim.env)
return {
  {
    "olimorris/codecompanion.nvim",
    version = "^19.0.0", -- 鎖定主版本,避免破壞性更新
    cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionActions", "CodeCompanionCmd" },
    keys = {
      { "<leader>ai", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "CodeCompanion Chat" },
      { "<leader>ap", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "CodeCompanion Actions" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      interactions = {
        chat = {
          adapter = {
            name = "anthropic",
            model = "claude-sonnet-4-5",
          },
        },
        inline = {
          adapter = "anthropic",
        },
        cmd = {
          adapter = "anthropic",
        },
      },
    },
  },
}
