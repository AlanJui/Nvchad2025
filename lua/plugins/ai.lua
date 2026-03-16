return {
  -- {
  --   "stevearc/dressing.nvim",
  --   lazy = true,
  --   opts = {
  --     input = {
  --       enabled = true,
  --       -- 關鍵：強制不使用 concealed (隱藏字元)，解決 Windows 下的警告與崩潰
  --       override = function(conf)
  --         conf.password = false
  --         return conf
  --       end,
  --       default_prompt = "Input:",
  --       trim_prompt = true,
  --     },
  --     select = {
  --       enabled = true,
  --       -- 在 Windows 下，建議將 builtin 放在前面以提高穩定性
  --       backend = { "builtin", "telescope" },
  --       builtin = {
  --         show_numbers = false,
  --         border = "rounded",
  --         relative = "editor",
  --       },
  --     },
  --   },
  -- },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = {
      -- 明確指定使用 dressing
      input = {
        provider = "dressing",
      },
      -- 關閉自動提示，避免在背地裡觸發不穩定的 UI 請求
      hints = { enabled = false },
      -- AI 模型配置，優先使用 Gemini，並提供備選的 Claude 配置
      -- provider = "claude",
      provider = "gemini",
      auto_suggestions_provider = "gemini",
      providers = {
        gemini = {
          __inherited_from = "gemini",
          -- model = "gemini-3-flash-preview",
          model = "gemini-3-pro-preview",
          max_tokens = 8192,
          temperature = 0,
        },
        claude = {
          endpoint = "https://api.anthropic.com",
          model = "claude-sonnet-4-20250514",
          timeout = 30000, -- Timeout in milliseconds
          extra_request_body = {
            temperature = 0.75,
            max_tokens = 20480,
          },
        },
      },
    },
    build = "powershell -ExecutionPolicy Bypass -File Build.ps1",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = { insert_mode = true },
            use_absolute_path = true,
          },
        },
      },
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "markdown", "Avante" } },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
