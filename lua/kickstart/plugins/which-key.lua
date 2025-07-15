-- NOTE: Plugins can also be configured to run Lua code when they are loaded.
--
-- This is often very useful to both group configuration, as well as handle
-- lazy loading plugins that don't need to be loaded immediately at startup.
--
-- For example, in the following configuration, we use:
--  event = 'VimEnter'
--
-- which loads which-key before all the UI elements are loaded. Events can be
-- normal autocommands events (`:help autocmd-events`).
--
-- Then, because we use the `config` key, the configuration only runs
-- after the plugin has been loaded:
--  config = function() ... end

return {
  { -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').register {
        {
          { '<leader>wc', group = '#which-key [C]ode' },
          { '<leader>wc_', hidden = true },
          { '<leader>wd', group = '#which-key [D]ocument' },
          { '<leader>wd_', hidden = true },
          { '<leader>wh', group = '#which-key Git [H]unk' },
          { '<leader>wh_', hidden = true },
          { '<leader>wr', group = '#which-key [R]ename' },
          { '<leader>wr_', hidden = true },
          { '<leader>ws', group = '#which-key [S]earch' },
          { '<leader>ws_', hidden = true },
          { '<leader>wt', group = '#which-key [T]oggle' },
          { '<leader>wt_', hidden = true },
          { '<leader>wv', group = '#which-key [W]orkspace' },
          { '<leader>wv_', hidden = true },
        },
      }
      -- visual mode
      require('which-key').register {
        { '<leader>h', desc = '#which-key Git [H]unk', mode = 'v' },
      }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
