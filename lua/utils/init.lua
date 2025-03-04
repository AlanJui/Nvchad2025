local M = {}
local merge_tb = vim.tbl_deep_extend

-- local function default_on_open(term)
--   vim.cmd "stopinsert"
--   vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
-- end

M.load_config = function()
  local config = require "configs.default_config"
  -- local chadrc_path = vim.api.nvim_get_runtime_file("lua/custom/chadrc.lua", false)[1]
  --
  -- if chadrc_path then
  --   local chadrc = dofile(chadrc_path)
  --
  --   config.mappings = M.remove_disabled_keys(chadrc.mappings, config.mappings)
  --   config = merge_tb("force", config, chadrc)
  --   config.mappings.disabled = nil
  -- end

  return config
end

M.load_mappings = function(section, mapping_opt)
  vim.schedule(function()
    -- 定義一個設置映射的函數
    local function set_section_map(section_values)
      if section_values.plugin then
        return
      end

      section_values.plugin = nil

      -- 遍歷不同的按鍵映射模式（例如：普通模式、插入模式等）
      for mode, mode_values in pairs(section_values) do
        -- 合併默認選項（default_opts）和用戶提供的選項（mapping_info.opts）
        local default_opts = merge_tb("force", { mode = mode }, mapping_opt or {})
        for keybind, mapping_info in pairs(mode_values) do
          -- 合併默認選項（default_opts）和用戶提供的選項（mapping_info.opts）
          local opts = merge_tb("force", default_opts, mapping_info.opts or {})

          -- 移除掉原來的 opts，以及 mode 屬性，然後設置描述（desc）
          mapping_info.opts, opts.mode = nil, nil
          opts.desc = mapping_info[2]

          -- 設置按鍵映射
          vim.keymap.set(mode, keybind, mapping_info[1], opts)
        end
      end
    end

    -- 從 core.utils 模塊中加載映射配置
    local mappings = require("utils").load_config().mappings
    -- local mappings = require("config.default_mappings")
    -- require("utils.table").print_table(mappings)

    -- 如果 section 是字符串，則將映射配置中的 "plugin" 移除，並將配置轉換為一個數組（table）
    if type(section) == "string" then
      mappings[section]["plugin"] = nil
      mappings = { mappings[section] }
    end

    -- 遍歷映射配置，並設置映射
    for _, sect in pairs(mappings) do
      set_section_map(sect)
    end
  end)
end

M.lazy_load = function(plugin)
  vim.api.nvim_create_autocmd({ "BufRead", "BufWinEnter", "BufNewFile" }, {
    group = vim.api.nvim_create_augroup("BeLazyOnFileOpen" .. plugin, {}),
    callback = function()
      local file = vim.fn.expand "%"
      local condition = file ~= "NvimTree_1" and file ~= "[lazy]" and file ~= ""

      if condition then
        vim.api.nvim_del_augroup_by_name("BeLazyOnFileOpen" .. plugin)

        -- dont defer for treesitter as it will show slow highlighting
        -- This deferring only happens only when we do "nvim filename"
        if plugin ~= "nvim-treesitter" then
          vim.schedule(function()
            require("lazy").load { plugins = plugin }

            if plugin == "nvim-lspconfig" then
              vim.cmd "silent! do FileType"
            end
          end, 0)
        else
          require("lazy").load { plugins = plugin }
        end
      end
    end,
  })
end
-----------------------------------------------------------------------
-- Libs From LazyVim
-----------------------------------------------------------------------
M.root_patterns = { ".git", "lua" }

local function default_on_open(term)
  vim.cmd "stopinsert"
  vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
end

function M.open_term(cmd, opts)
  opts = opts or {}
  opts.size = opts.size or vim.o.columns * 0.5
  opts.direction = opts.direction or "float"
  opts.on_open = opts.on_open or default_on_open
  opts.on_exit = opts.on_exit or nil

  local Terminal = require("toggleterm.terminal").Terminal
  local new_term = Terminal:new {
    cmd = cmd,
    dir = "git_dir",
    auto_scroll = false,
    close_on_exit = false,
    start_in_insert = false,
    on_open = opts.on_open,
    on_exit = opts.on_exit,
  }
  new_term:open(opts.size, opts.direction)
end

function M.quit()
  local bufnr = vim.api.nvim_get_current_buf()
  local buf_windows = vim.call("win_findbuf", bufnr)
  local modified = vim.api.nvim_buf_get_option(bufnr, "modified")
  if modified and #buf_windows == 1 then
    vim.ui.input({
      prompt = "You have unsaved changes. Quit anyway? (y/n) ",
    }, function(input)
      if input == "y" then
        vim.cmd "qa!"
      end
    end)
  else
    vim.cmd "qa!"
  end
end

function M.find_files()
  local opts = {}
  local telescope = require "telescope.builtin"

  local ok = pcall(telescope.git_files, opts)
  if not ok then
    telescope.find_files(opts)
  end
end

function M.reload_module(name)
  require("plenary.reload").reload_module(name)
end

function M.has(plugin)
  return require("lazy.core.config").plugins[plugin] ~= nil
end

--- Attempt to require
--- @param modname string
--- @return table|nil
function M.require_or_nil(modname)
  local ok, module = pcall(require, modname)
  if ok then
    return module
  end
  vim.notify('failed: require("' .. modname .. '")', vim.log.levels.ERROR)
end

return M
