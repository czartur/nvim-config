return {
  {
    "hrsh7th/nvim-cmp", -- keep cmp for completion
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local keymap = vim.keymap
      local opts = { noremap = true, silent = true }

      local on_attach = function(_, bufnr)
        opts.buffer = bufnr

        opts.desc = "Show references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

        opts.desc = "Go to definition"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

        opts.desc = "Go to implementation"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

        opts.desc = "Go to type definition"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

        opts.desc = "Show code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Rename symbol"
        keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

        opts.desc = "Show diagnostics in a floating window"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, opts)

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, opts)

        opts.desc = "Show hover information"
        keymap.set("n", "K", vim.lsp.buf.hover, opts)

        -- Format buffer on-demand
        opts.desc = "Format current buffer"
        keymap.set("n", "<leader>cf", function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end, opts)

        opts.desc = "Restart LSP for current buffer"
        keymap.set("n", "<leader>rs", function()
          -- Stop all active LSP clients for this buffer
          local clients = vim.lsp.get_clients({ bufnr = bufnr })

          if vim.tbl_isempty(clients) then
            vim.notify("No active LSP clients for this buffer", vim.log.levels.WARN)
            return
          end

          for _, client in pairs(clients) do
            local config = client.config
            -- Stop the client
            client:stop()

            -- Restart the client using its original config
            if config then
              vim.lsp.start(config)
            end
          end
        end, opts)
      end

      local capabilities = cmp_nvim_lsp.default_capabilities()

      -- Diagnostic signs
      local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
      end

      -- Helper to start servers lazily for specific filetypes
      local function setup_lsp(server, ft, extra)
        vim.api.nvim_create_autocmd("FileType", {
          pattern = ft,
          callback = function()
            if not vim.lsp.get_clients({ name = server })[1] then
              vim.lsp.start(vim.tbl_deep_extend("force", {
                name = server,
                capabilities = capabilities,
                on_attach = on_attach,
              }, extra or {}))
            end
          end,
        })
      end

      -- C/C++
      setup_lsp("clangd", { "c", "cpp", "objc", "objcpp" }, {
        root_dir = vim.fs.root(0, { "compile_commands.json", "compile_flags.txt", ".git" }),
      })

      -- Python
      setup_lsp("pyright", { "python" }, {
        cmd = { "pyright-langserver", "--stdio" },
        root_dir = vim.fs.root(0, { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" }),
      })

      -- Lua
      setup_lsp("lua_ls", { "lua" }, {
        cmd = { "lua-language-server" },
        root_dir = vim.fs.root(0, { ".luarc.json", ".luacheckrc", ".git" }),
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
