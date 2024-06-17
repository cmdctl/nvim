
local M = {}

M.state = {}

M.execute = function()
  local curr_buf = vim.api.nvim_get_current_buf()

  local lines = vim.api.nvim_buf_get_lines(curr_buf, 0, -1, false)
  vim.api.nvim_buf_set_lines(curr_buf, 0, -1, false, {})

  local append_data = function(_, data, _)
    vim.api.nvim_buf_set_lines(curr_buf, -1, -1, false, data)
  end

  local jobid = vim.fn.jobstart("conv json ts", {
    stdout_buffered = false,
    on_stdout = append_data,
    on_stderr = append_data,
    on_exit = function(_, code, _)
      if code == 0 then
        vim.api.nvim_buf_set_option(curr_buf, 'filetype', 'typescript')
      end
    end,
  })
  vim.fn.chansend(jobid, lines)
  vim.fn.chanclose(jobid, "stdin")
end

local function open_scratch_buffer()
  vim.api.nvim_command('enew')
  vim.api.nvim_buf_set_option(0, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(0, 'swapfile', false)
  vim.api.nvim_buf_set_option(0, 'filetype', 'json')
end

vim.api.nvim_create_user_command('JsonToTypescript', M.execute, { nargs = 0 })
vim.api.nvim_create_user_command('JsonScratchBuffer', open_scratch_buffer, { nargs = 0 })

return M
