local dap = require('dap')
local dapui = require('dapui')

dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end

dap.listeners.after.event_terminated['dapui_config'] = function()
  dapui.close()
end

dap.listeners.after.event_exited['dapui_config'] = function()
  dapui.close()
end

dapui.setup({ floating = { border = "rounded" } })

require('mason-nvim-dap').setup({
  automatic_setup = true,
})

dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = '/home/hackder/debuggers/cpp/extension/debugAdapters/bin/OpenDebugAD7'
}
dap.configurations.cpp = {
  {
    name = 'Launch file',
    type = 'cppdbg',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
  {
    name = 'Attach to gdbserver :1234',
    type = 'cppdbg',
    request = 'launch',
    MIMode = 'gdb',
    miDebuggerServerAddress = 'localhost:1234',
    miDebuggerPath = '/usr/bin/gdb',
    cwd = '${workspaceFolder}',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
  },
}

vim.keymap.set("n", "<F5>", function() require("dap").continue() end)
vim.keymap.set("n", "<F17>", function() require("dap").terminate() end) -- Shift+F5
vim.keymap.set("n", "<F29>", function() require("dap").restart_frame() end) -- Control+F5
vim.keymap.set("n", "<F6>", function() require("dap").pause() end)
vim.keymap.set("n", "<F9>", function() require("dap").toggle_breakpoint() end)
vim.keymap.set("n", "<F10>", function() require("dap").step_over() end)
vim.keymap.set("n", "<F11>", function() require("dap").step_into() end)
vim.keymap.set("n", "<F23>", function() require("dap").step_out() end) -- Shift+F11
vim.keymap.set("n", "<leader>Db", function() require("dap").toggle_breakpoint() end)
vim.keymap.set("n", "<leader>DB", function() require("dap").clear_breakpoints() end)
vim.keymap.set("n", "<leader>Dc", function() require("dap").continue() end)
vim.keymap.set("n", "<leader>Di", function() require("dap").step_into() end)
vim.keymap.set("n", "<leader>Do", function() require("dap").step_over() end)
vim.keymap.set("n", "<leader>DO", function() require("dap").step_out() end)
vim.keymap.set("n", "<leader>Dq", function() require("dap").close() end)
vim.keymap.set("n", "<leader>DQ", function() require("dap").terminate() end)
vim.keymap.set("n", "<leader>Dp", function() require("dap").pause() end)
vim.keymap.set("n", "<leader>Dr", function() require("dap").restart_frame() end)
vim.keymap.set("n", "<leader>DR", function() require("dap").repl.toggle() end)
vim.keymap.set("n", "<leader>Du", function() require("dapui").toggle() end)
vim.keymap.set("n", "<leader>Dh", function() require("dap.ui.widgets").hover() end)
