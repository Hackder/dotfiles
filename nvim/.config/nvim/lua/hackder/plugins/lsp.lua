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
		{ "hrsh7th/cmp-path" },
		{ "saadparwaiz1/cmp_luasnip" },
		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				"hrsh7th/cmp-nvim-lsp",
				"hrsh7th/cmp-path",
				"hrsh7th/cmp-buffer",
				"L3MON4D3/LuaSnip",
				"saadparwaiz1/cmp_luasnip",
			},
			config = function()
				local cmp = require("cmp")
				local cmp_select = { beahvior = cmp.SelectBehavior.Select }
				local luasnip = require("luasnip")
				luasnip.config.setup({})

				local cmp_mappings = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
					["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				})

				vim.api.nvim_set_hl(0, "CmpNormal", { bg = "#1A1C1D" })
				vim.api.nvim_set_hl(0, "CmpItemAbbr", { bg = "none" })

				local icons = require("hackder.icons")
				cmp.setup({
					mapping = cmp_mappings,
					window = {
						completion = {
							winhighlight = "Normal:CmpNormal",
						},
						documentation = {
							winhighlight = "Normal:CmpNormal,FloatBorder:CmpNormal",
						},
					},
					snippet = {
						expand = function(args)
							luasnip.lsp_expand(args.body)
						end,
					},
					completion = {
						completeopt = "menu,menuone,noinsert",
					},
					sources = {
						{ name = "lazydev", group_index = 0 },
						{ name = "nvim_lsp" },
						{ name = "buffer" },
						{ name = "path" },
						{ name = "luasnip", keyword_length = 2 },
					},
					formatting = {
						fields = { "kind", "abbr" },
						format = function(entry, vim_item)
							local highlights_info = require("colorful-menu").cmp_highlights(entry)

							-- highlight_info is nil means we are missing the ts parser, it's
							-- better to fallback to use default `vim_item.abbr`. What this plugin
							-- offers is two fields: `vim_item.abbr_hl_group` and `vim_item.abbr`.
							if highlights_info ~= nil then
								vim_item.abbr_hl_group = highlights_info.highlights
								vim_item.abbr = highlights_info.text
							else
								vim_item.abbr_hl_group = "CmpItemAbbr"
							end

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

				cmp.setup.filetype({ "sql" }, {
					sources = {
						{ name = "vim-dadbod-completion" },
						{ name = "path" },
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
						require("telescope.builtin").lsp_type_definitions,
						{ buffer = bufnr, remap = false, desc = "Go to type definition" }
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
