return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy',
    requires = 'nvim-treesitter/nvim-treesitter',

    opts = {
      max_lines = 5, -- <- maximum context lines
      trim_scope = 'inner', -- optional: drop inner scopes first
      mode = 'cursor', -- line used to calculate context
    },
    config = function(_, opts)
      require('treesitter-context').setup(opts)

      vim.keymap.set('n', 'gn', function()
        require('treesitter-context').go_to_context(vim.v.count1)
      end, { silent = true })
    end,
  },
}
