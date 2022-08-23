-- Update this path
local extension_path = vim.env.HOME .. '/.vscode/extensions/'
extension_path = string.gsub(extension_path, '\\','/')
local codelldb_path = extension_path .. 'vadimcn.vscode-lldb-1.7.3/adapter/codelldb.exe'
local liblldb_path = extension_path .. 'vadimcn.vscode-lldb-1.7.3/lldb/bin/liblldb.dll'
-- local liblldb_path = extension_path .. 'lanza.lldb-vscode-0.2.3/bin/darwin/lib/liblldb.9.0.0svn.dylib'
-- codelldb_path = string.gsub(codelldb_path, '/', '\\' )
-- liblldb_path = string.gsub(liblldb_path, '/', '\\')

local opts = {
  tools = { -- rust-tools options
    -- automatically set inlay hints (type hints)
    -- there is an issue due to which the hints are not applied on the first
    -- opened file. for now, write to the file to trigger a reapplication of
    -- the hints or just run :rustsetinlayhints.
    -- default: true
    autosethints = true,

    -- whether to show hover actions inside the hover window
    -- this overrides the default hover handler so something like lspsaga.nvim's hover would be overriden by this
    -- default: true
    hover_with_actions = false,

    -- how to execute terminal commands
    -- options right now: termopen / quickfix
    executor = require("rust-tools/executors").termopen,

    -- callback to execute once rust-analyzer is done initializing the workspace
    -- the callback receives one parameter indicating the `health` of the server: "ok" | "warning" | "error"
    on_initialized = nil,

    -- these apply to the default rustsetinlayhints command
    inlay_hints = {

      -- only show inlay hints for the current line
      only_current_line = false,

      -- event which triggers a refersh of the inlay hints.
      -- you can make this "cursormoved" or "cursormoved,cursormovedi" but
      -- not that this may cause higher cpu usage.
      -- this option is only respected when only_current_line and
      -- autosethints both are true.
      only_current_line_autocmd = "cursorhold",

      -- whether to show parameter hints with the inlay hints or not
      -- default: true
      show_parameter_hints = true,

      -- whether to show variable name before type hints with the inlay hints or not
      -- default: false
      show_variable_name = false,

      -- prefix for parameter hints
      -- default: "<-"
      parameter_hints_prefix = "<- ",

      -- prefix for all the other hints (type, chaining)
      -- default: "=>"
      other_hints_prefix = "=> ",

      -- whether to align to the lenght of the longest line in the file
      max_len_align = false,

      -- padding from the left if max_len_align is true
      max_len_align_padding = 1,

      -- whether to align to the extreme right or not
      right_align = false,

      -- padding from the right if right_align is true
      right_align_padding = 7,

      -- the color of the hints
      highlight = "comment",
    },

    -- options same as lsp hover / vim.lsp.util.open_floating_preview()
    hover_actions = {
      -- the border that is used for the hover window
      -- see vim.api.nvim_open_win()
      border = {
        { "╭", "floatborder" },
        { "─", "floatborder" },
        { "╮", "floatborder" },
        { "│", "floatborder" },
        { "╯", "floatborder" },
        { "─", "floatborder" },
        { "╰", "floatborder" },
        { "│", "floatborder" },
      },

      -- whether the hover action window gets automatically focused
      -- default: false
      auto_focus = false,
    },

    -- settings for showing the crate graph based on graphviz and the dot
    -- command
    crate_graph = {
      -- backend used for displaying the graph
      -- see: https://graphviz.org/docs/outputs/
      -- default: x11
      backend = "x11",
      -- where to store the output, nil for no output stored (relative
      -- path from pwd)
      -- default: nil
      output = nil,
      -- true for all crates.io and external crates, false only the local
      -- crates
      -- default: true
      full = true,

      -- list of backends found on: https://graphviz.org/docs/outputs/
      -- is used for input validation and autocompletion
      -- last updated: 2021-08-26
      enabled_graphviz_backends = {
        "bmp",
        "cgimage",
        "canon",
        "dot",
        "gv",
        "xdot",
        "xdot1.2",
        "xdot1.4",
        "eps",
        "exr",
        "fig",
        "gd",
        "gd2",
        "gif",
        "gtk",
        "ico",
        "cmap",
        "ismap",
        "imap",
        "cmapx",
        "imap_np",
        "cmapx_np",
        "jpg",
        "jpeg",
        "jpe",
        "jp2",
        "json",
        "json0",
        "dot_json",
        "xdot_json",
        "pdf",
        "pic",
        "pct",
        "pict",
        "plain",
        "plain-ext",
        "png",
        "pov",
        "ps",
        "ps2",
        "psd",
        "sgi",
        "svg",
        "svgz",
        "tga",
        "tiff",
        "tif",
        "tk",
        "vml",
        "vmlz",
        "wbmp",
        "webp",
        "xlib",
        "x11",
      },
    },
  },

  -- all the opts to send to nvim-lspconfig
  -- these override the defaults set by rust-tools.nvim
  -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
  server = {
    settings = {
      ["rust-analyzer"] = {
        assist = {
          importEnforceGranularity = true,
          importPrefix = "crate"
        },
        cargo = {
          allFeatures = true
        },
        checkOnSave = {
          -- default: `cargo check`
          command = "clippy"
        },
      },
      inlayHints = {
        lifetimeElisionHints = {
          enable = true,
          useParameterNames = true
        },
      },
    },
    -- standalone file support
    -- setting it to false may improve startup time
    standalone = true,
  }, -- rust-analyer options

  -- debugging stuff
  dap = {
    adapter = require('rust-tools.dap').get_codelldb_adapter(
            codelldb_path, liblldb_path),
  },
}

require('rust-tools').setup(opts)
