return {
	{
		"RRethy/nvim-base16",
		lazy = false,
		priority = 1000,
		config = function()
			local light_theme = "github_light_default"
			local dark_theme = "base16-gruvbox-dark-hard"

			local gruvbox_ns = vim.api.nvim_create_namespace("gruvbox_custom")

			-- To prevent the initial dark flash when using light theme
			vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })

			vim.api.nvim_set_hl(gruvbox_ns, "@lsp.type.namespace", { link = "@namespace" })
			vim.api.nvim_set_hl(gruvbox_ns, "@lsp.type.type", { link = "@type" })
			vim.api.nvim_set_hl(gruvbox_ns, "@lsp.type.class", { link = "@type" })
			vim.api.nvim_set_hl(gruvbox_ns, "@lsp.type.enum", { link = "@type" })
			vim.api.nvim_set_hl(gruvbox_ns, "@lsp.type.interface", { link = "@type" })
			vim.api.nvim_set_hl(gruvbox_ns, "@lsp.type.struct", { link = "@structure" })
			vim.api.nvim_set_hl(gruvbox_ns, "@lsp.type.parameter", { link = "@parameter" })
			vim.api.nvim_set_hl(gruvbox_ns, "@lsp.type.variable", { link = "@property" })
			vim.api.nvim_set_hl(gruvbox_ns, "@lsp.type.property", { link = "@property" })
			vim.api.nvim_set_hl(gruvbox_ns, "@lsp.type.enumMember", { link = "@constant" })
			vim.api.nvim_set_hl(gruvbox_ns, "@lsp.type.function", { link = "@function" })
			vim.api.nvim_set_hl(gruvbox_ns, "@lsp.type.method", { link = "@method" })
			vim.api.nvim_set_hl(gruvbox_ns, "@lsp.type.macro", { link = "@macro" })
			vim.api.nvim_set_hl(gruvbox_ns, "@lsp.type.decorator", { link = "@function" })
			vim.api.nvim_set_hl(gruvbox_ns, "TSTagDelimiter", { link = "@property" })
			vim.api.nvim_set_hl(gruvbox_ns, "TSVariable", { link = "@property" })
			vim.api.nvim_set_hl(gruvbox_ns, "TSPunctDelimiter", { link = "@property" })
			vim.api.nvim_set_hl(gruvbox_ns, "@lsp.mod.global", { link = "@variable.builtin" })
			vim.api.nvim_set_hl(gruvbox_ns, "@lsp.typemod.variable.defaultLibrary", { link = "@variable.builtin" })
			vim.api.nvim_set_hl(gruvbox_ns, "@function.builtin", { link = "@variable.builtin" })

			vim.api.nvim_set_hl_ns(gruvbox_ns)
			vim.g.base16colorspace = 256

			local theme_config_path = vim.fn.expand("~/dotfiles/ghostty/.config/ghostty/theme")
			local function read_theme_config()
				local file = io.open(theme_config_path, "r")
				if file then
					local content = file:read("*a")
					file:close()
					return content
				end
				return nil
			end

			local function set_correct_theme()
				local theme_config = read_theme_config()
				if theme_config and theme_config:lower():match("light") then
					vim.cmd.colorscheme(light_theme)
					vim.api.nvim_set_hl(0, "BlinkCmpMenu", { link = "CmpDocumentation" })
					vim.api.nvim_set_hl(0, "BlinkCmpKind", { link = "CmpDocumentation" })
					vim.o.background = "light"
				else
					vim.cmd.colorscheme(dark_theme)
					vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "#1A1C1D" })
					vim.api.nvim_set_hl(0, "BlinkCmpKind", { bg = "#1A1C1D" })
					vim.o.background = "dark"
				end
			end
			set_correct_theme()

			vim.api.nvim_create_autocmd("ColorScheme", {
				pattern = "*",
				callback = function()
					local current_colorscheme = vim.g.colors_name
					if current_colorscheme == "base16-gruvbox-dark-hard" then
						vim.o.background = "dark"
						vim.api.nvim_set_hl_ns(gruvbox_ns)
					else
						vim.o.background = "light"
						vim.api.nvim_set_hl_ns(0)
					end
				end,
			})

			local uv = vim.loop
			local function watch_file(file_path)
				local handle = uv.new_fs_event()

				-- Callback function to execute when the file changes
				local function on_change(err, filename, events)
					if err then
						print("Error watching file:", err)
						return
					end

					vim.schedule(function()
						set_correct_theme()
					end)
				end

				if handle == nil then
					print("Failed to create file watcher handle.")
					return
				end

				uv.fs_event_start(handle, file_path, {}, on_change)
			end

			watch_file(theme_config_path)
		end,
	},
	{
		"projekt0n/github-nvim-theme",
		name = "github-theme",
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
		priority = 1000, -- make sure to load this before all the other start plugins
	},
}
