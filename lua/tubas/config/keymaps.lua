-- set leader key to space
vim.g.mapleader = " "

-- code format
vim.keymap.set("n", "cf", vim.lsp.buf.format, { desc = "Format code" })

-- clear search highlights
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
