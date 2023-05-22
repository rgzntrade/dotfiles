local status, debug_dap = pcall(require, 'debug-dap')
if not status then
  vim.notify('debug-dap not found!')
  return
end
require('debug-dap.dap-config').setup()
require('debug-dap.dap-ui')
require('debug-dap.dap-virtual-text')
require('debug-dap.dap-util')
