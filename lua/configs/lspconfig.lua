local configs = require "nvchad.configs.lspconfig"

local servers = {
  cssls = {},
  vuels = {},
  tailwindcss = {},
  marksman = {},
  ts_ls = {},
  lua_ls = {
    settings = {
      Lua = {
        workspace = {
          checkThirdParty = false,
        },
        completion = {
          callSnippet = "Replace",
        },
        diagnostics = {
          globals = { "vim", "hs", "use", "log" },
        },
      },
    },
  },
  pylsp = {
    settings = {
      pylsp = {
        pycodestyle = {
          ignore = { "W391" },
          maxLineLength = 100,
        },
      },
    },
  },
  yamlls = {
    filetypes = {
      "yaml",
      "yaml.docker-compose",
    },
    settings = {
      yaml = {
        schemas = {
          ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
          -- ["../path/relative/to/file.yml"] = "/.github/workflows/*",
          -- ["/path/from/root/of/project"] = "/.github/workflows/*",
        },
      },
    },
  },
  html = {
    filetypes = {
      "html",
      "htmldjango",
    },
  },
  emmet_ls = {
    filetypes = {
      "html",
      "htmldjango",
      "typescriptreact",
      "javascriptreact",
      "vue",
      "css",
      "sass",
      "scss",
      "less",
      "svelte",
    },
  },
  jsonls = {
    filetypes = {
      "json",
      "jsonc",
    },
  },
  lemminx = {
    filetypes = { "xml", "xsd", "xsl", "xslt", "svg" },
  }
}

for name, opts in pairs(servers) do
  opts.on_init = configs.on_init
  opts.on_attach = configs.on_attach
  opts.capabilities = configs.capabilities

  require("lspconfig")[name].setup(opts)
end
