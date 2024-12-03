-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("t", "<A-j>", "<cmd>close<cr>", { desc = "Hide Terminal" })
vim.keymap.del("n", "S")

-- floating terminal
map("n", "<leader>fT", function()
  Snacks.terminal()
end, { desc = "Terminal (cwd)" })

map("n", "<leader>ft", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })

map("n", "<A-j>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root(), win = { position = "float" } })
end, { desc = "Terminal (Root Dir)" })

map("n", "<c-/>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "Terminal (Root Dir)" })

map("n", "<c-_>", function()
  Snacks.terminal(nil, { cwd = LazyVim.root() })
end, { desc = "which_key_ignore" })

-- Terminal Mappings
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

map(
  "n",
  "<C-s><C-w>",
  ":lua require'telescope.builtin'.grep_string({ search = vim.fn.expand('<cword>') })<cr>",
  { desc = "Search word under cursor" }
)
map("n", "<C-e>", "<cmd>e .env<cr>", { desc = "Open .env file" })

map("n", "<C-b>", "<cmd>DBUIToggle<cr>", { desc = "DBUI" })

map("n", "<C-s><C-e>", "<cmd>Dotenv .env<cr>", { desc = "Source .env file" })

map("n", "<leader>rg", "<cmd>GptRun<cr>", { desc = "Execute the current buffer as a ChatGPT request" })
map("n", "<leader>rc", "<cmd>GptChat<cr>", { desc = "Open new chatgpt buffer" })

map("n", "<leader>rh", "<cmd>Httpx<cr>", { desc = "Execute Httpx request" })
map("n", "<leader>to", "<cmd>JsonScratchBuffer<cr>", { desc = "Open json buffer" })
map("n", "<leader>tt", "<cmd>JsonToTypescript<cr>", { desc = "Convert json to typescript interface" })
map("n", "<leader>tp", "<cmd>JsonToPython<cr>", { desc = "Convert json to python typedef" })
map("n", "<leader>tg", "<cmd>JsonToGoStruct<cr>", { desc = "Convert json to golang struct" })
map("n", "<leader>tz", "<cmd>JsonToZod<cr>", { desc = "Convert json to zod schema" })
map("n", "<leader>ty", "<cmd>JsonToYaml<cr>", { desc = "Convert json to yaml" })
map("n", "<leader>tjs", "<cmd>YamlToJson<cr>", { desc = "Convert yaml to json" })
map("n", "<leader>tja", "<cmd>JsonToJava<cr>", { desc = "Convert json to java DTO" })

map("n", "<leader>oo", "<cmd>TicketCreate<cr>", { desc = "Create devops ticket" })
map("n", "<leader>ot", "<cmd>TicketOpen<cr>", { desc = "Open devops ticket" })

map("n", "<leader>jtr", "<cmd>JavaRunSingleTest<cr>", { desc = "Run JavaRunSingleTest" })
map("n", "<leader>jtc", "<cmd>JavaRunClass<cr>", { desc = "Run JavaRunClass" })
map("n", "<leader>jte", "<cmd>JavaRerunTest<cr>", { desc = "Run JavaRerunTest" })
