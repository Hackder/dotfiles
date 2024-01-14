return {
  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {},
  --   config = function()
  --     vim.cmd.colorscheme("tokyonight-night")
  --   end
  -- },
  -- {
  --   "rose-pine/neovim",
  --   as = "rose-pine",
  --   config = function()
  --     require("rose-pine").setup({
  --       disable_background = false,
  --       styles = {
  --         bold = false,
  --       }
  --     })
  --
  --     vim.cmd("colorscheme rose-pine")
  --     -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  --     -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  --     -- vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
  --   end
  -- },
  -- {
  --   "ellisonleao/gruvbox.nvim",
  --   priority = 1000,
  --   config = function()
  --     require("gruvbox").setup({
  --       contrast = "hard",
  --       terminal_colors = false,
  --       bold = false,
  --     })
  --     vim.o.background = "dark"
  --     vim.cmd.colorscheme("gruvbox")
  --     -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  --     vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  --     -- vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
  --   end
  -- }
  {
    "RRethy/nvim-base16",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.base16colorspace = 256
      vim.o.background = "dark"
      vim.cmd.colorscheme("base16-gruvbox-dark-hard")
      vim.cmd("syntax on")
      vim.cmd("hi Normal ctermbg=none")
    end
  }
}
