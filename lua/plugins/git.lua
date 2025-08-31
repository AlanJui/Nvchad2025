-----------------------------------------------------------
-- Git Tools
-----------------------------------------------------------
return {
  -- Neogit（只在 Linux/WSL 啟用；Windows 原生停用以避免 require 錯誤）
  {
    "NeogitOrg/neogit",
    -- enabled = function()
    --   return vim.loop.os_uname().sysname ~= "Windows_NT"
    -- end,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      -- 二選一就好；您已用 telescope，就留它
      "nvim-telescope/telescope.nvim",
      -- "ibhagwan/fzf-lua",
    },
    cmd = { "Neogit" },
    keys = {
      { "<leader>gn", "<cmd>Neogit<CR>", desc = "Neogit" },
    },
    opts = {
      integrations = { diffview = true },
      disable_commit_confirmation = true,
    },
    config = true,
  },

  -- Git Signs（兩邊都啟用）
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns
        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
        end
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>ghs", ":Gitsigns stage_hunk<CR>", "Stage Hunk")
        map({ "n", "v" }, "<leader>ghr", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Stage Buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Undo Stage Hunk")
        map("n", "<leader>ghR", gs.reset_buffer, "Reset Buffer")
        map("n", "<leader>ghp", gs.preview_hunk, "Preview Hunk")
        map("n", "<leader>ghb", function()
          gs.blame_line { full = true }
        end, "Blame Line")
        map("n", "<leader>ghd", gs.diffthis, "Diff This")
        map("n", "<leader>ghD", function()
          gs.diffthis "~"
        end, "Diff This ~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },

  -- Diffview（兩邊都啟用）
  {
    "sindrets/diffview.nvim",
    config = function()
      local actions = require "diffview.actions"
      require("diffview").setup {
        diff_binaries = false,
        enhanced_diff_hl = false,
        use_icons = true,
        icons = { folder_closed = "", folder_open = "" },
        view = {
          default = { layout = "diff2_horizontal", winbar_info = false },
          merge_tool = { layout = "diff3_horizontal", disable_diagnostics = true, winbar_info = true },
          file_history = { layout = "diff2_horizontal", winbar_info = false },
        },
        file_panel = {
          listing_style = "tree",
          tree_options = { flatten_dirs = true, folder_statuses = "only_folded" },
          win_config = { position = "left", width = 35 },
        },
        keymaps = {
          disable_defaults = false,
          view = {
            { "n", "<tab>", actions.select_next_entry, { desc = "Next file" } },
            { "n", "<s-tab>", actions.select_prev_entry, { desc = "Prev file" } },
            { "n", "gf", actions.goto_file_edit, { desc = "Open file in previous tabpage" } },
            { "n", "<leader>e", actions.focus_files, { desc = "Focus file panel" } },
            { "n", "<leader>b", actions.toggle_files, { desc = "Toggle file panel" } },
          },
        },
      }
    end,
  },

  -- Fugitive（兩邊都啟用，可當備援）
  { "tpope/vim-fugitive" },
}
