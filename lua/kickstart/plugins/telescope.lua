-- NOTE: Plugins can specify dependencies.
--
-- The dependencies are proper plugin specifications as well - anything
-- you do for a plugin at the top level, you can do for a dependency.
--
-- Use the `dependencies` key to specify the dependencies of a particular plugin

return {
  { -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
      { 'nvim-telescope/telescope-dap.nvim' },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require('telescope').setup {
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
          ['dap'] = {},
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')
      pcall(require('telescope').load_extension, 'dap')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>ph', builtin.help_tags, { desc = '#Telescope [S]earch [H]elp' })
      vim.keymap.set('n', '<leader>pk', builtin.keymaps, { desc = '#Telescope [S]earch [K]eymaps' })
      vim.keymap.set('n', '<leader>pf', builtin.find_files, { desc = '#Telescope [S]earch [F]iles' })
      vim.keymap.set('n', '<leader>ps', builtin.builtin, { desc = '#Telescope [S]earch [S]elect Telescope' })
      vim.keymap.set('n', '<leader>pu', function()
        builtin.grep_string { file_ignore_patterns = { 'swaggerui/**' } }
      end, { desc = '#Telescope [S]earch current [W]ord' })

      vim.keymap.set('n', '<leader>pi', builtin.live_grep, { desc = '#Telescope [S]earch by [G]rep' })
      vim.keymap.set('n', '<leader>ld', builtin.diagnostics, { desc = '#Telescope [S]earch [D]iagnostics' })
      vim.keymap.set('n', '<leader>pr', builtin.resume, { desc = '#Telescope [S]earch [R]esume' })
      vim.keymap.set('n', '<leader>p.', builtin.oldfiles, { desc = '#Telescope [S]earch Recent Files ("." for repeat)' })
      vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '#Telescope [ ] Find existing buffers' })

      vim.keymap.set('n', '<C-p>', function()
        local ok, _ = pcall(builtin.git_files, {
          show_untracked = true,
          file_ignore_patterns = { 'node_modules', '.git', '/swaggerui' },
          use_git_root = false,
        })
        if not ok then
          builtin.find_files()
        end
      end, { desc = '#telescope git files' })

      vim.keymap.set('n', '<leader>ps', function()
        builtin.grep_string { search = vim.fn.input 'Grep > ' }
      end, { desc = '#telescope grep in files' })

      vim.keymap.set('n', '<leader>pd', builtin.git_status, { desc = '#Telescope Git diff' })
      vim.keymap.set('n', '<leader>pc', builtin.git_bcommits, { desc = '#Telescope Git list commits from current buffor' })
      vim.keymap.set('n', '<leader>pb', builtin.git_branches, { desc = '#Telescope Git Branches, list branches and checksout' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '#Telescope [/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>p/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '#Telescope [S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>pn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = '#Telescope [S]earch [N]eovim files' })
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
