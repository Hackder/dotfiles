return {
	{ "nvim-neotest/nvim-nio" },
	{
		"mfussenegger/nvim-dap",
		config = function()
			local dap = require("dap")
			vim.keymap.set("n", "<leader>db", function()
				dap.toggle_breakpoint()
			end, { desc = "Toggle breakpoint" })

			vim.keymap.set("n", "<leader>dc", function()
				dap.continue()
			end, { desc = "Continue" })

			vim.keymap.set("n", "<leader>dr", function()
				dap.repl.open()
			end, { desc = "Open REPL" })

			vim.keymap.set("n", "<leader>ds", function()
				dap.step_over()
			end, { desc = "Step over" })

			vim.keymap.set("n", "<leader>di", function()
				dap.step_into()
			end, { desc = "Step into" })

			vim.keymap.set("n", "<leader>do", function()
				dap.step_out()
			end, { desc = "Step out" })

			vim.keymap.set("n", "<leader>dl", function()
				dap.run_last()
			end, { desc = "Run last" })

			vim.keymap.set("n", "<leader>dt", function()
				dap.toggle()
			end, { desc = "Toggle" })

			vim.keymap.set("n", "<leader>dd", function()
				dap.disconnect()
			end, { desc = "Disconnect" })

			vim.keymap.set("n", "<leader>dr", function()
				dap.run()
			end, { desc = "Run" })
		end,
	},
	{
		"mfussenegger/nvim-dap-python",
		config = function()
			require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			require("dapui").setup()

			vim.keymap.set("n", "<leader>du", function()
				require("dapui").toggle()
			end, { desc = "Toggle UI" })
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		dependencies = { "mfussenegger/nvim-dap" },
		config = function()
			require("nvim-dap-virtual-text").setup()
		end,
	},
}
