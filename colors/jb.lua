-- Reset to clear any existing highlights
vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

vim.o.termguicolors = true
vim.g.colors_name = "jb"

-- Load and apply the color scheme
require("jb").load()
