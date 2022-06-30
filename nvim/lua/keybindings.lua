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


