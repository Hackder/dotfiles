return {
	{
		"mrcjkb/rustaceanvim",
		version = "^6", -- Recommended
		lazy = false, -- This plugin is already lazy
		dependencies = {
			"nvim-lua/plenary.nvim",
			"mfussenegger/nvim-dap",
			"rcarriga/nvim-dap-ui",
		},
		config = function()
			vim.keymap.set("n", "<F5>", function()
				vim.cmd.RustLsp("debug")
			end, { desc = "Run debugger" })

			vim.keymap.set("n", "<F10>", function()
				vim.cmd.RustLsp({ "debug", bang = true })
			end, { desc = "Run last debugger target" })

			vim.g.rustaceanvim = {
				tools = {
					enable_clippy = false,
				},
			}
		end,
	},
}
