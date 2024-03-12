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
  -- },
  {
    "RRethy/nvim-base16",
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.base16colorspace = 256
      vim.o.background = "dark"
      vim.cmd.colorscheme("base16-gruvbox-dark-hard")
      -- Setup lsp token highlights
      vim.api.nvim_set_hl(0, '@lsp.type.namespace', { link = '@namespace' })
      vim.api.nvim_set_hl(0, '@lsp.type.type', { link = '@type' })
      vim.api.nvim_set_hl(0, '@lsp.type.class', { link = '@type' })
      vim.api.nvim_set_hl(0, '@lsp.type.enum', { link = '@type' })
      vim.api.nvim_set_hl(0, '@lsp.type.interface', { link = '@type' })
      vim.api.nvim_set_hl(0, '@lsp.type.struct', { link = '@structure' })
      vim.api.nvim_set_hl(0, '@lsp.type.parameter', { link = '@parameter' })
      vim.api.nvim_set_hl(0, '@lsp.type.variable', { link = '@property' })
      vim.api.nvim_set_hl(0, '@lsp.type.property', { link = '@property' })
      vim.api.nvim_set_hl(0, '@lsp.type.enumMember', { link = '@constant' })
      vim.api.nvim_set_hl(0, '@lsp.type.function', { link = '@function' })
      vim.api.nvim_set_hl(0, '@lsp.type.method', { link = '@method' })
      vim.api.nvim_set_hl(0, '@lsp.type.macro', { link = '@macro' })
      vim.api.nvim_set_hl(0, '@lsp.type.decorator', { link = '@function' })
      vim.api.nvim_set_hl(0, 'TSTagDelimiter', { link = '@property' })
      vim.api.nvim_set_hl(0, 'TSVariable', { link = '@property' })
      vim.api.nvim_set_hl(0, 'TSPunctDelimiter', { link = '@property' })

      vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
      vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
    end
  }
  -- {
  --   'echasnovski/mini.base16',
  --   lazy = false,
  --   priority = 1000,
  --   version = '*',
  --   config = function()
  --     require('mini.base16').setup({
  --       palette = {
  --         base00 = '#1d2021',
  --         base01 = '#3c3836',
  --         base02 = '#504945',
  --         base03 = '#665c54',
  --         base04 = '#bdae93',
  --         base05 = '#d5c4a1',
  --         base06 = '#ebdbb2',
  --         base07 = '#fbf1c7',
  --         base08 = '#fb4934',
  --         base09 = '#fe8019',
  --         base0A = '#fabd2f',
  --         base0B = '#b8bb26',
  --         base0C = '#8ec07c',
  --         base0D = '#83a598',
  --         base0E = '#d3869b',
  --         base0F = '#d65d0e',
  --       },
  --       plugins = {
  --         default = true,
  --       },
  --     })
  --   end
  -- },
}
