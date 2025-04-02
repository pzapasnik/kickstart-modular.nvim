-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',
    'theHamsta/nvim-dap-virtual-text',
    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
    -- ADD Python dep config for venv here !!!
    'mfussenegger/nvim-dap-python',
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
      },
    }

    -- Basic debugging keymaps, feel free to change to your liking!
    vim.keymap.set('n', '<leader>bc', dap.continue, { desc = '#Debug: Start/Continue' })
    vim.keymap.set('n', '<leader>bi', dap.step_into, { desc = '#Debug: Step Into' })
    vim.keymap.set('n', '<leader>bo', dap.step_over, { desc = '#Debug: Step Over' })
    vim.keymap.set('n', '<leader>bu', dap.step_out, { desc = '#Debug: Step Out' })
    vim.keymap.set('n', '<leader>bb', dap.toggle_breakpoint, { desc = '#Debug: Toggle Breakpoint' })
    vim.keymap.set('n', '<Leader>bs', function()
      require('dap').disconnect()
    end, { desc = '#Debug disconnect' })

    vim.keymap.set('n', '<leader>bl', function()
      dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
    end, { desc = '#Debug: Set Conditional Breakpoint' })
    vim.keymap.set('n', '<leader>bt', function()
      require('dapui').toggle()
    end, { desc = '#Debug toggle dap ui' })

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {}

    -- lauch json setup
    require('telescope').load_extension 'dap'

    local function get_dap_launch_json(paths)
      for _, path in ipairs(paths) do
        local f = io.open(path, 'r')
        if f then
          f:close()
          return path
        end
      end
      return 'launch.json'
    end

    local dap_config_files = { '.debug/launch.json', '.vscode/launch.json' }
    local vscode = require 'dap.ext.vscode'
    local json = require 'plenary.json'
    vscode.json_decode = function(str)
      return vim.json.decode(json.json_strip_comments(str))
    end

    vscode.load_launchjs(get_dap_launch_json(dap_config_files), {})
  end,
}
