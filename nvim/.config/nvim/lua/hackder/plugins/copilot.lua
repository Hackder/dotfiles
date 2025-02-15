return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "folke/which-key.nvim" },
		},
		config = function()
			require("which-key").add({ { "<leader>c", group = "Copilot" } })
			require("copilot").setup({
				panel = {
					enabled = true,
					auto_refresh = false,
					keymap = {
						jump_prev = "[[",
						jump_next = "]]",
						accept = "<CR>",
						refresh = "gr",
						open = "<M-CR>",
					},
					layout = {
						position = "bottom", -- | top | left | right
						ratio = 0.4,
					},
				},
				suggestion = {
					enabled = true,
					auto_trigger = true,
					debounce = 75,
					keymap = {
						accept = "<C-j>",
						accept_word = "<M-j>",
						accept_line = false,
						next = "<M-]>",
						prev = "<M-[>",
						dismiss = "<C-]>",
					},
				},
				filetypes = {
					yaml = true,
					markdown = true,
					help = false,
					gitcommit = false,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					["."] = false,
				},
				copilot_node_command = "node", -- Node.js version must be > 18.x
				server_opts_overrides = {},
			})

			vim.keymap.set("n", "<leader>cd", function()
				vim.cmd("Copilot toggle")
			end, { noremap = true, silent = true })
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "main",
		event = "BufRead",
		dependencies = {
			{ "folke/which-key.nvim" },
			{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			local wk = require("which-key")
			wk.add({ { "<leader>cc", group = "CopilotChat" } })
			require("CopilotChat").setup({})
		end,
		-- See Commands section for default commands if you want to lazy load on them
		keys = {
			{
				"<leader>cch",
				function()
					local actions = require("CopilotChat.actions")
					require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
				end,
				mode = { "n", "v" },
				desc = "CopilotChat - Help actions",
			},
			{
				"<leader>cco",
				function()
					require("CopilotChat").toggle()
				end,
				mode = { "n", "v" },
				desc = "CopilotChat - Toggle",
			},
		},
	},
}
