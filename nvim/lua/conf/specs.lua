require('specs').setup{ 
    show_jumps  = true,
    min_jump = 1,
    popup = {
        delay_ms = 0, -- delay before popup displays
        inc_ms = 5, -- time increments used for fade/resize effects 
        blend = 0, -- starting blend, between 0-100 (fully transparent), see :h winblend
        width = 20,
        winhl = "PMenu",
        fader = require('specs').linear_fader,
        resizer = require('specs').slide_resizer,
    },
    ignore_filetypes = {},
    ignore_buftypes = {
        nofile = true,
    },
}
-- Press <C-b> to call specs!
-- vim.api.nvim_set_keymap('n', '<C-b>', ':lua require("specs").show_specs()', { noremap = true, silent = true })

-- You can even bind it to search jumping and more, example:
-- vim.api.nvim_set_keymap('n', 'n', 'n:lua require("specs").show_specs()<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', 'N', 'N:lua require("specs").show_specs()<CR>', { noremap = true, silent = true })
