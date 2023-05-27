local status, cmp = pcall(require, "cmp")
if not status then
  vim.notify("cmp not found!")
  return
end

cmp.setup({
  -- 指定 snippet 引擎
  snippet = {
    expand = function(args)
      -- For `vsnip` users.
      -- vim.fn["vsnip#anonymous"](args.body)

      -- For `luasnip` users.
      require('luasnip').lsp_expand(args.body)

      -- For `ultisnips` users.
      -- vim.fn["UltiSnips#Anon"](args.body)

      -- For `snippy` users.
      -- require'snippy'.expand_snippet(args.body)
    end,
  },
  -- 补全源
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    -- For vsnip users.
    { name = "vsnip" },
    { name = "cmp_tabnine" },
    { name = "treesitter" },

    -- For luasnip users.
    { name = 'luasnip' },

    --For ultisnips users.
    -- { name = 'ultisnips' },

    -- -- For snippy users.
    -- { name = 'snippy' },
  }, { { name = "buffer" }, { name = "path" } }),

  -- 快捷键设置
  mapping = {
    -- 出现补全
    ["<A-.>"] = cmp.mapping(cmp.mapping.complete(), {"i", "c"}),
    -- 取消
    ["<A-,>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close()
    }),
    -- 上一个
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    -- 下一个
    ["<C-j>"] = cmp.mapping.select_next_item(),
    -- 确认
    ["<CR>"] = cmp.mapping.confirm({
      select = false,
      behavior = cmp.ConfirmBehavior.Replace
    }),
    -- 如果窗口内容太多，可以滚动
    ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), {"i", "c"}),
    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), {"i", "c"}),
    -- 自定义代码段跳转到下一个参数
    -- ["<C-l>"] = cmp.mapping(function(_)
    --   if vim.fn["vsnip#available"](1) == 1 then
    --     feedkey("<Plug>(vsnip-expand-or-jump)", "")
    --   end
    -- end, {"i", "s"}),

    -- 自定义代码段跳转到上一个参数
    -- ["<C-h>"] = cmp.mapping(function()
    --   if vim.fn["vsnip#jumpable"](-1) == 1 then
    --     feedkey("<Plug>(vsnip-jump-prev)", "")
    --   end
    -- end, {"i", "s"}),

    -- Super Tab
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      -- elseif vim.fn["vsnip#available"](1) == 1 then
      --   feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, {"i", "s"}),

    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      -- elseif vim.fn["vsnip#jumpable"](-1) == 1 then
      --   feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, {"i", "s"})
    -- end of super Tab
  }
})

-- / 查找模式使用 buffer 源
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

-- : 命令行模式中使用 path 和 cmdline 源.
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
      { name = "cmdline" },
    }),
})
