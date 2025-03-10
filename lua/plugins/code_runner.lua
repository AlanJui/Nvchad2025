-- https://www.cyberciti.biz/faq/howto-compile-and-run-c-cplusplus-code-in-linux/
-- 【快速參考】
-- /home/user/project/demo.cpp
-- %     就是 /home/user/project/demo.cpp
-- %:t   就是 demo.cpp
-- %:r   就是 /home/user/project/demo
-- %:t:r 就是 demo
return {
  {
    "stevearc/overseer.nvim",
    -- enable = false,
    lazy = false,
    keys = {
      { "<leader>rr", ":OverseerRun<CR>", "Build by OverseerRun" },
    },
    config = function()
      local cmd_shell = { "cmd.exe", "/c" }
      local is_win_nt = vim.loop.os_uname().sysname == "Windows_NT"
      -- local cmd_shell = { "cmd.exe", "/c" }
      if is_win_nt then
        -- 偵測是否在 Git Bash 環境啟動 (檢查環境變數 MSYSTEM 是否存在)
        if vim.fn.getenv "MSYSTEM" ~= vim.NIL then
          -- cmd_shell = { "'C:/msys64/usr/bin/bash.exe'", "-c" }
          cmd_shell = { "bash.exe", "/c" }
        end
      end

      require("overseer").setup {
        -- cmd = vim.o.shell,
        -- cmd = { "bash", "/c" },
        -- cmd = { "cmd.exe", "/c" },
        cmd = cmd_shell,
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
      ----------------------------------------------------------
      -- C++ with g++
      ----------------------------------------------------------
      {
        "<leader>rgc",
        ':Run g++ -g -o "%:r.exe" "%"<CR>',
        desc = "Compile C++ source code with debug info (.exe)",
      },
      {
        "<leader>rgr",
        ':Run g++ "%:t" -o "%:t:r.exe" && "%:p:r.exe"<CR>',
        desc = "Compile and Run C++ file (.exe)",
      },
      -- -- g++ -g -o hello.exe hello.cpp
      -- {
      --   "<leader>rgc",
      --   ":Run g++ -g -o %:t:r.exe %:t<CR>",
      --   desc = "Compile C++ source code with debug info (.exe)",
      -- },
      -- -- g++ -g -o hello hello.cpp
      -- {
      --   "<leader>rgr",
      --   ":Run g++ %:t -o %:t:r.exe && ./%:t:r.exe<CR>",
      --   desc = "Compile and Run C++ file (.exe)",
      -- },
      ----------------------------------------------------------
      -- C++ with clang++
      ----------------------------------------------------------
      -- {
      --   "<leader>rgc",
      --   ":Run clang++ %:t -o %:t:r <CR>",
      --   desc = "Compile C++ source code with debug info",
      -- },
      -- {
      --   "<leader>rgm",
      --   ":Run make %:t:r <CR>",
      --   desc = "Make C++ object code",
      -- },
      -- {
      --   "<leader>rgr",
      --   ":Run g++ %:t -o %:t:r && ./%:t:r <CR>",
      --   desc = "Compile and Run C++ file",
      -- },
      {
        "<leader>rL",
        function()
          require("user.overseer_util").restart_last_task()
        end,
        desc = "Run last task",
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
      -- Lua Script
      {
        "<leader>rl",
        ":Run lua %<CR>",
        desc = "Run current lua file",
      },
      -- Python
      {
        "<leader>rpr",
        ":Run python %<CR>",
        desc = "Run current Python file",
      },
      {
        "<leader>rpl",
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
