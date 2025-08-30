-- Windows 專用：使用 Mermaid CLI (mmdc) 將 .mermaid 轉為圖片，再用系統預設檢視器開啟
-- 需求：npm i -g @mermaid-js/mermaid-cli
return {
  {
    "nvim-lua/plenary.nvim", -- 提供 jobstart 等工具
    enabled = function()
      return vim.loop.os_uname().sysname == "Windows_NT"
    end,
    lazy = true,
    ft = { "mermaid" },
    cmd = { "MermaidRender", "MermaidOpen", "MermaidClean" },
    keys = {
      {
        "<leader>mR",
        function()
          local file = vim.fn.expand "%:p"
          local out = vim.fn.expand "%:p:r" .. ".png"
          vim.fn.jobstart({ "mmdc", "-i", file, "-o", out }, {
            stdout_buffered = true,
            on_stdout = function(_, data)
              if data then
                vim.notify(table.concat(data, "\n"), vim.log.levels.INFO)
              end
            end,
            on_exit = function()
              vim.notify("Mermaid PNG generated: " .. out, vim.log.levels.INFO)
            end,
          })
        end,
        desc = "Export Mermaid to PNG (mmdc)",
      },
    },
    init = function()
      vim.filetype.add { extension = { mermaid = "mermaid" } }
    end,
    config = function()
      local fn, api, uv = vim.fn, vim.api, vim.loop

      local function stdcache()
        return fn.stdpath "cache" .. "/mermaid_previews"
      end
      local function ensure_dir(p)
        fn.mkdir(p, "p")
      end
      local function hash(s)
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

      local function current_inputs()
        local bufname = fn.expand "%:p"
        local buftype = api.nvim_buf_get_option(0, "buftype")
        if buftype ~= "" then
          return nil, "不是檔案緩衝區"
        end
        if bufname == "" then
          local tmp = stdcache() .. "/__unsaved__.mermaid"
          ensure_dir(stdcache())
          fn.writefile(api.nvim_buf_get_lines(0, 0, -1, false), tmp)
          return tmp
        else
          return bufname
        end
      end

      local function output_path(infile)
        local stem = fn.fnamemodify(infile, ":t:r")
        local ext = (vim.g.mermaid_format == "svg") and "svg" or "png"
        local key = hash(infile)
        local outdir = stdcache()
        ensure_dir(outdir)
        return string.format("%s/%s_%s.%s", outdir, stem, key, ext)
      end

      local function render_mermaid(opts)
        opts = opts or {}
        local mmdc = pick_mmdc()
        if not mmdc then
          vim.notify("找不到 mmdc，請先 npm i -g @mermaid-js/mermaid-cli", vim.log.levels.ERROR)
          return
        end

        local infile, err = current_inputs()
        if not infile then
          vim.notify(err, vim.log.levels.WARN)
          return
        end
        local outfile = output_path(infile)
        local theme = tostring(vim.g.mermaid_theme or "default")
        local bg = tostring(vim.g.mermaid_background or "transparent")
        local scale = tostring(vim.g.mermaid_scale or "1.0")

        if api.nvim_buf_get_option(0, "modified") then
          vim.cmd "silent write"
        end

        fn.jobstart({ mmdc, "-i", infile, "-o", outfile, "-t", theme, "-b", bg, "-s", scale, "--quiet" }, {
          stdout_buffered = true,
          stderr_buffered = true,
          on_exit = function(_, code)
            if code == 0 then
              vim.schedule(function()
                vim.notify("Mermaid Rendered → " .. outfile)
                if opts.open_after ~= false then
                  fn.jobstart({ "cmd", "/c", "start", "", outfile }, { detach = true })
                end
              end)
            else
              vim.schedule(function()
                vim.notify("Mermaid 渲染失敗 (exit " .. code .. ")", vim.log.levels.ERROR)
              end)
            end
          end,
        })
      end

      local function open_last()
        local infile = current_inputs()
        if not infile then
          return
        end
        local outfile = output_path(infile)
        if uv.fs_stat(outfile) then
          fn.jobstart({ "cmd", "/c", "start", "", outfile }, { detach = true })
        else
          vim.notify("沒有找到輸出檔，請先 :MermaidRender", vim.log.levels.WARN)
        end
      end

      local function clean_cache()
        local dir = stdcache()
        if uv.fs_stat(dir) then
          fn.jobstart({
            "powershell",
            "-NoProfile",
            "-Command",
            ("Remove-Item -Recurse -Force -ErrorAction SilentlyContinue '%s'; New-Item -ItemType Directory -Path '%s' | Out-Null"):format(
              dir,
              dir
            ),
          }, { detach = true })
          vim.notify("已清除預覽快取：" .. dir)
        end
      end

      api.nvim_create_user_command("MermaidRender", function()
        render_mermaid { open_after = true }
      end, {})
      api.nvim_create_user_command("MermaidOpen", function()
        open_last()
      end, {})
      api.nvim_create_user_command("MermaidClean", function()
        clean_cache()
      end, {})

      vim.keymap.set("n", "<leader>mr", "<cmd>MermaidRender<CR>", { desc = "Mermaid: Render & Open" })
      vim.keymap.set("n", "<leader>mO", "<cmd>MermaidOpen<CR>", { desc = "Mermaid: Open last output" })
      vim.keymap.set("n", "<leader>mC", "<cmd>MermaidClean<CR>", { desc = "Mermaid: Clean cache" })
    end,
  },
}
