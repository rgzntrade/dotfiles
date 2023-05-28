local status, refactoring = pcall(require, "refactoring")
if not status then
  vim.notify('refactoring not found!')
  return
end
refactoring.setup({
    prompt_func_return_type = {
        go = false,
        java = false,

        cpp = true,
        c = true,
        h = true,
        hpp = true,
        cxx = true
    },
    prompt_func_param_type = {
        go = false,
        java = false,

        cpp = false,
        c = false,
        h = false,
        hpp = false,
        cxx = false,
    },
    printf_statements = {},
    print_var_statements = {},
})
