return {
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local harpoon = require("harpoon")
			harpoon.setup()

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end, { desc = "Add file to harpoon" })
			vim.keymap.set("n", "<C-e>", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end, { desc = "Toggle harpoon quick menu" })

			vim.keymap.set("n", "<C-h>", function()
				harpoon:list():select(1)
			end, { desc = "Navigate to file 1 in harpoon" })
			vim.keymap.set("n", "<C-j>", function()
				harpoon:list():select(2)
			end, { desc = "Navigate to file 2 in harpoon" })
			vim.keymap.set("n", "<C-k>", function()
				harpoon:list():select(3)
			end, { desc = "Navigate to file 3 in harpoon" })
			vim.keymap.set("n", "<C-l>", function()
				harpoon:list():select(4)
			end, { desc = "Navigate to file 4 in harpoon" })
		end,
	},
}
