local M = {
  last_test = nil,
  bufnr = nil,
}

M.append_data = function(bufnr)
  return function(_, data, _)
    if data then
      vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
    end
  end
end

M.get_buffer = function()
  if M.bufnr and vim.api.nvim_buf_is_valid(M.bufnr) then
    return M.bufnr
  end
  M.bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(M.bufnr, "buftype", "nofile")
  vim.api.nvim_buf_set_option(M.bufnr, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(M.bufnr, "swapfile", false)
  vim.api.nvim_command("split | b" .. M.bufnr)
  return M.bufnr
end

M.rerun_test = function()
  if M.last_test then
    local bufnr = M.get_buffer()
    vim.fn.jobstart(M.last_test, {
      stdout_buffered = true,
      on_stdout = M.append_data(bufnr),
      on_stderr = M.append_data(bufnr),
    })
  end
end

M.run_class = function()
  -- get current file name
  local file_name = vim.fn.expand('%:t:r')

  local bufnr = M.get_buffer()
  local cmd = "./mvnw clean test -Dtest=" .. file_name
  M.last_test = cmd

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = M.append_data(bufnr),
    on_stderr = M.append_data(bufnr),
  })
end


M.run_test = function()
  -- get current file name
  local file_name = vim.fn.expand('%:t:r')

  -- get word under cursor
  local word = vim.fn.expand('<cword>')

  local bufnr = M.get_buffer()
  local cmd = "./mvnw clean test -Dtest=" .. file_name .. "#" .. word
  M.last_test = cmd

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = M.append_data(bufnr),
    on_stderr = M.append_data(bufnr),
  })
end

vim.api.nvim_create_user_command('JavaRunSingleTest', M.run_test, { nargs = 0 })
vim.api.nvim_create_user_command('JavaRunClass', M.run_class, { nargs = 0 })
vim.api.nvim_create_user_command('JavaRerunTest', M.rerun_test, { nargs = 0 })
return M
