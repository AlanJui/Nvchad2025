return {
  "mfussenegger/nvim-lint",
  -- lazy = true,
  event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
  config = function()
    require("lint").linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      python = { "pydocstyle", "ruff", "mypy", "djlint" },
      json = { "jsonlint" },
      jsonc = { "jsonlint" },
      toml = { "taplo" },
      markdown = { "markdownlint" },
      -- yaml = { "yamllint" },
    }

    -- autocommand BufWritePost * lua require("lint").try_lint()
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>cl", function()
      require("lint").try_lint()
    end, { desc = "Lint file" })
  end,
}
