-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.g.snacks_animate = false
local opt = vim.opt
opt.wrap = true
vim.lsp.inlay_hint.enable(false)
vim.g.UltiSnipsSnippetDirectories = { "/home/lqz/.config/nvim/UltiSnips" }
