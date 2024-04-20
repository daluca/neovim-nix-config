local key = vim.keymap
local telescope = require("telescope.builtin")

key.set("n", "<leader>ff", telescope.find_files, {})
key.set("n", "<leader>fg", telescope.live_grep, {})
