-- 保存本地keymap
local keymap = vim.api.nvim_set_keymap
-- 复用 opt 参数
local opt = {noremap = true, silent = true }
-- Leader Key
vim.g.mapleader = ";"
vim.g.maplocalleader = ";"
-- windows 分屏快捷键
keymap("n", "sv", ":vsp<CR>", opt)
keymap("n", "sh", ":sp<CR>", opt)
-- 关闭当前
keymap("n", "sc", "<C-w>c", opt)
-- 关闭其他
keymap("n", "so", "<C-w>o", opt)
-- Ctrl + hjkl  窗口之间跳转
keymap("n", "<C-h>", "<C-w>h", opt)
keymap("n", "<C-j>", "<C-w>j", opt)
keymap("n", "<C-k>", "<C-w>k", opt)
keymap("n", "<C-l>", "<C-w>l", opt)
-- 左右比例控制
keymap("n", "s]", ":vertical resize -20<CR>", opt)
keymap("n", "s[", ":vertical resize +20<CR>", opt)
-- 上下比例
keymap("n", "s.", ":resize +10<CR>", opt)
keymap("n", "s,", ":resize -10<CR>", opt)
-- 等比例
keymap("n", "s=", "<C-w>=", opt)
-- visual模式下缩进代码
keymap("v", "<", "<gv", opt)
keymap("v", ">", ">gv", opt)
-- 上下移动选中文本
keymap("i", "<A-j>", "<Esc>:m .+1<CR>==i", opt)
keymap("i", "<A-k>", "<Esc>:m .-2<CR>==i", opt)
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==", opt)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==", opt)
-- ctrl u / ctrl + d  只移动9行，默认移动半屏
keymap("n", "<C-u>", "9k", opt)
keymap("n", "<C-d>", "9j", opt)
-- 在visual 模式里粘贴不要复制
keymap("v", "p", '"_dP', opt)
-- insert 模式下，跳到行首行尾
keymap("i", "<C-h>", "<ESC>I", opt)
keymap("i", "<C-l>", "<ESC>A", opt)

-- nvim-tree
-- -- alt + m 键打开关闭tree
keymap("n", "<A-m>", ":NvimTreeToggle<CR>", opt)

-- bufferline
-- 左右Tab切换
keymap("n", "<S-h>", ":BufferLineCyclePrev<CR>", opt)
keymap("n", "<S-l>", ":BufferLineCycleNext<CR>", opt)
keymap("n", "<S-p>", ":BufferLineTogglePin<CR>", opt)
keymap("n", "<S-TAB>", ":BufferLineCyclePrev<CR>", opt)
keymap("n", "<TAB>", ":BufferLineCycleNext<CR>", opt)
-- 关闭
--"moll/vim-bbye"
keymap("n", "<S-w>", ":Bdelete!<CR>", opt)
keymap("n", "<leader>bl", ":BufferLineCloseRight<CR>", opt)
keymap("n", "<leader>bh", ":BufferLineCloseLeft<CR>", opt)
keymap("n", "<leader>bc", ":BufferLinePickClose<CR>", opt)

-- Telescope
-- 查找文件
keymap("n", "<leader>tf", ":Telescope find_files<CR>", opt)
keymap("n", "<leader>tF", ":Telescope live_grep<CR>", opt)
keymap("n", "<leader>tb", ":Telescope buffers<CR>", opt)
keymap("n", "<leader>tm", ":Telescope marks<CR>", opt)
keymap("n", "<leader>tk", ":Telescope keymaps<CR>", opt)

-- debug
keymap("n", "<F9>", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opt)
keymap("n", "<leader>dc", "<cmd>lua require'dap'.set_breakpoint(vim.fn.input '[Condition] > ')<cr>", opt)
keymap("n", "<leader>dm", "<cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<cr>", opt)
keymap("n", "<leader>dr", "lua require'dap'.repl.open()<cr>", opt)
keymap("n", "<Leader>dl", "<cmd>lua require'dap'.run_last()<cr>", opt)
keymap('n', '<C-F5>', '<cmd>lua require"debug-dap.dap-util".reload_continue()<CR>', opt)
keymap("n", "<S-F5>", "<cmd>lua require'dap'.terminate()<cr>", opt)
keymap("n", "<F5>", "<cmd>lua require'dap'.continue()<cr>", opt)
keymap("n", "<F10>", "<cmd>lua require'dap'.step_over()<cr>", opt)
keymap("n", "<F11>", "<cmd>lua require'dap'.step_into()<cr>", opt)
keymap("n", "<F12>", "<cmd>lua require'dap'.step_out()<cr>", opt)
keymap("n", "K", "<cmd>lua require'dapui'.eval()<cr>", opt)
-- keymap("n", "<leader>dt", "<cmd>lua require'dapui'.toggle()<cr>", opt)

-- program
keymap("n", "<A-o>", "<cmd>ClangdSwitchSourceHeader<cr>", opt)
-- file
keymap("n", "<C-s>", "<cmd>w<cr>", opt)
-- lspsaga
--- In lsp attach function
keymap("n", "gr", "<cmd>Lspsaga rename<cr>", opt)
keymap("n", "gx", "<cmd>Lspsaga code_action<cr>", opt)
keymap("x", "gx", ":<c-u>Lspsaga range_code_action<cr>", opt)
keymap("n", "K",  "<cmd>Lspsaga hover_doc<cr>", opt)
keymap("n", "go", "<cmd>Lspsaga show_line_diagnostics<cr>", opt)
keymap("n", "gj", "<cmd>Lspsaga diagnostic_jump_next<cr>", opt)
keymap("n", "gk", "<cmd>Lspsaga diagnostic_jump_prev<cr>", opt)
-- keymap("n", "<C-u>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1, '<c-u>')<cr>", {})
-- keymap("n", "<C-d>", "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1, '<c-d>')<cr>", {})
