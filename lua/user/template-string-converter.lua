local ts_utils = require("nvim-treesitter.ts_utils")

local M = {}

M.convert = function ()
  local node = ts_utils.get_node_at_cursor()
  if node == nil then
    return
  end
  print(vim.inspect(node:type()))
  if node:type() ~= "string_fragment" then
    return
  end

  -- convert the node to template_literal
  local start_row, start_col, end_row, end_col = node:range()
  local buf = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(buf, start_row, end_row + 1, false)
  local line = lines[1]
  local str = line:sub(start_col, end_col + 1)
  if str:find("${") or str:find("}") then
    local new_line = line:sub(1, start_col - 1) .. "`" .. line:sub(start_col + 1, end_col) .. "`" .. line:sub(end_col + 2)
    lines[1] = new_line
    vim.api.nvim_buf_set_lines(buf, start_row, end_row + 1, false, lines)
  end
end

vim.api.nvim_create_user_command('ConvertToTemplateString', M.convert, { nargs = 0 })
return M
