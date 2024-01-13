return {
  {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")

      vim.keymap.set("n", "<leader>a", mark.add_file, { desc = 'Add file to harpoon' })
      vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = 'Toggle harpoon quick menu' })

      vim.keymap.set("n", "<C-h>", function() ui.nav_file(1) end, { desc = 'Navigate to file 1 in harpoon' })
      vim.keymap.set("n", "<C-j>", function() ui.nav_file(2) end, { desc = 'Navigate to file 2 in harpoon' })
      vim.keymap.set("n", "<C-k>", function() ui.nav_file(3) end, { desc = 'Navigate to file 3 in harpoon' })
      vim.keymap.set("n", "<C-l>", function() ui.nav_file(4) end, { desc = 'Navigate to file 4 in harpoon' })
    end
  }
}
