return{
  "cdelledonne/vim-cmake",
  event = "VeryLazy",
  config = function ()
    vim.g.cmake_link_compile_commands = 1
    local keymap = vim.keymap
    keymap.set("n", "<leader>cg", ":CMakeGenerate<CR>", { desc = "Run :CMakeGenerate" })
    keymap.set("n", "<leader>cb", ":CMakeBuild<CR>", { desc = "Run :CMakeBuild" })
    keymap.set("n", "<leader>cq", ":CMakeClose<CR>", { desc = "Close CMake console window" })
  end,
}
