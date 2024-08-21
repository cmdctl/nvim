local M = {}

local groupname = "gotest_autorun"
local inlinegorupname = "gotest_inline"
local ns = vim.api.nvim_create_namespace("gotest")

M.groupname = groupname
M.inlinegorupname = inlinegorupname
M.ns = ns

M.watch_tests = function()
  local bufnr = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(bufnr, "buftype", "nofile")
  vim.api.nvim_buf_set_option(bufnr, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(bufnr, "swapfile", false)
  vim.api.nvim_command("vsplit | b" .. bufnr)
  return function()
    local filepath = vim.api.nvim_buf_get_name(0)
    local parent_dir = vim.fn.fnamemodify(filepath, ":h")
    local append_data = function(_, data, _)
      if data then
        vim.api.nvim_buf_set_lines(bufnr, -1, -1, false, data)
      end
    end
    -- clear the buffer before running tests again
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "Running tests... in ", parent_dir })
    vim.fn.jobstart("go test -v " .. parent_dir .. "/...", {
      stdout_buffered = true,
      on_stdout = append_data,
      on_stderr = append_data,
    })
  end
end


local make_key = function(entry)
  assert(entry.Package, "Must have package: " .. vim.inspect(entry))
  assert(entry.Test, "Must have test: " .. vim.inspect(entry))
  return string.format("%s/%s", entry.Package, entry.Test)
end

local find_test_line = function(bufnr, test_name)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  for i, line in ipairs(lines) do
    if line:find(test_name) then
      return i - 1
    end
  end
end

local add_golang_test = function(state, entry)
  if not state.tests then
    state.tests = {}
  end
  local key = make_key(entry)
  state.tests[key] = {
    name = entry.Test,
    line = find_test_line(state.bufnr, entry.Test),
    output = {},
  }
end

local add_golang_output = function(state, entry)
  assert(state.tests, vim.inspect(state))
  table.insert(state.tests[make_key(entry)].output, vim.trim(entry.Output))
end

local mark_success = function(state, entry)
  assert(state.tests, vim.inspect(state))
  state.tests[make_key(entry)].success = entry.Action == "pass"
end

local state = {
  tests = {},
}

M.go_tests_diagnostics = function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

  state.bufnr = bufnr
  state.tests = {}

  local filepath = vim.api.nvim_buf_get_name(0)
  local parent_dir = vim.fn.fnamemodify(filepath, ":h")
  local append_data = function(_, data, _)
    if not data then
      return
    end
    for _, line in ipairs(data) do
      if line ~= "" then
        local decoded = vim.fn.json_decode(line)
        if not decoded then
          return
        end
        if decoded.Action == "run" then
          if not decoded.Test then
            return
          end
          add_golang_test(state, decoded)
        elseif decoded.Action == "output" then
          if not decoded.Test then
            return
          end
          add_golang_output(state, decoded)
        elseif decoded.Action == "pass" or decoded.Action == "fail" then
          if not decoded.Test then
            return
          end
          mark_success(state, decoded)
          local test = state.tests[make_key(decoded)]
          if test.success then
            local text = { "✅" }
            if test.line then
              vim.api.nvim_buf_set_extmark(state.bufnr, ns, test.line, 0, {
                virt_text = { text },
              })
            end
          end
        elseif decoded.Action == "pause" or decoded.Action == "start" or decoded.Action == "cont" then
          -- ignore
        else -- unknown
          print("Unknown action: " .. vim.inspect(decoded))
        end
      end
    end
  end
  vim.fn.jobstart("go test -v " .. parent_dir .. "/... -json", {
    stdout_buffered = true,
    on_stdout = append_data,
    on_stderr = append_data,
    on_exit = function()
      local failed = {}
      for _, test in pairs(state.tests) do
        if test.line then
          if not test.success then
            table.insert(failed, {
              bufnr = state.bufnr,
              lnum = test.line,
              col = 0,
              severity = vim.diagnostic.severity.ERROR,
              source = "go-test",
              code = "ERROR",
              message = "Test failed",
              user_data = {}
            })
          end
        end
      end
      vim.api.nvim_buf_create_user_command(state.bufnr, "GoTestLineDiag", function()
        local line = vim.fn.line(".") - 1
        for _, test in pairs(state.tests) do
          if test.line == line then
            if state.output_buf and vim.api.nvim_buf_is_valid(state.output_buf) then
              vim.api.nvim_buf_set_lines(state.output_buf, 0, -1, false, {})
              vim.api.nvim_buf_set_lines(state.output_buf, 0, -1, false, test.output)
            else
              local buffer = vim.api.nvim_create_buf(false, true)
              state.output_buf = vim.fn.bufnr(buffer)
              vim.api.nvim_buf_set_lines(buffer, 0, -1, false, test.output)
              vim.api.nvim_buf_set_option(buffer, "buftype", "nofile")
              vim.api.nvim_buf_set_option(buffer, "bufhidden", "wipe")
              vim.api.nvim_buf_set_option(buffer, "swapfile", false)
              vim.api.nvim_command("vsplit | b" .. buffer)
            end
          end
        end
      end, {})
      vim.diagnostic.set(ns, bufnr, failed, {})
    end
  })
end

return M
