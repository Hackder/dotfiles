vim.g.copilot_node_command = "~/.nvm/versions/node/v16*/bin/node"
vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true

vim.keymap.set("i", "<C-.>", "copilot#Accept()", { silent = true, expr = true })
