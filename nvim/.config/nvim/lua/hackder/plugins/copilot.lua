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
		dependencies = {
			{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		build = "make tiktoken",
		opts = {
			chat_autocomplete = false,
			window = {
				layout = "float", -- 'vertical', 'horizontal', 'float', 'replace'
				width = 0.75, -- fractional width of parent, or absolute width in columns when > 1
				height = 0.75, -- fractional height of parent, or absolute height in rows when > 1
			},
			mappings = {
				complete = {
					insert = "<Tab>",
				},
			},
			prompts = {
				Gramatika = {
					prompt = ">$gpt-4o\n\nPrepis text so Slovenskou diakritikou, gramaticke chyby, ciarky a slovosled smies upravit, no slova alebo vyznam viet nemen.",
					system_prompt = "You are thorough and precise when getting your task done. You will do exactly what user wants you to. You will be tasked to help with text, do not write line numbers",
					mapping = "<leader>csk",
					description = "Will rewrite slovak text with correct grammar",
				},
				Grammar = {
					prompt = ">$gpt-4o\n\nRewrite the text with correct English grammar, punctuation, and sentence structure. Do not change the meaning of the sentences.",
					system_prompt = "You are thorough and precise when getting your task done. You will do exactly what user wants you to. You will be tasked to help with text, do not write line numbers",
					mapping = "<leader>cen",
					description = "Will rewrite English text with correct grammar",
				},
				SystemProgrammingChat = {
					prompt = "> You will answer me based on info from this file\n> You are an expert on system programming, but make sure to tell me where it is written in the material, based on what you respond.\n> Make your answers that require explanation brief -> one sentence.\n\n> You may be asked to explain something, be brief and precise. Or to choose single or multiple answers from given choices, be precise and briefly explain based on which info you chose the answer.\n\n> You may be asked to write code, be precise and follow code formatting instructions. Do not include additional text or line numbers.",
					system_prompt = "You are precise and follow code formatting instructions. Do not include additional text or line numbers. Only answer based on the given context.",
					mapping = "<leader>pcb",
					description = "Expert system programming responses based on file material",
				},
			},
		},
		keys = {
			{ "<leader>ccs", ":CopilotChatStop<CR>", desc = "CopilotChat Stop", mode = { "n", "v" } },
			-- Ask the Perplexity agent a quick question
			{
				"<leader>ccp",
				function()
					local input = vim.fn.input("Perplexity: ")
					if input ~= "" then
						require("CopilotChat").ask(input, {
							agent = "perplexityai",
							selection = false,
						})
					end
				end,
				desc = "CopilotChat - Perplexity Search",
				mode = { "n", "v" },
			},
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
