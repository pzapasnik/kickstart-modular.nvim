-- DAP Remaps
vim.keymap.set('n', '<Leader>bb', function() require('dap').toggle_breakpoint() end, { desc = "#DAP toggle breakpoint" })
vim.keymap.set('n', '<leader>bc', function() require('dap').continue() end, { desc = "#DAP continiue" })
vim.keymap.set('n', '<leader>bo', function() require('dap').step_over() end, { desc = "#DAP step over" })
vim.keymap.set('n', '<leader>bi', function() require('dap').step_into() end, { desc = "#DAP setep into" })
vim.keymap.set('n', '<leader>bu', function() require('dap').step_out() end, { desc = "#DAP setep out" })
vim.keymap.set('n', '<Leader>br', function() require('dap').repl.open() end, { desc = "#DAP" })
vim.keymap.set('n', '<Leader>bt', function() require('dap').run_to_cursor() end, { desc = "#DAP run to cursor" })
vim.keymap.set('n', '<Leader>bs', function() require('dap').disconnect() end, { desc = "#DAP disconnect" })
vim.keymap.set('n', '<Leader>bl', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end,
  { desc = "#DAP set conditional breakpoint" })
vim.keymap.set('n', '<Leader>bp',
  function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, { desc = "#DAP" })
vim.keymap.set('n', '<leader>btu', function() require('dapui').toggle() end, { desc = "#DAP toggle dap ui" })

require("nvim-dap-virtual-text").setup({
  virt_text_pos = 'eol'
})
require('dap-go').setup()
require('dapui').setup(
  {
    controls = {
      element = "repl",
      enabled = true,
      icons = {
        disconnect = "",
        pause = "",
        play = "",
        run_last = "",
        step_back = "",
        step_into = "",
        step_out = "",
        step_over = "",
        terminate = ""
      }
    },
    element_mappings = {},
    expand_lines = true,
    floating = {
      border = "single",
      mappings = {
        close = { "q", "<Esc>" }
      }
    },
    force_buffers = true,
    icons = {
      expanded = '▾', collapsed = '▸', circular = '↺', breakpoint = '●' },
    -- layouts = { {
    -- 	elements = { {
    -- 		id = "scopes",
    -- 		size = 0.25
    -- 	}, {
    -- 		id = "breakpoints",
    -- 		size = 0.25
    -- 	}, {
    -- 		id = "stacks",
    -- 		size = 0.25
    -- 	}, {
    -- 		id = "watches",
    -- 		size = 0.25
    -- 	} },
    -- 	position = "left",
    -- 	size = 100
    -- }, {
    -- 	elements = { {
    -- 		id = "repl",
    -- 		size = 0.5
    -- 	}, {
    -- 		id = "console",
    -- 		size = 0.5
    -- 	} },
    -- 	position = "bottom",
    -- 	size = 10
    -- } },
    mappings = {
      edit = "e",
      expand = { "<CR>", "<2-LeftMouse>" },
      open = "o",
      remove = "d",
      repl = "r",
      toggle = "t"
    },
    render = {
      indent = 1,
      max_value_lines = 100
    }
  }
)

require('telescope').load_extension('dap')

local function get_dap_launch_json(paths)
  for _, path in ipairs(paths) do
    local f = io.open(path, "r")
    if f then
      f:close()
      return path
    end
  end
  return 'launch.json'
end

local dap_config_files = { '.debug/launch.json', '.vscode/launch.json', }
require('dap.ext.vscode').load_launchjs(get_dap_launch_json(dap_config_files), {})

-- launch dapui by default
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
