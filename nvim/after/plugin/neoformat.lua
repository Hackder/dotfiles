vim.g.neoformat_try_node_exe = 1

function neoformat()
  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.\\(js\\|jsx\\|ts\\|tsx\\|mjs\\|cjs\\)',
    group = vim.api.nvim_create_augroup('formatting', { clear = true }),
    callback = function()
      vim.cmd('Neoformat prettierd')
    end
  })
end

vim.api.nvim_create_user_command('FormatOnSave', function (opts) 
  if opts.fargs[1] == 'on' then
    neoformat()
  elseif opts.fargs[1] == 'off' then
    vim.api.nvim_exec('autocmd! formatting', true)
  else
    print('Invalid argument')
  end
end, {
  nargs = 1,
  complete = function(ArgLead, CmdLine, CursorPos)
    return {'on', 'off'}
  end
})