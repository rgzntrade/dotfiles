local status, null_ls = pcall(require, "null-ls")
if not status then
	vim.notify("没有找到 null-ls")
	return
end


null_ls.setup({
    sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.clang_format,
        null_ls.builtins.formatting.rustfmt,
        null_ls.builtins.formatting.pylint,
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.completion.spell,
    },
    autostart = true,
})
