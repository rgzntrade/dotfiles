local status, mason_null_ls = pcall(require, "mason-null-ls")
if not status then
  vim.notify("mason-null-ls not found!")
  return
end

mason_null_ls.setup({
    ensure_installed = { "lua_ls", "rust_analyzer", "clangd", "cmake",
        "lemminx", "marksman", "taplo", "pylyzer" },
    automatic_installation = true,
})
