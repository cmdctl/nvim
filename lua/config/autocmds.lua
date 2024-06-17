-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

require("config.autocmd.jest-test")
require("config.autocmd.go-test")

vim.cmd("autocmd FileType go nmap gtl :GoTestLineDiag<CR>")
vim.cmd("autocmd FileType dbui nmap <C-s><C-s> <Plug>(DBUI_ExecuteQuery)")

vim.cmd("autocmd FileType javascript,typescript,typescriptreact nmap <C-t> :JestTestsWatch<CR>")
vim.cmd("autocmd FileType javascript,typescript,typescriptreact nmap <C-t>s :JestTestsStop<CR>")

vim.cmd("autocmd FileType javascript,typescript,typescriptreact nmap <C-s>c :ConvertToTemplateString<CR>")

vim.cmd("autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni")

-- :set nofoldenable
vim.cmd("set nofoldenable")

vim.cmd("autocmd FileType sql setlocal omnifunc=vim_dadbod_completion#omni")
vim.cmd(
  "autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })"
)
