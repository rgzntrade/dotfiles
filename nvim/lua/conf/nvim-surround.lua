local status, nvim_surround = pcall(require, 'nvim-surround')
if not status then
  vim.notify('nvim-surround not found!')
end
nvim_surround.setup {}
