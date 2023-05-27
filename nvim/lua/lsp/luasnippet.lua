local status, luasnip = pcall(require, 'luasnip')
if not status then
  nvim.notify('luasnip not found!')
  return
end
luasnip.setup {}
