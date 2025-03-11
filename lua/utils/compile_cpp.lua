local augroup = vim.api.nvim_create_augroup("AutoCppCompile", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = augroup,
  pattern = "*.cpp",
  callback = function()
    local filepath = vim.fn.expand "%:p"
    local filename = vim.fn.expand "%:t"
    local output = vim.fn.expand "%:p:r" .. ".exe"
    local cmd = { "g++", "-g", "-o", output, filepath }

    -- 開啟或重用一個新的終端 buffer 來顯示編譯結果
    vim.cmd "botright 10split | terminal"
    local term_buf = vim.api.nvim_get_current_buf()

    -- 清空終端 buffer 後再執行命令
    vim.fn.termopen(cmd, {
      stdout_buffered = true,
      stderr_buffered = true,
      on_exit = function(_, exit_code)
        local msg = exit_code == 0 and "✔️ 編譯成功：" .. filename or "❌ 編譯失敗：" .. filename
        vim.api.nvim_buf_set_lines(
          term_buf,
          0,
          1,
          false,
          { msg, "──────────────────────────" }
        )
      end,
    })

    -- 返回原始 buffer
    vim.cmd "wincmd p"
  end,
})
