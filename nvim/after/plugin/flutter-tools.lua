require("flutter-tools").setup {
	debugger = {        -- integrate with nvim dap + install dart code debugger
		enabled = true,
		run_via_dap = true, -- use dap instead of a plenary job to run flutter apps
		-- if empty dap will not stop on any exceptions, otherwise it will stop on those specified
		-- see |:help dap.set_exception_breakpoints()| for more info
	}
}
