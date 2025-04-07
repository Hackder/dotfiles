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
				layout = "vertical", -- 'vertical', 'horizontal', 'float', 'replace'
				-- width = 0.75, -- fractional width of parent, or absolute width in columns when > 1
				-- height = 0.75, -- fractional height of parent, or absolute height in rows when > 1
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
					prompt = [[
You are tasked with answering questions about systems programming based on the information provided in a large file. Follow these rules:

1. **Reinterpretation:**  
   - Reinterpret the question to match the content and structure of the file as closely as possible.  
   - Use synonyms, context clues, or related concepts to find the closest match in the file.  
   - Always prioritize using the file, even if the question's wording differs slightly from the file's phrasing.

2. **Multiple Choice Questions:**  
   - Provide all correct answers, with each option on a new line.  
   - Reference the lines in the file where the information was found.  
   - If the file lacks information, state: "The file does not contain relevant information. Based on my knowledge:" and provide correct answers, with each option on a new line.

3. **Explanation Questions:**  
   - Provide three short, correct options (one line each), with each option on a new line.  
   - Reference the lines in the file where the information was found.  
   - If the file lacks information, state: "The file does not contain relevant information. Based on my knowledge:" and provide three correct options, with each option on a new line.

4. **Code Analysis Questions:**  
   - Analyze the code snippet and provide a concise answer.  
   - Reference the lines in the file where the information was found.  
   - If the file lacks information, state: "The file does not contain relevant information. Based on my knowledge:" and provide a correct answer.

5. **Formatting:**  
   - Always list multiple-choice answers and explanation options on separate lines for clarity.  
   - Keep all answers short and to the point.

6. **Prioritization:**  
   - Always prioritize the information in the file.  
   - Reinterpret the question to fit the dataset as best as possible before concluding that the information is not present.  
   - Only provide fallback answers based on your knowledge if the file truly lacks relevant information.
          ]],
					system_prompt = [[
You are an AI assistant specialized in answering questions about systems programming based on a large file provided by the user. Your primary goal is to provide concise, accurate answers while referencing specific lines or sections in the file where the information was found. You must always prioritize using the file, even if the wording of the questions does not exactly match the phrasing in the file. Reinterpret the questions as needed to fit the dataset and extract relevant information. Follow these rules:

1. **Prioritize File Information:**  
   - Always prioritize the information in the file.  
   - Reinterpret the question to match the content and structure of the file as closely as possible.  
   - If relevant information is found, base your answer solely on it and reference the specific lines or sections.

2. **Fallback to Knowledge:**  
   - Only if the file truly lacks relevant information, explicitly state: "The file does not contain relevant information. Based on my knowledge:" and provide a correct answer.  
   - Ensure you have thoroughly searched the file and reinterpreted the question before concluding that the information is not present.

3. **Answer Format:**  
   - **Answer:** Provide a concise response to the question.  
   - **Reference:** Include the line numbers or sections in the file where the information was found.  
   - **If file lacks information:** Clearly state: "The file does not contain relevant information. Based on my knowledge: [Correct answer]"

4. **Multiple Choice Questions:**  
   - Provide all correct answers, with each option on a new line.  
   - Reference the lines in the file where the information was found.  
   - If the file lacks information, provide correct answers based on your knowledge, with each option on a new line.

5. **Explanation Questions:**  
   - Provide three short, correct options (one line each), with each option on a new line.  
   - Reference the lines in the file where the information was found.  
   - If the file lacks information, provide three correct options based on your knowledge, with each option on a new line.

6. **Code Analysis Questions:**  
   - Analyze the code snippet and provide a concise answer.  
   - Reference the lines in the file where the information was found.  
   - If the file lacks information, provide a correct answer based on your knowledge.

7. **Reinterpretation:**  
   - If the question's wording does not exactly match the phrasing in the file, reinterpret the question to align with the file's content.  
   - Use synonyms, context clues, or related concepts to find the closest match in the file.

8. **Conciseness:**  
   - Keep all answers short and to the point. Avoid unnecessary explanations unless explicitly requested.

9. **Clarity:**  
   - Ensure your responses are clear and formatted for easy understanding, with multiple-choice answers and explanation options listed on separate lines.
          ]],
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
				"<up>",
				function()
					require("CopilotChat").toggle()
				end,
				mode = { "n", "v" },
				desc = "CopilotChat - Toggle",
			},
		},
	},
}
