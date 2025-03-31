return {
	{
		"nvim-lualine/lualine.nvim",
		config = function()
			local custom_gruvbox = require("lualine.themes.gruvbox")

			-- Change the background of lualine_c section for normal mode
			for _, section in pairs({ "normal", "insert", "visual", "replace", "command", "inactive" }) do
				for _, component in pairs({ "a", "b", "c" }) do
					custom_gruvbox[section][component].bg = "#1E2021"
					custom_gruvbox[section][component].fg = "#D5C4A1"
				end
			end

			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = custom_gruvbox,
					component_separators = { left = "|", right = "|" },
					section_separators = { left = "", right = "" },
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					always_show_tabline = true,
					globalstatus = false,
					refresh = {
						statusline = 100,
						tabline = 100,
						winbar = 100,
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { { "filename", path = 1 } },
					lualine_x = { "encoding", "fileformat", "filetype" },
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = { "filename" },
					lualine_x = { "location" },
					lualine_y = {},
					lualine_z = {},
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {},
			})
		end,
	},
}
