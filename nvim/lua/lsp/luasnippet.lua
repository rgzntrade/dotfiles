local status, luasnip = pcall(require, 'luasnip')
if not status then
  vim.notify('luasnip not found!')
  return
end
luasnip.setup {}
