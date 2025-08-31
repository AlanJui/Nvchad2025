-- Mermaid 預覽（WSL/Linux）：mmdc 轉 PNG，終端顯示（smart renderer：Kitty / SIXEL / ANSI）
-- 需求：
--   mmdc：npm i -g @mermaid-js/mermaid-cli
--   chafa：sudo apt install -y chafa
--   （可選）Kitty 或 WezTerm（有 SIXEL）
return {
  {
    "nvim-lua/plenary.nvim",
    enabled = function()
      return vim.loop.os_uname().sysname == "Linux"
    end,
    lazy = true,
    ft = { "mermaid", "markdown" },
    cmd = { "MermaidChafaFile", "MermaidChafaBlock", "MermaidOpenPNG" },
    keys = {
      { "<leader>mr", "<cmd>MermaidChafaFile<CR>", desc = "Mermaid: render current file (smart display)" },
      { "<leader>mb", "<cmd>MermaidChafaBlock<CR>", desc = "Mermaid: render fenced block (smart display)" },
      { "<leader>mo", "<cmd>MermaidOpenPNG<CR>", desc = "Mermaid: open last PNG via wslview" },
    },
    init = function()
      vim.filetype.add { extension = { mermaid = "mermaid" } }
      vim.g.mermaid_theme = vim.g.mermaid_theme or "default"
      vim.g.mermaid_background = vim.g.mermaid_background or "transparent"
      vim.g.mermaid_scale = vim.g.mermaid_scale or 1.0
      -- 如使用 WezTerm + SIXEL，可顯式覆寫：vim.g.mermaid_render_mode = "sixel"
      -- 也可選 "kitty" 或 "ansi"
    end,
    config = function()
      local fn, api, uv = vim.fn, vim.api, vim.loop

      local function stdcache()
        return fn.stdpath "cache" .. "/mermaid_chafa"
      end
      local function ensure_dir(p)
        fn.mkdir(p, "p")
      end
      local function sha(s)
        return tostring(fn.sha256(s)):sub(1, 12)
      end

      local function pick_mmdc()
        if fn.executable "mmdc" == 1 then
          return "mmdc"
        end
        if fn.executable "mmdc.cmd" == 1 then
          return "mmdc.cmd"
        end
        return nil
      end

      local function make_outfile(infile_or_key)
        local stem = fn.fnamemodify(infile_or_key, ":t:r")
        if stem == "" then
          stem = "unnamed"
        end
        local key = sha(infile_or_key)
        local out = stdcache() .. ("/" .. stem .. "_" .. key .. ".png")
        ensure_dir(stdcache())
        return out
      end

      -- 偵測終端能力
      local function detect_render_mode()
        if vim.g.mermaid_render_mode then
          return vim.g.mermaid_render_mode -- 使用者手動指定
        end
        local term = (os.getenv "TERM" or ""):lower()
        if term:find "kitty" and fn.executable "kitty" == 1 then
          return "kitty"
        end
        -- 簡單判斷 WezTerm（支援 SIXEL）
        if os.getenv "WEZTERM_EXECUTABLE" or os.getenv "WEZTERM_PANE" then
          return "sixel"
        end
        return "ansi" -- 預設：用 chafa 的 ANSI 近似
      end

      local function render_to_png_async(input_file, output_file, cb)
        cb = cb or function(_) end
        local mmdc = pick_mmdc()
        if not mmdc then
          vim.notify("找不到 mmdc，請先安裝：npm i -g @mermaid-js/mermaid-cli", vim.log.levels.ERROR)
          cb(false)
          return
        end

        local theme = tostring(vim.g.mermaid_theme)
        local bg = tostring(vim.g.mermaid_background)
        local scale = tostring(vim.g.mermaid_scale)

        local cmd = { mmdc, "-i", input_file, "-o", output_file, "-t", theme, "-b", bg, "-s", scale, "--quiet" }

        fn.jobstart(cmd, {
          stdout_buffered = true,
          stderr_buffered = true,
          on_exit = function(_, code)
            vim.schedule(function()
              if code == 0 and uv.fs_stat(output_file) then
                cb(true)
              else
                vim.notify("Mermaid 轉檔失敗（exit " .. tostring(code) .. "）", vim.log.levels.ERROR)
                cb(false)
              end
            end)
          end,
        })
      end

      -- 打開圖片（依終端能力選擇最佳方式）
      local function open_image_smart(png)
        local mode = detect_render_mode()

        if mode == "kitty" then
          -- 直接用 kitty 的 icat（品質最佳）
          fn.termopen { "bash", "-lc", ("kitty +kitten icat '%s'"):format(png) }
          return
        end

        if mode == "sixel" then
          -- WezTerm：用 chafa 輸出 SIXEL，畫質佳
          fn.termopen { "bash", "-lc", ("chafa --format=sixel '%s'"):format(png) }
          return
        end

        -- 否則用 ANSI 模式，但調參盡量清楚一點
        -- tips：把終端視窗放大、字型調小，會更清楚
        fn.termopen { "bash", "-lc", ("chafa --symbols=braille --dither=fs --stretch '%s'"):format(png) }
      end

      local last_png_for_current = nil

      local function current_file_preview()
        local infile = fn.expand "%:p"
        if infile == "" then
          local tmp = stdcache() .. "/__unsaved__.mermaid"
          ensure_dir(stdcache())
          fn.writefile(api.nvim_buf_get_lines(0, 0, -1, false), tmp)
          infile = tmp
        end
        if api.nvim_buf_get_option(0, "modified") then
          vim.cmd "silent write"
        end

        local outfile = make_outfile(infile)
        render_to_png_async(infile, outfile, function(ok)
          if ok then
            last_png_for_current = outfile
            -- 開一個浮窗承載 term（好關閉）
            local cols = api.nvim_get_option_value("columns", {})
            local lines = api.nvim_get_option_value("lines", {})
            local w = math.max(60, math.floor(cols * 0.7))
            local h = math.max(20, math.floor(lines * 0.7))
            local buf = api.nvim_create_buf(false, true)
            api.nvim_open_win(buf, true, {
              relative = "editor",
              width = w,
              height = h,
              row = math.floor((lines - h) / 2),
              col = math.floor((cols - w) / 2),
              style = "minimal",
              border = "rounded",
            })
            open_image_smart(outfile)
            api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>bd!<CR>", { noremap = true, silent = true })
          end
        end)
      end

      local function fenced_block_preview()
        local cur = api.nvim_win_get_cursor(0)[1] - 1
        local lines = api.nvim_buf_get_lines(0, 0, -1, false)
        local start_i, end_i = nil, nil

        for i = cur, 0, -1 do
          local l = lines[i + 1]
          if l and l:match "^%s*```%s*mermaid%s*$" then
            start_i = i + 2
            break
          end
        end
        if not start_i then
          vim.notify("游標不在 ```mermaid 區塊內", vim.log.levels.WARN)
          return
        end
        for i = start_i, #lines do
          local l = lines[i]
          if l and l:match "^%s*```%s*$" then
            end_i = i - 1
            break
          end
        end
        if not end_i or end_i < start_i then
          vim.notify("找不到 ``` 結束 fence", vim.log.levels.WARN)
          return
        end

        local block = {}
        for i = start_i, end_i do
          table.insert(block, lines[i])
        end

        local key = (fn.expand "%:p" ~= "" and fn.expand "%:p" or "__unsaved__") .. ":" .. start_i .. "-" .. end_i
        local infile = stdcache() .. ("/block_" .. sha(key) .. ".mermaid")
        ensure_dir(stdcache())
        fn.writefile(block, infile)

        local outfile = make_outfile(infile)
        render_to_png_async(infile, outfile, function(ok)
          if ok then
            last_png_for_current = outfile
            local cols = api.nvim_get_option_value("columns", {})
            local lines = api.nvim_get_option_value("lines", {})
            local w = math.max(60, math.floor(cols * 0.7))
            local h = math.max(20, math.floor(lines * 0.7))
            local buf = api.nvim_create_buf(false, true)
            api.nvim_open_win(buf, true, {
              relative = "editor",
              width = w,
              height = h,
              row = math.floor((lines - h) / 2),
              col = math.floor((cols - w) / 2),
              style = "minimal",
              border = "rounded",
            })
            open_image_smart(outfile)
            api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>bd!<CR>", { noremap = true, silent = true })
          end
        end)
      end

      api.nvim_create_user_command("MermaidChafaFile", current_file_preview, {})
      api.nvim_create_user_command("MermaidChafaBlock", fenced_block_preview, {})

      -- 外部用 Windows 檢視器開上一次輸出的 PNG（畫質完美）
      api.nvim_create_user_command("MermaidOpenPNG", function()
        if not last_png_for_current or fn.filereadable(last_png_for_current) ~= 1 then
          vim.notify("尚無輸出檔，請先執行 <leader>mr 或 <leader>mb", vim.log.levels.WARN)
          return
        end
        -- 在 WSL 用 wslview 呼叫 Windows 預設圖像檢視器
        fn.jobstart({ "wslview", last_png_for_current }, { detach = true })
      end, {})
    end,
  },
}
