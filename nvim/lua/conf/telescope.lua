local status, telescope = pcall(require, "telescope")
if not status then
  vim.notify("没有找到 telescope")
  return
end

telescope.setup({
  defaults = {
    -- 打开弹窗后进入的初始模式，默认为 insert，也可以是 normal
    initial_mode = "insert",
    -- 窗口内快捷键
   mappings = {
      i = {
        ["<C-n>"] = cycle_history_next,
        ["<C-p>"] = cycle_history_prev,

        ["<C-j>"] = move_selection_next,
        ["<C-k>"] = move_selection_previous,

        ["<C-c>"] = close,

        ["<Down>"] = move_selection_next,
        ["<Up>"] = move_selection_previous,

        ["<CR>"] = select_default,
        ["<C-x>"] = select_horizontal,
        ["<C-v>"] = select_vertical,
        ["<C-t>"] = select_tab,

        ["<C-u>"] = preview_scrolling_up,
        ["<C-d>"] = preview_scrolling_down,

        ["<PageUp>"] = results_scrolling_up,
        ["<PageDown>"] = results_scrolling_down,

        ["<Tab>"] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_worse,
        ["<S-Tab>"] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_better,
        ["<C-q>"] = require('telescope.actions').send_to_qflist + require('telescope.actions').open_qflist,
        ["<M-q>"] = require('telescope.actions').send_selected_to_qflist + require('telescope.actions').open_qflist,
        ["<C-l>"] = complete_tag,
        ["<C-_>"] = which_key, -- keys from pressing <C-/>
      },

      n = {
        ["<esc>"] = close,
        ["<CR>"] = select_default,
        ["<C-x>"] = select_horizontal,
        ["<C-v>"] = select_vertical,
        ["<C-t>"] = select_tab,

        ["<Tab>"] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_worse,
        ["<S-Tab>"] = require('telescope.actions').toggle_selection + require('telescope.actions').move_selection_better,
        ["<C-q>"] = require('telescope.actions').send_to_qflist + require('telescope.actions').open_qflist,
        ["<M-q>"] = require('telescope.actions').send_selected_to_qflist + require('telescope.actions').open_qflist,

        ["j"] = move_selection_next,
        ["k"] = move_selection_previous,
        ["H"] = move_to_top,
        ["M"] = move_to_middle,
        ["L"] = move_to_bottom,

        ["<Down>"] = move_selection_next,
        ["<Up>"] = move_selection_previous,
        ["gg"] = move_to_top,
        ["G"] = move_to_bottom,

        ["<C-u>"] = preview_scrolling_up,
        ["<C-d>"] = preview_scrolling_down,

        ["<PageUp>"] = results_scrolling_up,
        ["<PageDown>"] = results_scrolling_down,

        ["?"] = which_key,
      },
    },
  },
  pickers = {
    -- 内置 pickers 配置
    find_files = {
      -- 查找文件换皮肤，支持的参数有： dropdown, cursor, ivy
      -- theme = "dropdown", 
    }
  },
  extensions = {
   fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown{
        -- even more opts
      },
    },-- 扩展插件配置
  }
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("dap")
require("telescope").load_extension("ui-select")
