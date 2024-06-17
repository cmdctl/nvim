-- ~/.config/nvim/lua/plugins/snip.lua
vim.print(vim.fn.stdpath("config"))
return {
  {
    "garymjr/nvim-snippets",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    opts = {
      global = { "all", "global" },
      create_cmp_source = true,
      friendly_snippets = true,
      search_paths = {
        vim.fn.stdpath("config") .. "/snippets",
      },
    },
  },
}
