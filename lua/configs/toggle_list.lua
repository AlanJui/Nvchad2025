-- toggle_list.lua
-- This module provides a function to toggle the visibility of list characters in Neovim.
local M = {}

M.toggle_list = function()
  if vim.opt.list:get() then
    vim.opt.list = false
    vim.notify("Control characters hidden (list = off)", vim.log.levels.INFO)
  else
    vim.opt.list = true
    vim.opt.listchars = {
      tab = "»·",
      trail = "·",
      extends = ">",
      precedes = "<",
    }
    vim.notify("Control characters shown (list = on)", vim.log.levels.INFO)
  end
end

return M
