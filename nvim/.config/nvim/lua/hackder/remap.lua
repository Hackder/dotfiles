vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.keymap.set("n", "<leader>e", function()
  local status, image = pcall(require, "image")
  if status then
    image.clear()
  end
  vim.cmd.Ex()
end, { desc = "Open NetRW" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down half page" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up half page" })

vim.keymap.set("n", "H", "^", { desc = "Go to beginning of a line" })
vim.keymap.set("n", "L", "$", { desc = "Go to end of a line" })

vim.keymap.set("x", "p", '"_dP', { desc = "Paste without yanking" })

vim.keymap.set("n", "<leader>y", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Copy to clipboard" })

vim.keymap.set("i", "<C-c>", "<Esc>", { desc = "Exit insert mode" })

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>lf", function()
  vim.lsp.buf.format()
end, { desc = "Format document using LSP" })

vim.keymap.set(
  "n",
  "<leader>s",
  [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
  { desc = "Rename current word" }
)

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("n", "<C-n>", ":cprevious<CR>", { desc = "Previous item in quickfix list" })
vim.keymap.set("n", "<C-m>", ":cnext<CR>", { desc = "Next item in quickfix list" })

vim.keymap.set("v", ">", ">gv", { desc = "Indent selection without losing selection" })
vim.keymap.set("v", "<", "<gv", { desc = "Unindent selection without losing selection" })

-- Resize window with Ctrl + Left
vim.api.nvim_set_keymap("n", "<C-Left>", ":vertical resize -2<CR>", { noremap = true, silent = true })

-- Resize window with Ctrl + Right
vim.api.nvim_set_keymap("n", "<C-Right>", ":vertical resize +2<CR>", { noremap = true, silent = true })

-- Resize window with Ctrl + Up
vim.api.nvim_set_keymap("n", "<C-Up>", ":resize +2<CR>", { noremap = true, silent = true })

-- Resize window with Ctrl + Down
vim.api.nvim_set_keymap("n", "<C-Down>", ":resize -2<CR>", { noremap = true, silent = true })
