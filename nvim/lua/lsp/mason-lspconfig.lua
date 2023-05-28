local status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not status then
  vim.notify("nvim-lsp-installer")
  return
end
mason_lspconfig.setup{
   -- A list of servers to automatically install if they're not already installed. Example: { "rust_analyzer@nightly", "lua_ls" }
    -- This setting has no relation with the `automatic_installation` setting.
    ---@type string[]
    ensure_installed = { "lua_ls", "rust_analyzer", "clangd", "cmake",
        "lemminx", "marksman", "taplo", "pylyzer" },

    -- Whether servers that are set up (via lspconfig) should be automatically installed if they're not already installed.
    -- This setting has no relation with the `ensure_installed` setting.
    -- Can either be:
    --   - false: Servers are not automatically installed.
    --   - true: All servers set up via lspconfig are automatically installed.
    --   - { exclude: string[] }: All servers set up via lspconfig, except the ones provided in the list, are automatically installed.
    --       Example: automatic_installation = { exclude = { "rust_analyzer", "solargraph" } }
    ---@type boolean
    automatic_installation = true,

    -- See `:h mason-lspconfig.setup_handlers()`
    ---@type table<string, fun(server_name: string)>?
    handlers = nil,
}

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
 -- vim.keymap.set('n', '[d', vim.diagnostic.goto_pstructlogrev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

local lspconfig = require("lspconfig")
local function on_attach(client, buffer) -- set up buffer keymaps, etc.
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', 'gR', vim.lsp.buf.references, bufopts)
  require "lsp_signature".on_attach()
end

local lsp_flags = {
  debounce_text_changes = 100,
}

-- Setup lspconfig.
-- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
--
lspconfig.lua_ls.setup {
  on_attach = on_attach,
  flags = lsp_flags,
  -- capabilities = capabilities,
  settings = require("lsp.lua"),
}

lspconfig.pylyzer.setup {
  on_attach = on_attach,
  flags = lsp_flags,
  -- capabilities = capabilities,
  settings = require("lsp.python"),
}
--
lspconfig.rust_analyzer.setup({
  on_attach=on_attach,
  flags = lsp_flags,
  settings = require("lsp.rust")})
