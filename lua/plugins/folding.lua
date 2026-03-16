return {
  -- UFO folding
  {
    {
      "kevinhwang91/nvim-ufo",
      dependencies = {
        "kevinhwang91/promise-async",
        {
          "luukvbaal/statuscol.nvim",
          config = function()
            local builtin = require "statuscol.builtin"
            require("statuscol").setup {
              relculright = true,
              ft_ignore = { "NvimTree" },
              segments = {
                { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
                { text = { "%s" }, click = "v:lua.ScSa" },
                -- 左欄：相對行號（游標行留空）
                { text = { "%=%{v:relnum?v:relnum:''}" } },
                -- 右欄：絕對行號
                { text = { " %l " }, click = "v:lua.ScLa" },
              },
            }
          end,
        },
      },
      event = "BufReadPost",
      opts = {
        provider_selector = function()
          return { "treesitter", "indent" }
        end,
      },
      init = function()
        vim.keymap.set("n", "zR", function()
          require("ufo").openAllFolds()
        end)
        vim.keymap.set("n", "zM", function()
          require("ufo").closeAllFolds()
        end)
      end,
    },
    -- Folding preview, by default h and l keys are used.
    -- On first press of h key, when cursor is on a closed fold, the preview will be shown.
    -- On second press the preview will be closed and fold will be opened.
    -- When preview is opened, the l key will close it and open fold. In all other cases these keys will work as usual.
    {
      "anuvyklack/fold-preview.nvim",
      dependencies = "anuvyklack/keymap-amend.nvim",
      config = true,
    },
  },
}
