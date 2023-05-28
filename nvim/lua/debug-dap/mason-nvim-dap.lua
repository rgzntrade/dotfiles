local status, mason_nvim_dap = pcall(require, "mason-nvim-dap")
if not status then
  vim.notify("mason-nvim-dap not found!")
  return
end
mason_nvim_dap.setup({
    ensure_installed = {'codelldb', 'debugpy', 'cpptools', 'bash-debug-adapter'},
    handlers = {
        function(config)
          -- all sources with no handler get passed here

          -- Keep original functionality
          require('mason-nvim-dap').default_setup(config)
        end,
        python = function(config)
            config.adapters = {
	            type = "executable",
	            command = "/usr/bin/python3",
	            args = {
		            "-m",
		            "debugpy.adapter",
	            },
            }
            require('mason-nvim-dap').default_setup(config) -- don't forget this!
        end,
    },
})
