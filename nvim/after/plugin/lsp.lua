local lsp = require('lsp-zero')

lsp.preset('recommended')

require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {'tsserver', 'eslint', 'rust_analyzer', 'lua_ls'},
  handlers = {
    lsp.default_setup,
  }
})

local cmp = require('cmp')
local cmp_select = { beahvior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
  ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
  ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
  ['<C-y>'] = cmp.mapping.confirm({ select = true }),
  ['<C-Space>'] = cmp.mapping.complete(),
})

cmp.setup({
   mapping = cmp_mappings,
   sources = {
    { name = 'path' },
    { name = 'nvim_lsp' },
    { name = 'buffer',  keyword_length = 3 },
    { name = 'luasnip', keyword_length = 2 },
   }
})

lsp.on_attach(function(client, bufnr)
  vim.keymap.set("n", "gd", require('telescope.builtin').lsp_definitions,
    { buffer = bufnr, remap = false, desc = 'Go to definition' })
  vim.keymap.set("n", "gi", require('telescope.builtin').lsp_implementations,
    { buffer = bufnr, remap = false, desc = 'Go to implementation' })
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration,
    { buffer = bufnr, remap = false, desc = 'Go to declaration' })
  vim.keymap.set("n", "gr", require('telescope.builtin').lsp_references,
    { buffer = bufnr, remap = false, desc = 'Search references' })
  vim.keymap.set("n", "<leader>lk", vim.lsp.buf.hover,
    { buffer = bufnr, remap = false, desc = 'Hover analytics' })
  vim.keymap.set("n", "<leader>ls", vim.lsp.buf.workspace_symbol,
    { buffer = bufnr, remap = false, desc = 'Search workspace symbols' })
  vim.keymap.set("n", "<leader>ld", vim.diagnostic.open_float,
    { buffer = bufnr, remap = false, desc = 'Show diagnostics' })
  vim.keymap.set("n", "[d", vim.diagnostic.goto_next,
    { buffer = bufnr, remap = false, desc = 'Next diagnostic' })
  vim.keymap.set("n", "]d", vim.diagnostic.goto_prev,
    { buffer = bufnr, remap = false, desc = 'Previous diagnostic' })
  vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action,
    { buffer = bufnr, remap = false, desc = 'Code actions' })
  vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename,
    { buffer = bufnr, remap = false, desc = 'Rename' })
  vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help,
    { buffer = bufnr, remap = false, desc = 'Signature help' })
end)

lsp.set_preferences({
  set_lsp_keymaps = { omit = { 'K' } }
})

lsp.setup()

-- Enable inline diagnostics, with increased spacing
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = true,
})
