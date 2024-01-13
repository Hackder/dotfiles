function Neoformat()
  local group = vim.api.nvim_create_augroup('formatting', { clear = true })

  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.\\(js\\|jsx\\|ts\\|tsx\\|mts\\|mjs\\|cjs\\|html\\|json\\)',
    group = group,
    callback = function()
      vim.cmd('Neoformat prettierd')
    end
  })

  vim.api.nvim_create_autocmd('BufWritePre', {
    pattern = '*.\\(py\\)',
    group = group,
    callback = function()
      vim.cmd('Neoformat black')
    end
  })
end

return {
  {
    "sbdchd/neoformat",
    config = function()
      vim.g.neoformat_try_node_exe = 1

      vim.api.nvim_create_user_command('FormatOnSave', function (opts)
        if opts.fargs[1] == 'on' then
          Neoformat()
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

      Neoformat()
    end
  }
}
