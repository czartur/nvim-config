return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()

      local on_attach = function(_, bufnr)
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, {
            buffer = bufnr,
            noremap = true,
            silent = true,
            desc = desc,
          })
        end

        map("n", "gR", "<cmd>Telescope lsp_references<CR>", "Show references")
        map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
        map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", "Go to definition")
        map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", "Go to implementation")
        map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", "Go to type definition")
        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Show code actions")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "Show buffer diagnostics")
        map("n", "<leader>d", vim.diagnostic.open_float, "Show diagnostic details")
        map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Previous diagnostic")
        map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
        map("n", "K", vim.lsp.buf.hover, "Show hover information")
        map("n", "<leader>cf", function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end, "Format current buffer")

      end

      -- c++
      vim.lsp.config("clangd", {
        capabilities = capabilities,
        on_attach = on_attach,
        root_markers = { "compile_commands.json", "compile_flags.txt", ".git" },
      })

      -- python
      vim.lsp.config("pyright", {
        capabilities = capabilities,
        on_attach = on_attach,
        root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
      })

      -- lua
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        on_attach = on_attach,
        root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".git" },
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = {
              library = {
                vim.env.VIMRUNTIME .. "/lua",
                vim.fn.stdpath("config") .. "/lua",
              },
              checkThirdParty = false,
            },
          },
        },
      })
    end,
  },
}
