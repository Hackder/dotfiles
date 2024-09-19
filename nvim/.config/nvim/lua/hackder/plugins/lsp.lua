return {
	{
		--- Uncomment the two plugins below if you want to manage the language servers from neovim
		--- and read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
		{
			"williamboman/mason.nvim",
			config = function()
				require("mason").setup({})
			end,
		},
		{
			"williamboman/mason-lspconfig.nvim",
			dependencies = {
				"williamboman/mason.nvim",
				"VonHeikemen/lsp-zero.nvim",
			},
			config = function()
				local lsp_zero = require("lsp-zero")
				lsp_zero.extend_lspconfig()

				local lsp_config = require("lspconfig")

				lsp_config.gleam.setup({
					-- cmd = { "/Users/jurajpetras/dev/gleam/gleam/target/debug/gleam", "lsp" },
					cmd = { "gleam", "lsp" },
					filetypes = { "gleam" },
					root_dir = require("lspconfig").util.root_pattern("gleam.toml"),
				})

				lsp_config.zls.setup({
					cmd = { "zls" },
					settings = {
						zls = {
							zig_exe_path = vim.fn.exepath("zig"),
						},
					},
				})

				lsp_config.roc_ls.setup({
					cmd = { "roc_language_server" },
					filetypes = { "roc" },
				})

				require("mason-lspconfig").setup({
					ensure_installed = { "lua_ls", "ts_ls", "rust_analyzer", "pyright" },
					handlers = {
						lsp_zero.default_setup,
						ts_ls = function()
							require("lspconfig").ts_ls.setup({
								handlers = {
									["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
										if result.diagnostics == nil then
											return
										end

										-- ignore some ts_ls diagnostics
										local idx = 1
										while idx <= #result.diagnostics do
											local entry = result.diagnostics[idx]

											local formatter = require("format-ts-errors")[entry.code]
											entry.message = formatter and formatter(entry.message) or entry.message

											-- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
											if entry.code == 80001 then
												-- { message = "File is a CommonJS module; it may be converted to an ES module.", }
												table.remove(result.diagnostics, idx)
											else
												idx = idx + 1
											end
										end

										vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx, config)
									end,
								},
							})
						end,
						lua_ls = function()
							require("lspconfig").lua_ls.setup({})
						end,
						tailwindcss = function()
							require("lspconfig").tailwindcss.setup({
								filtetypes = {
									"css",
									"scss",
									"sass",
									"postcss",
									"html",
									"javascript",
									"javascriptreact",
									"typescript",
									"typescriptreact",
									"svelte",
									"vue",
									"rust",
								},
								init_options = {
									userLanguages = {
										rust = "html",
									},
								},
								root_dir = require("lspconfig").util.root_pattern(
									"tailwind.config.js",
									"tailwind.config.ts",
									"tailwind.config.mjs",
									"tailwind.config.cjs"
								),
							})
						end,
						pyright = function()
							require("lspconfig").pyright.setup({
								settings = {
									python = {
										pythonPath = vim.fn.exepath("python3"),
									},
								},
							})
						end,
					},
				})
			end,
		},
		{ "neovim/nvim-lspconfig" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-buffer" },
		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-buffer",
				"L3MON4D3/LuaSnip",
			},
			config = function()
				local cmp = require("cmp")
				local cmp_select = { beahvior = cmp.SelectBehavior.Select }
				local cmp_mappings = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
					["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
				})

				local icons = require("hackder.icons")
				cmp.setup({
					mapping = cmp_mappings,
					completion = {
						completeopt = "menu,menuone,noinsert",
					},
					formatting = {
						fields = { "kind", "abbr", "menu" },
						format = function(entry, vim_item)
							vim_item.menu = entry:get_completion_item().detail
							if icons.kinds[vim_item.kind] then
								vim_item.kind = icons.kinds[vim_item.kind]
							else
								vim_item.kind = icons.kinds.Text
							end
							return vim_item
						end,
					},
					experimental = {
						ghost_text = {
							hl_group = "CmpGhostText",
						},
					},
				})

				cmp.config.sources({
					{ name = "path", keyword_length = 1 },
					{ name = "nvim_lsp" },
					{ name = "luasnip", keyword_length = 2 },
				}, {
					{ name = "buffer" },
				})

				cmp.setup.filetype({ "sql" }, {
					sources = {
						{ name = "vim-dadbod-completion" },
						{ name = "buffer" },
					},
				})
			end,
		},
		{ "L3MON4D3/LuaSnip" },
		{
			"VonHeikemen/lsp-zero.nvim",
			dependencies = {
				"williamboman/nvim-lsp-installer",
				"neovim/nvim-lspconfig",
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/nvim-cmp",
				"L3MON4D3/LuaSnip",
			},
			branch = "v3.x",
			config = function()
				local lsp = require("lsp-zero")

				-- Enable inline diagnostics, with increased spacing
				vim.diagnostic.config({
					virtual_text = true,
					signs = true,
					underline = true,
					update_in_insert = true,
					severity_sort = true,
				})

				lsp.on_attach(function(client, bufnr)
					-- client.server_capabilities.semanticTokensProvider = nil
					vim.keymap.set(
						"n",
						"gd",
						require("telescope.builtin").lsp_definitions,
						{ buffer = bufnr, remap = false, desc = "Go to definition" }
					)
					vim.keymap.set(
						"n",
						"gi",
						require("telescope.builtin").lsp_implementations,
						{ buffer = bufnr, remap = false, desc = "Go to implementation" }
					)
					vim.keymap.set(
						"n",
						"gD",
						vim.lsp.buf.declaration,
						{ buffer = bufnr, remap = false, desc = "Go to declaration" }
					)
					vim.keymap.set(
						"n",
						"gr",
						require("telescope.builtin").lsp_references,
						{ buffer = bufnr, remap = false, desc = "Search references" }
					)
					vim.keymap.set(
						"n",
						"<leader>lk",
						vim.lsp.buf.hover,
						{ buffer = bufnr, remap = false, desc = "Hover analytics" }
					)
					vim.keymap.set(
						"n",
						"<leader>ls",
						vim.lsp.buf.workspace_symbol,
						{ buffer = bufnr, remap = false, desc = "Search workspace symbols" }
					)
					vim.keymap.set(
						"n",
						"<leader>ld",
						vim.diagnostic.open_float,
						{ buffer = bufnr, remap = false, desc = "Show diagnostics" }
					)
					vim.keymap.set(
						"n",
						"[d",
						vim.diagnostic.goto_next,
						{ buffer = bufnr, remap = false, desc = "Next diagnostic" }
					)
					vim.keymap.set(
						"n",
						"]d",
						vim.diagnostic.goto_prev,
						{ buffer = bufnr, remap = false, desc = "Previous diagnostic" }
					)
					vim.keymap.set(
						"n",
						"<leader>la",
						vim.lsp.buf.code_action,
						{ buffer = bufnr, remap = false, desc = "Code actions" }
					)
					vim.keymap.set(
						"n",
						"<leader>lr",
						vim.lsp.buf.rename,
						{ buffer = bufnr, remap = false, desc = "Rename" }
					)
					vim.keymap.set(
						"i",
						"<C-s>",
						vim.lsp.buf.signature_help,
						{ buffer = bufnr, remap = false, desc = "Signature help" }
					)
				end)

				lsp.setup()
			end,
		},
	},
}
