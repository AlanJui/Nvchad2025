-- nvim-cmp：在 htmldjango 檔案裡，讓 Django 樣板 snippet（內容含 {% ... %}）排在最前面
-- 其餘設定沿用 NvChad 預設（nvchad.configs.cmp）
local function is_django_entry(entry)
  local item = entry:get_completion_item()
  local text = (item.textEdit and item.textEdit.newText) or item.insertText or ""

  -- LuaSnip 來源：取出 snippet 本體來判斷
  if entry.source.name == "luasnip" and item.data and item.data.snip_id then
    local ok, snip = pcall(function()
      return require("luasnip").get_id_snippet(item.data.snip_id)
    end)
    if ok and snip then
      local ok2, doc = pcall(function()
        return snip:get_docstring()
      end)
      if ok2 and type(doc) == "string" then
        text = doc
      elseif ok2 and type(doc) == "table" then
        text = table.concat(doc, "\n")
      end
    end
  end

  return text:find("{%", 1, true) ~= nil
end

local function django_first(e1, e2)
  if vim.bo.filetype ~= "htmldjango" then
    return nil
  end
  local a, b = is_django_entry(e1), is_django_entry(e2)
  if a ~= b then
    return a
  end
  return nil
end

return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    local cmp = require "cmp"
    local compare = cmp.config.compare
    opts.sorting = opts.sorting or {}
    opts.sorting.priority_weight = opts.sorting.priority_weight or 2
    opts.sorting.comparators = {
      django_first,
      compare.offset,
      compare.exact,
      compare.score,
      compare.recently_used,
      compare.locality,
      compare.kind,
      compare.length,
      compare.order,
    }
    return opts
  end,
}
