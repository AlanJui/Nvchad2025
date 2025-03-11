--------------------------------------------------------------------
-- .cpp file compile and run
--------------------------------------------------------------------
local augroup = vim.api.nvim_create_augroup("AutoCppCompileRun", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = augroup,
  pattern = "*.cpp",
  callback = function()
    local filepath = vim.fn.expand "%:p"
    local filename = vim.fn.expand "%:t"
    local output = vim.fn.expand "%:p:r" .. ".exe"
    local compile_cmd = { "g++", "-g", "-o", output, filepath }

    -- 開啟底部終端視窗
    vim.cmd "botright 15split"
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_win_set_buf(0, buf)
    vim.diagnostic.disable(buf)

    -- 執行編譯指令
    vim.fn.termopen(compile_cmd, {
      on_exit = function(_, exit_code)
        local header_msg = exit_code == 0 and "✔️ 編譯成功：" .. filename or "❌ 編譯失敗：" .. filename
        vim.api.nvim_buf_set_lines(buf, 0, 0, false, { header_msg, ("─"):rep(40) })

        if exit_code == 0 then
          -- 明確透過 cmd.exe 執行程式
          vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "", "🚀 程式執行結果：" })
          vim.fn.termopen { "cmd.exe", "/c", output }
          -- vim.fn.termopen { "powershell.exe", "-NoProfile", "-ExecutionPolicy", "Bypass", "-Command", output }
        end
      end,
    })

    -- 回到原始視窗
    vim.cmd "wincmd p"
  end,
})
