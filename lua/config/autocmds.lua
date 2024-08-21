-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

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


local gotest = require("user.go-test")

vim.api.nvim_create_user_command("GoTestsWatch", function()
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup(gotest.groupname, { clear = true }),
    pattern = "*.go",
    callback = gotest.watch_tests(),
  })
end, {})

vim.api.nvim_create_user_command("GoTestsStop", function()
  vim.api.nvim_create_augroup(gotest.groupname, { clear = true })
end, {})

vim.api.nvim_create_user_command("GoTestsDiagnostics", function()
  vim.api.nvim_create_augroup(gotest.inlinegorupname, { clear = true })
end, {})

vim.api.nvim_create_autocmd({"BufWritePost", "BufEnter"}, {
  group = vim.api.nvim_create_augroup(gotest.inlinegorupname, { clear = true }),
  pattern = "*_test.go",
  callback = gotest.go_tests_diagnostics,
})


local jesttest = require("user.jest-test")

vim.api.nvim_create_user_command("JestTestsWatch", function()
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup(jesttest.groupname, { clear = true }),
    pattern = { "*.ts", "*.tsx" },
    callback = jesttest.debaunce(jesttest.watch_tests(), 2000),
  })
end, {})

vim.api.nvim_create_user_command("JestTestsStop", function()
  vim.api.nvim_create_augroup(jesttest.groupname, { clear = true })
end, {})
