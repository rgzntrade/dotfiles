local status, legendary = pcall(require, 'legendary')
if not status then
  vim.notify('legendary not found!')
  return
end
legendary.setup({
  keymaps = {
    -- map keys to a command
    { '<leader>ff', ':Telescope find_files', description = 'Find files' },
    -- map keys to a function
    -- {
    --   '<leader>h',
    --   function()
    --     print('hello world!')
    --   end,
    --   description = 'Say hello',
    -- },
    -- Set options used during keymap creation
    -- { '<leader>s', ':SomeCommand<CR>', description = 'Non-silent keymap', opts = { silent = true } },
    -- create keymaps with different implementations per-mode
    -- {
    --   '<leader>c',
    --   { n = ':LinewiseCommentToggle<CR>', x = ":'<,'>BlockwiseCommentToggle<CR>" },

    --   description = 'Toggle comment',
    -- },
    -- create item groups to create sub-menus in the finder
    -- note that only keymaps, commands, and functions
    -- can be added to item groups
    {
      -- groups with same itemgroup will be merged
      itemgroup = 'short ID',
      description = 'A submenu of items...',
      icon = '',
      keymaps = {

        -- more keymaps here
      },
    },
    -- in-place filters, see :h legendary-tables or ./doc/table_structures/README.md
    { '<leader>m', description = 'Preview markdown', filters = { ft = 'markdown' } },
  },
  commands = {
    -- easily create user commands
    {
      ':SayHello',
      function()

        print('hello world!')
      end,

      description = 'Say hello as a command',
    },
    {
      -- groups with same itemgroup will be merged
      itemgroup = 'short ID',
      -- don't need to copy the other group data because
      -- it will be merged with the one from the keymaps table
      commands = {
        -- more commands here
      },
    },
    -- in-place filters, see :h legendary-tables or ./doc/table_structures/README.md
    { ':Glow', description = 'Preview markdown', filters = { ft = 'markdown' } },
  },
  funcs = {
    -- Make arbitrary Lua functions that can be executed via the item finder
    {
      function()
        doSomeStuff()
      end,
      description = 'Do some stuff with a Lua function!',
    },
    {
      -- groups with same itemgroup will be merged
      itemgroup = 'short ID',
      -- don't need to copy the other group data because

      -- it will be merged with the one from the keymaps table
      funcs = {
        -- more funcs here
      },
    },
  },
  autocmds = {
    -- Create autocmds and augroups
    { 'BufWritePre', vim.lsp.buf.format, description = 'Format on save' },
    {
      name = 'MyAugroup',
      clear = true,

      -- autocmds here
    },
  },
  -- which-key
  which_key = {
    -- Automatically add which-key tables to legendary
    -- see ./doc/WHICH_KEY.md for more details
    auto_register = true,
    -- you can put which-key.nvim tables here,
    -- or alternatively have them auto-register,
    -- see ./doc/WHICH_KEY.md
    mappings = {},
    opts = {},
    -- controls whether legendary.nvim actually binds they keymaps,
    -- or if you want to let which-key.nvim handle the bindings.
    -- if not passed, true by default
    do_binding = true,
  },
  -- load extensions
  extensions = {
    -- load keymaps and commands from nvim-tree.lua
    nvim_tree = true,
    -- load commands from smart-splits.nvim
    -- and create keymaps, see :h legendary-extensions-smart-splits.nvim
    smart_splits = {

      directions = { 'h', 'j', 'k', 'l' },
      mods = {
        move = '<C>',
        resize = '<M>',
      },
    },
    -- load commands from op.nvim
    op_nvim = true,
    -- load keymaps from diffview.nvim
    diffview = true,
  },
})
