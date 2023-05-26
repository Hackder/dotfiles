-- Cursor
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

-- Numers
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
if os.getenv("HOME") then
  vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
else
  vim.opt.undodir = os.getenv("USERPROFILE") .. "/.vim/undodir"
end
vim.opt.undofile = true
vim.opt.autoread = true

-- Search

vim.opt.ignorecase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.g.mapleader = " "

-- Fix wsl clipboard
vim.g.clipboard = {
  name = "win32yank-wsl",
  copy = {
    ["+"] = "win32yank.exe -i --crlf",
    ["*"] = "win32yank.exe -i --crlf",
  },
  paste = {
    ["+"] = "win32yank.exe -o --lf",
    ["*"] = "win32yank.exe -o --lf",
  },
  cache_enabled = 0,
}

-- Prettier
vim.api.nvim_create_user_command(
  'Prettier',
  function(opts)
    vim.api.nvim_command('write')
    local path = vim.fn.expand('%')
    local result = io.popen('npx prettier -w ' .. path):read("a")
    print(result)
    vim.cmd('e')
  end,
  { nargs = 0 }
)
