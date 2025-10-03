return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"mfussenegger/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		dapui.setup()

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
			dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
			dapui.close()
		end

		vim.keymap.set("n", "<Leader>dt", dap.toggle_breakpoint, {})
		vim.keymap.set("n", "<Leader>db", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end)
		vim.keymap.set("n", "<Leader>dr", dap.repl.open)
		vim.keymap.set("n", "<Leader>dl", dap.run_last)
		vim.keymap.set("n", "<Leader>du", dapui.toggle)
		vim.keymap.set("n", "<F5>", dap.continue, {})
		vim.keymap.set("n", "<F10>", function()
			require("dap").step_over()
		end)
		vim.keymap.set("n", "<F11>", function()
			require("dap").step_into()
		end)
		vim.keymap.set("n", "<F12>", function()
			require("dap").step_out()
		end)

		vim.fn.sign_define("DapBreakpoint", {
			text = "🛑",
			texthl = "DapBreakpoint",
			linehl = "DapBreakpoint",
			numhl = "DapBreakpoint",
		})

		dap.configurations.dart = {
			{
				type = "dart",
				request = "launch",
				name = "Launch dart",
				dartSdkPath = "~/fvm/default/bin/cache/dart-sdk/bin/dart",
				flutterSdkPath = "~/fvm/default/bin/flutter",
				program = "${workspaceFolder}/lib/main.dart",
				cwd = "${workspaceFolder}",
			},
			{
				type = "flutter",
				request = "launch",
				name = "Launch flutter",
				dartSdkPath = "~/fvm/default/bin/cache/dart-sdk/bin/dart", -- ensure this is correct
				flutterSdkPath = "~/fvm/default/bin/flutter", -- ensure this is correct
				program = "${workspaceFolder}/lib/main.dart", -- ensure this is correct
				cwd = "${workspaceFolder}",
			},
		}
		dap.adapters.dart = {
			type = "executable",
			command = "dart",
			args = { "debug_adapter" },
		}
		dap.adapters.flutter = {
			type = "executable",
			command = "flutter",
			args = { "debug_adapter" },
		}
	end,
}
