-- https://www.cyberciti.biz/faq/howto-compile-and-run-c-cplusplus-code-in-linux/
return {
  {
    "stevearc/overseer.nvim",
    -- enable = false,
    lazy = false,
    keys = {
      { "<leader>rr", ":OverseerRun<CR>", "Build by OverseerRun" },
    },
    config = function()
      require("overseer").setup {
        templates = { "builtin", "user.cpp_build" },
        -- templates = { "builtin", "user.run_script" },
      }
    end,
  },
  {
    "pianocomposer321/officer.nvim",
    dependencies = "stevearc/overseer.nvim",
    -- enable = false,
    lazy = false,
    keys = {
      {
        "<leader>rL",
        function()
          require("user.overseer_util").restart_last_task()
        end,
        "Run last task",
      },
      -- Tools for Run Time
      { "<leader>rk", ":Run npx kill-port 8000<CR>", desc = "Kill Port" },
      -- C
      {
        "<leader>rcc",
        ":Run gcc %:t -o %:t:r <CR>",
        desc = "Compile C source code",
      },
      {
        "<leader>rcm",
        ":Run make %:t:r <CR>",
        desc = "Make C object code",
      },
      {
        "<leader>rcr",
        ":Run gcc %:t -o %:t:r && ./%:t:r <CR>",
        desc = "Compile and Run C file",
      },
      -- C++
      -- ":Run clang++ %:t -o %:t:r <CR>",
      {
        "<leader>rgc",
        ":Run g++ -g %:t -o %:t:r <CR>",
        desc = "Compile C++ source code with debug info",
      },
      {
        "<leader>rgm",
        ":Run make %:t:r <CR>",
        desc = "Make C++ object code",
      },
      {
        "<leader>rgr",
        ":Run g++ %:t -o %:t:r && ./%:t:r <CR>",
        desc = "Compile and Run C++ file",
      },
      -- Lua Script
      {
        "<leader>rl",
        ":Run lua %<CR>",
        desc = "Run current lua file",
      },
      -- Python
      {
        "<leader>rpp",
        ":Run python %<CR>",
        desc = "Run current Python file",
      },
      {
        "<leader>rpk",
        ":Run ruff %<CR>",
        desc = "Lint current file",
      },
      -- Django
      { "<leader>rdr", ":Run poetry run python manage.py runserver<CR>", desc = "Runserver" },
      {
        "<leader>rdR",
        ":Run poetry run python manage.py runserver --noreload<CR>",
        "Runserver --noreload",
      },
      { "<leader>rdS", ":Run poetry run python manage.py shell<CR>", desc = "Django Shell" },
      {
        "<leader>rds",
        ":Run poetry run python manage.py createsuperuser<CR>",
        "Create super user",
      },
      {
        "<leader>rdc",
        ":Run echo yes | poetry run python manage.py collectstatic --noinput<CR>",
        desc = "Collect all static files",
      },
      {
        "<leader>rdm",
        ":Run poetry run python manage.py makemigrations<CR>",
        desc = "Update DB schema",
      },
      { "<leader>rdM", ":Run poetry run python manage.py migrate<CR>", desc = "Migrate DB" },
    },
    config = function()
      require("officer").setup {
        create_mappings = true,
        components = { "user.track_history" },
      }
      vim.keymap.set(
        "n",
        "<leader><CR>",
        require("user.overseer_util").restart_last_task,
        { desc = "Restart Last Task" }
      )
    end,
  },
}
