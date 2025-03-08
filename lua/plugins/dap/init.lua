return {
  -- 常用程式語言 DAP
  { "jbyuki/one-small-step-for-vimkind" },
  { "mfussenegger/nvim-dap-python" },
  { "mxsdev/nvim-dap-vscode-js" },
  -- 需請 mason 安裝的 DAP for Neovim
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      require("mason-nvim-dap").setup {
        handers = {},
        ensure_installed = {
          "python",
          "codelldb",
          "js",
          "stylua",
        },
      }
    end,
  },
  -- virtual text for the debugger
  {
    "theHamsta/nvim-dap-virtual-text",
    opts = {},
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      {
        "<leader>du",
        function()
          require("dapui").toggle {}
        end,
        desc = "Dap UI",
      },
      {
        "<leader>de",
        function()
          require("dapui").eval()
        end,
        desc = "Eval",
        mode = { "n", "v" },
      },
    },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        -- dapui.open { reset = true }
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  {
    "jbyuki/one-small-step-for-vimkind",
    dependencies = "mfussenegger/nvim-dap",
    lazy = false,
    keys = {
      {
        "<leader>daL",
        function()
          require("osv").launch { port = 8086 }
        end,
        desc = "Start Lua Language Server",
      },
      {
        "<leader>dal",
        function()
          require("osv").run_this()
        end,
        desc = "Start Lua Debugging",
      },
    },
    config = function()
      -- DAP for Lua work in Neovim
      require "plugins.dap.adapters.lua"
    end,
  },
  -- DAP
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>dB",
        function()
          require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
        end,
        desc = "Breakpoint Condition",
      },
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Continue",
      },
      {
        "<leader>dC",
        function()
          require("dap").run_to_cursor()
        end,
        desc = "Run to Cursor",
      },
      {
        "<leader>dg",
        function()
          require("dap").goto_()
        end,
        desc = "Go to line (no execute)",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "Step Into",
      },
      {
        "<leader>dj",
        function()
          require("dap").down()
        end,
        desc = "Down",
      },
      {
        "<leader>dk",
        function()
          require("dap").up()
        end,
        desc = "Up",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "Run Last",
      },
      {
        "<leader>do",
        function()
          require("dap").step_out()
        end,
        desc = "Step Out",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_over()
        end,
        desc = "Step Over",
      },
      {
        "<leader>dp",
        function()
          require("dap").pause()
        end,
        desc = "Pause",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "Toggle REPL",
      },
      {
        "<leader>ds",
        function()
          require("dap").session()
        end,
        desc = "Session",
      },
      {
        "<leader>dt",
        function()
          require("dap").terminate()
        end,
        desc = "Terminate",
      },
      {
        "<leader>dw",
        function()
          require("dap.ui.widgets").hover()
        end,
        desc = "Widgets",
      },
      -- Python adapter
      {
        "<leader>daP",
        function()
          require("dap-python").test_method()
          require("core.utils").load_mappings "dap_python"
        end,
        desc = "Start Python Debugger Server",
      },
      {
        "<leader>dap",
        function()
          require("dap-python").test_class()
        end,
        desc = "Launch Python Code",
      },
    },
    config = function()
      -- Setup DAP Environment
      local icons = require "configs.icons"
      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

      for name, sign in pairs(icons.dap) do
        sign = type(sign) == "table" and sign or { sign }
        vim.fn.sign_define("Dap" .. name, {
          text = sign[1],
          texthl = sign[2] or "DiagnosticInfo",
          linehl = sign[3],
          numhl = sign[3],
        })
      end

      -- Setup DAP for JS/TS
      require "plugins.dap.adapters.javascript"
      -- DAP for Python
      require "plugins.dap.adapters.python"
      -- DAP for codelldb: LLVM (Clang) C++ (cl.exe)
      require "plugins.dap.adapters.codelldb"
      -- DAP for cpptools (Visual Studio 2022) C++ (cl.exe)/ MinGW-w64 (gcc/g++)
      require "plugins.dap.adapters.cpptools"
    end,
  },
}
