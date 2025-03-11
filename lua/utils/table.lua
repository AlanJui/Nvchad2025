-- lua/utils/table.lua
local M = {}

function M.to_string(tbl, indent)
  indent = indent or 0
  local str = ""
  local prefix = string.rep("  ", indent)

  if type(tbl) ~= "table" then
    return tostring(tbl)
  end

  str = str .. "{\n"
  for k, v in pairs(tbl) do
    local key
    if type(k) == "string" then
      key = string.format("%q", k)
    else
      key = "[" .. tostring(k) .. "]"
    end

    if type(v) == "table" then
      str = str .. prefix .. "  " .. key .. " = " .. M.to_string(v, indent + 1) .. ",\n"
    else
      if type(v) == "string" then
        v = string.format("%q", v)
      else
        v = tostring(v)
      end
      str = str .. prefix .. "  " .. key .. " = " .. v .. ",\n"
    end
  end
  str = str .. prefix .. "}"
  return str
end

return M
