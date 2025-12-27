return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{ "neovim/nvim-lspconfig" },
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
		config = function()
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
						vim.diagnostic.jump({ count = 1, float = true, severity = { min = vim.diagnostic.severity.WARN } })
					end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
					vim.keymap.set("n", "]d", function()
						vim.diagnostic.jump({ count = -1, float = true, severity = { min = vim.diagnostic.severity.WARN } })
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

			require("mason-lspconfig").setup({
				automatic_enable = {
					exclude = {
						"rust_analyzer", -- Exclude rust_analyzer as it is managed by rustaceanvim
					},
				},
				ensure_installed = { "lua_ls", "ts_ls" },
				handlers = {
					tailwindcss = function()
						vim.lsp.config.tailwindcss.setup({
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
				},
			})

			vim.lsp.config["gleam"] = {
				cmd = { "gleam", "lsp" },
				filetypes = { "gleam" },
				root_dir = require("lspconfig").util.root_pattern("gleam.toml"),
			}

			vim.lsp.config["zls"] = {
				cmd = { "zls" },
				settings = {
					zls = {
						zig_exe_path = vim.fn.expand("zig"),
					},
				},
			}

			vim.lsp.config["roc_ls"] = {
				cmd = { "roc_language_server" },
				filetypes = { "roc" },
			}

			vim.lsp.config["sourcekit"] = {
				capabilities = {
					workspace = {
						didChangeWatchedFiles = {
							dynamicRegistration = true,
						},
					},
				},
			}

			vim.lsp.config["jsonls"] = {
				filetypes = { "json", "jsonc" },
				settings = {
					json = {
						-- Schemas https://www.schemastore.org
						schemas = {
							{
								fileMatch = { "package.json" },
								url = "https://json.schemastore.org/package.json",
							},
							{
								fileMatch = { "tsconfig*.json" },
								url = "https://json.schemastore.org/tsconfig.json",
							},
							{
								fileMatch = {
									".prettierrc",
									".prettierrc.json",
									"prettier.config.json",
								},
								url = "https://json.schemastore.org/prettierrc.json",
							},
							{
								fileMatch = { ".eslintrc", ".eslintrc.json" },
								url = "https://json.schemastore.org/eslintrc.json",
							},
							{
								fileMatch = { ".babelrc", ".babelrc.json", "babel.config.json" },
								url = "https://json.schemastore.org/babelrc.json",
							},
							{
								fileMatch = { "lerna.json" },
								url = "https://json.schemastore.org/lerna.json",
							},
							{
								fileMatch = { "now.json", "vercel.json" },
								url = "https://json.schemastore.org/now.json",
							},
							{
								fileMatch = {
									".stylelintrc",
									".stylelintrc.json",
									"stylelint.config.json",
								},
								url = "http://json.schemastore.org/stylelintrc.json",
							},
						},
					},
				},
			}

			-- Remove default keymaps
			pcall(vim.keymap.del, "n", "grr")
			pcall(vim.keymap.del, "n", "gra")
			pcall(vim.keymap.del, "x", "gra")
			pcall(vim.keymap.del, "n", "grn")
			pcall(vim.keymap.del, "n", "gri")
		end,
	},
	{
		"saghen/blink.cmp",
		-- optional: provides snippets for the snippet source
		dependencies = { "rafamadriz/friendly-snippets", "xzbdmw/colorful-menu.nvim" },

		-- use a release tag to download pre-built binaries
		version = "1.*",
		-- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
		-- build = 'cargo build --release',
		-- If you use nix, you can build from source using latest nightly rust with:
		-- build = 'nix run .#build-plugin',

		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
			-- 'super-tab' for mappings similar to vscode (tab to accept)
			-- 'enter' for enter to accept
			-- 'none' for no mappings
			--
			-- All presets have the following mappings:
			-- C-space: Open menu or open docs if already open
			-- C-n/C-p or Up/Down: Select next/previous item
			-- C-e: Hide menu
			-- C-k: Toggle signature help (if signature.enabled = true)
			--
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = {
				preset = "default",
				["<C-k>"] = false,
				["<C-s>"] = { "show_signature" },
			},

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			completion = {
				documentation = { auto_show = true },
				menu = {
					draw = {
						-- We don't need label_description now because label and label_description are already
						-- combined together in label by colorful-menu.nvim.
						columns = { { "kind_icon" }, { "label", gap = 1 } },
						components = {
							label = {
								text = function(ctx)
									return require("colorful-menu").blink_components_text(ctx)
								end,
								highlight = function(ctx)
									return require("colorful-menu").blink_components_highlight(ctx)
								end,
							},
						},
					},
				},
			},

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
			},

			signature = { enabled = true },

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
	{
		"xzbdmw/colorful-menu.nvim",
		config = function()
			-- You don't need to set these options.
			require("colorful-menu").setup({
				ls = {
					lua_ls = {
						-- Maybe you want to dim arguments a bit.
						arguments_hl = "@comment",
					},
					gopls = {
						-- By default, we render variable/function's type in the right most side,
						-- to make them not to crowd together with the original label.

						-- when true:
						-- foo             *Foo
						-- ast         "go/ast"

						-- when false:
						-- foo *Foo
						-- ast "go/ast"
						align_type_to_right = true,
						-- When true, label for field and variable will format like "foo: Foo"
						-- instead of go's original syntax "foo Foo". If align_type_to_right is
						-- true, this option has no effect.
						add_colon_before_type = false,
						-- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
						preserve_type_when_truncate = true,
					},
					-- for lsp_config or typescript-tools
					ts_ls = {
						-- false means do not include any extra info,
						-- see https://github.com/xzbdmw/colorful-menu.nvim/issues/42
						extra_info_hl = "@comment",
					},
					vtsls = {
						-- false means do not include any extra info,
						-- see https://github.com/xzbdmw/colorful-menu.nvim/issues/42
						extra_info_hl = "@comment",
					},
					["rust-analyzer"] = {
						-- Such as (as Iterator), (use std::io).
						extra_info_hl = "@comment",
						-- Similar to the same setting of gopls.
						align_type_to_right = true,
						-- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
						preserve_type_when_truncate = true,
					},
					clangd = {
						-- Such as "From <stdio.h>".
						extra_info_hl = "@comment",
						-- Similar to the same setting of gopls.
						align_type_to_right = true,
						-- the hl group of leading dot of "•std::filesystem::permissions(..)"
						import_dot_hl = "@comment",
						-- See https://github.com/xzbdmw/colorful-menu.nvim/pull/36
						preserve_type_when_truncate = true,
					},
					zls = {
						-- Similar to the same setting of gopls.
						align_type_to_right = true,
					},
					roslyn = {
						extra_info_hl = "@comment",
					},
					dartls = {
						extra_info_hl = "@comment",
					},
					-- The same applies to pyright/pylance
					basedpyright = {
						-- It is usually import path such as "os"
						extra_info_hl = "@comment",
					},
					pylsp = {
						extra_info_hl = "@comment",
						-- Dim the function argument area, which is the main
						-- difference with pyright.
						arguments_hl = "@comment",
					},
					-- If true, try to highlight "not supported" languages.
					fallback = true,
					-- this will be applied to label description for unsupport languages
					fallback_extra_info_hl = "@comment",
				},
				-- If the built-in logic fails to find a suitable highlight group for a label,
				-- this highlight is applied to the label.
				fallback_highlight = "@variable",
				-- If provided, the plugin truncates the final displayed text to
				-- this width (measured in display cells). Any highlights that extend
				-- beyond the truncation point are ignored. When set to a float
				-- between 0 and 1, it'll be treated as percentage of the width of
				-- the window: math.floor(max_width * vim.api.nvim_win_get_width(0))
				-- Default 60.
				max_width = 60,
			})
		end,
	},
}
