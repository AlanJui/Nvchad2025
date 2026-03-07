return {
  {
    "stevearc/dressing.nvim",
    lazy = true,
    opts = {
      input = {
        enabled = true,
        -- 這可以解決 "concealed input" 的警告
        default_prompt = "Input:",
        trim_prompt = true,
      },
      select = {
        enabled = true,
        backend = { "telescope", "builtin" }, -- 既然你是 NvChad，通常有 Telescope
      },
    },
  },
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false, -- 建議設為 false 以獲取最新功能
    opts = {
      provider = "gemini", -- 指定使用 Gemini
      providers = { --- 注意：新版通常使用 vendors 或直接在 providers 下
        -- 主力模型：最新、最強但配額較緊
        gemini = {
          __inherited_from = "gemini",
          -- 關鍵修正：嘗試加上 models/ 前綴或使用穩定版名稱
          model = "gemini-3-flash-preview",
          -- 有些版本需要明確指定 API version
          api_key_name = "GEMINI_API_KEY",
          -- 確保傳送的參數符合 Google API 要求
          -- 如果你想試用 3.1，請改為 "gemini-3.1-pro-preview"
          -- model = "gemini-3.1-pro-preview",
          max_tokens = 8192,
          temperature = 0,
        },
      },
    },
    -- 如果是 Windows 使用者，build 指令可能不同，請參考官方 README
    -- build = "make",
    build = "powershell -ExecutionPolicy Bypass -File Build.ps1", -- Windows 專用編譯指令
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      --- 選配依賴
      "nvim-tree/nvim-web-devicons", -- 或 echasnovski/mini.icons
      {
        -- 支援圖片貼上
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
        -- 渲染 Markdown
        "MeanderingProgrammer/render-markdown.nvim",
        opts = { file_types = { "markdown", "Avante" } },
        ft = { "markdown", "Avante" },
      },
    },
  },
}
