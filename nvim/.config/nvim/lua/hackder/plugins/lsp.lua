return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({})
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			local lspconfig = require("lspconfig")

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("hackder-lsp-attach", { clear = true }),
				callback = function(event)
					local opts = { buffer = event.buf, remap = false }

					-- Navigation
					vim.keymap.set(
						"n",
						"gd",
						require("telescope.builtin").lsp_definitions,
						vim.tbl_extend("force", opts, { desc = "Go to definition" })
					)
					vim.keymap.set(
						"n",
						"gi",
						require("telescope.builtin").lsp_implementations,
						vim.tbl_extend("force", opts, { desc = "Go to implementation" })
					)
					vim.keymap.set(
						"n",
						"gD",
						require("telescope.builtin").lsp_type_definitions,
						vim.tbl_extend("force", opts, { desc = "Go to type definition" })
					)
					vim.keymap.set(
						"n",
						"gr",
						require("telescope.builtin").lsp_references,
						vim.tbl_extend("force", opts, { desc = "Search references" })
					)

					-- LSP actions
					vim.keymap.set(
						"n",
						"<leader>lk",
						vim.lsp.buf.hover,
						vim.tbl_extend("force", opts, { desc = "Hover analytics" })
					)
					vim.keymap.set(
						"n",
						"<leader>ls",
						vim.lsp.buf.workspace_symbol,
						vim.tbl_extend("force", opts, { desc = "Search workspace symbols" })
					)
					vim.keymap.set(
						"n",
						"<leader>la",
						vim.lsp.buf.code_action,
						vim.tbl_extend("force", opts, { desc = "Code actions" })
					)
					vim.keymap.set(
						"n",
						"<leader>lr",
						vim.lsp.buf.rename,
						vim.tbl_extend("force", opts, { desc = "Rename" })
					)

					-- Diagnostics
					vim.keymap.set(
						"n",
						"<leader>ld",
						vim.diagnostic.open_float,
						vim.tbl_extend("force", opts, { desc = "Show diagnostics" })
					)
					vim.keymap.set("n", "[d", function()
						vim.diagnostic.jump({ count = 1, float = true })
					end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
					vim.keymap.set("n", "]d", function()
						vim.diagnostic.jump({ count = -1, float = true })
					end, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))

					-- Insert mode
					vim.keymap.set(
						"i",
						"<C-s>",
						vim.lsp.buf.signature_help,
						vim.tbl_extend("force", opts, { desc = "Signature help" })
					)
				end,
			})

			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = true,
				severity_sort = true,
			})

			-- Manual LSP configurations
			lspconfig.gleam.setup({
				cmd = { "gleam", "lsp" },
				filetypes = { "gleam" },
				root_dir = lspconfig.util.root_pattern("gleam.toml"),
			})

			lspconfig.zls.setup({
				cmd = { "zls" },
				settings = {
					zls = {
						zig_exe_path = vim.fn.exepath("zig"),
					},
				},
			})

			lspconfig.roc_ls.setup({
				cmd = { "roc_language_server" },
				filetypes = { "roc" },
			})

			lspconfig.sourcekit.setup({
				capabilities = {
					workspace = {
						didChangeWatchedFiles = {
							dynamicRegistration = true,
						},
					},
				},
			})

			-- Remove default keymaps
			pcall(vim.keymap.del, "n", "grr")
			pcall(vim.keymap.del, "n", "gra")
			pcall(vim.keymap.del, "x", "gra")
			pcall(vim.keymap.del, "n", "grn")
			pcall(vim.keymap.del, "n", "gri")

			require("mason-lspconfig").setup({
				automatic_enable = {
					exclude = {
						"rust_analyzer", -- Exclude rust_analyzer as it is managed by rustaceanvim
					},
				},
				ensure_installed = { "lua_ls", "ts_ls", "pyright" },
				handlers = {
					tailwindcss = function()
						lspconfig.tailwindcss.setup({
							filetypes = {
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
								userLanguages = { rust = "html" },
							},
						})
					end,
					pyright = function()
						lspconfig.pyright.setup({
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
			local luasnip = require("luasnip")

			luasnip.config.setup({})

			local cmp_select = { behavior = cmp.SelectBehavior.Select }
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

			vim.api.nvim_set_hl(0, "CmpItemAbbr", { bg = "none" })

			local icons = require("hackder.icons")
			cmp.setup({
				mapping = cmp_mappings,
				window = {
					completion = { winhighlight = "Normal:CmpNormal" },
					documentation = { winhighlight = "Normal:CmpNormal,FloatBorder:CmpNormal" },
				},
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },
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

						if highlights_info ~= nil then
							vim_item.abbr_hl_group = highlights_info.highlights
							vim_item.abbr = highlights_info.text
						else
							vim_item.abbr_hl_group = "CmpItemAbbr"
						end

						vim_item.kind = icons.kinds[vim_item.kind] or icons.kinds.Text
						return vim_item
					end,
				},
				experimental = {
					ghost_text = { hl_group = "CmpGhostText" },
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
}
