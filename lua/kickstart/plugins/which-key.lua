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
  {                     -- Useful plugin to show you pending keybinds.
    'folke/which-key.nvim',
    event = 'VimEnter', -- Sets the loading event to 'VimEnter'
    config = function() -- This is the function that runs, AFTER loading
      require('which-key').setup()

      -- Document existing key chains
      require('which-key').register {
        ['<leader>wc'] = { name = '#which-key [C]ode', _ = 'which_key_ignore' },
        ['<leader>wd'] = { name = '#which-key [D]ocument', _ = 'which_key_ignore' },
        ['<leader>wr'] = { name = '#which-key [R]ename', _ = 'which_key_ignore' },
        ['<leader>ws'] = { name = '#which-key [S]earch', _ = 'which_key_ignore' },
        ['<leader>wv'] = { name = '#which-key [W]orkspace', _ = 'which_key_ignore' },
        ['<leader>wt'] = { name = '#which-key [T]oggle', _ = 'which_key_ignore' },
        ['<leader>wh'] = { name = '#which-key Git [H]unk', _ = 'which_key_ignore' },
      }
      -- visual mode
      require('which-key').register({
        ['<leader>h'] = { '#which-key Git [H]unk' },
      }, { mode = 'v' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
