return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"mfussenegger/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
	},
	keys = {
		{
			"<leader>dt",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Toggle Breakpoint",
		},
		{
			"<leader>db",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Set Conditional Breakpoint",
		},
		{
			"<leader>dr",
			function()
				require("dap").repl.open()
			end,
			desc = "Open REPL",
		},
		{
			"<leader>dl",
			function()
				require("dap").run_last()
			end,
			desc = "Run Last Debug Session",
		},
		{
			"<leader>du",
			function()
				require("dapui").toggle()
			end,
			desc = "Toggle DAP UI",
		},
		{
			"<leader>dc",
			function()
				require("dap").continue()
			end,
			desc = "Start/Continue Debugging",
		},
		{
			"<leader>dn",
			function()
				require("dap").step_over()
			end,
			desc = "Step Over",
		},
		{
			"<leader>dsi",
			function()
				require("dap").step_into()
			end,
			desc = "Step Into",
		},
		{
			"<leader>dso",
			function()
				require("dap").step_out()
			end,
			desc = "Step Out",
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dapui.setup()

		dap.listeners.before.attach.dapui_config = dapui.open
		dap.listeners.before.launch.dapui_config = dapui.open
		dap.listeners.before.event_terminated.dapui_config = dapui.close
		dap.listeners.before.event_exited.dapui_config = dapui.close

		vim.fn.sign_define("DapBreakpoint", {
			text = "🛑",
			texthl = "DapBreakpointSymbol",
			linehl = "DapBreakpoint",
			numhl = "DapBreakpoint",
		})
		vim.fn.sign_define("DapStopped", {
			text = "⚪",
			texthl = "yellow",
			linehl = "DapBreakpoint",
			numhl = "DapBreakpoint",
		})
		vim.fn.sign_define("DapBreakpointRejected", {
			text = "⭕",
			texthl = "DapBreakpointSymbol",
			linehl = "DapBreakpoint",
			numhl = "DapBreakpoint",
		})

		-- dap.configurations.dart = {
		-- 	{
		-- 		type = "flutter",
		-- 		request = "launch",
		-- 		name = "Launch Flutter",
		-- 		dartSdkPath = "~/fvm/default/bin/cache/dart-sdk/bin/dart",
		-- 		flutterSdkPath = "~/fvm/default/bin/flutter",
		-- 		program = "${workspaceFolder}/lib/main.dart",
		-- 		cwd = "${workspaceFolder}",
		-- 		args = function()
		-- 			local input = vim.fn.input("Args (default: -d chrome): ")
		-- 			if input == "" then
		-- 				return { "-d", "chrome" }
		-- 			end
		-- 			return vim.split(input, " ")
		-- 		end,
		-- 	},
		-- }
		-- dap.adapters.dart = {
		-- 	type = "executable",
		-- 	command = "dart",
		-- 	args = { "debug_adapter" },
		-- }
		-- dap.adapters.flutter = {
		-- 	type = "executable",
		-- 	command = "flutter",
		-- 	args = { "debug_adapter" },
		-- }
	end,
}
