return {
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPre',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = {
        add          = { text = '┃' },
        change       = { text = '┃' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signcolumn = true,          -- show signs
      current_line_blame = false, -- show blame info
      -- current_line_blame_opts = {
      --   virt_text = true,
      --   virt_text_pos = 'eol',
      --   delay = 1000,
      -- },
      on_attach = function(bufnr)
        local gs = require('gitsigns')
        local function map(mode, lhs, rhs, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, lhs, rhs, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd('normal ]c')
          else
            gs.next_hunk()
          end
        end, { desc = "Next Git hunk" })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd('normal [c')
          else
            gs.prev_hunk()
          end
        end, { desc = "Previous Git hunk" })

        -- Actions
        map('n', '<leader>hr', gs.reset_hunk, { desc = "Reset current hunk" })
        map('v', '<leader>hr', function()
          gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') }
        end, { desc = "Reset selected hunk (visual mode)" })
        map('n', '<leader>hR', gs.reset_buffer, { desc = "Reset entire buffer" })
        map('n', '<leader>hp', gs.preview_hunk, { desc = "Preview hunk" })
        map('n', '<leader>hi', gs.preview_hunk_inline, { desc = "Preview hunk inline" })
        map('n', '<leader>hb', function()
          gs.blame_line { full = true }
        end, { desc = "Blame line (full)" })
        map('n', '<leader>hd', gs.diffthis, { desc = "Diff current file against index" })
        map('n', '<leader>hD', function()
          gs.diffthis('~')
        end, { desc = "Diff current file against previous commit" })

        -- Toggles
        map('n', '<leader>tw', gs.toggle_word_diff)

        -- Text object
        map({ 'o', 'x' }, 'ih', gs.select_hunk)
      end,
    },
  }
}
