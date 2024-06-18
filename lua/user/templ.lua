
local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.templ = {
  install_info = {
    url = "https://github.com/vrischmann/tree-sitter-templ.git", -- local path or git repo
    files = {"src/parser.c", "src/scanner.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
    -- optional entries:
    branch = "master", -- default branch in case of git repo if different from master
    generate_requires_npm = false, -- if stand-alone parser without npm dependencies
    requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
  },
}

-- additional filetypes
vim.filetype.add({
 extension = {
  templ = "templ",
 },
})

