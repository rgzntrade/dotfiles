local fn = vim.fn

-- 自动安装 packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- 每次保存 plugins.lua 自动安装插件
-- pcall(
--  vim.cmd,
--   [[
-- augroup packer_user_config
-- autocmd!
-- autocmd BufWritePost plugins.lua source <afile> | PackerSync
-- augroup end
-- ]]
-- )

-- packer 安装准备就绪前直接返回
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

packer.init {
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'single' })
    end
  }
}

packer.startup({function()
  -- Packer 可以管理自己本身
  use 'wbthomason/packer.nvim'
  --  模块缓存
  use 'lewis6991/impatient.nvim'
  -- 插件列表...
  use('olimorris/onedarkpro.nvim')
  -- 文件管理
  use({ "kyazdani42/nvim-tree.lua", requires = "kyazdani42/nvim-web-devicons" })
  -- lualine 
  use({ "nvim-lualine/lualine.nvim", requires = { "kyazdani42/nvim-web-devicons" }})
  -- 顶部标签
  use({ "akinsho/bufferline.nvim", requires = { "kyazdani42/nvim-web-devicons", "moll/vim-bbye" }})
  -- telescope 
  use { 'nvim-telescope/telescope.nvim', requires = { "nvim-lua/plenary.nvim" } }
  use {"nvim-telescope/telescope-ui-select.nvim"}
  use { "nvim-telescope/telescope-file-browser.nvim" }
  use { "nvim-telescope/telescope-project.nvim" }
  -- alpha-nvim 
  use "goolord/alpha-nvim"
  -- project
  use("ahmedkhalf/project.nvim")
  -- session
  use "Shatur/neovim-session-manager"
  -- which-key
  use "folke/which-key.nvim"
  use "mrjones2014/legendary.nvim"
  -- Treesittetr
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  }
  --  nvim-lspconfig and installer 
  use {
    "williamboman/nvim-lsp-installer",
    "neovim/nvim-lspconfig",
  }
  use ("romgrk/nvim-treesitter-context")
  use ("nvim-treesitter/nvim-treesitter-textobjects")
  use {
    "ray-x/lsp_signature.nvim",
  }
  use {
    "folke/trouble.nvim",
    requires = "kyazdani42/nvim-web-devicons",
  }
  use {'mizlan/iswap.nvim'}
  use 'booperlv/nvim-gomove'
  -- 补全引擎
  use("hrsh7th/nvim-cmp")
  -- snippet 引擎
  use("hrsh7th/vim-vsnip")
  -- 补全源
  use("hrsh7th/cmp-vsnip")
  use("hrsh7th/cmp-nvim-lsp") -- { name = nvim_lsp }
  use("hrsh7th/cmp-buffer") -- { name = 'buffer' },
  use("hrsh7th/cmp-path") -- { name = 'path' }
  use("hrsh7th/cmp-cmdline") -- { name = 'cmdline' }

  local path_sep = package.config:sub(1, 1)
  if path_sep == '\\' then
        use {'tzachar/cmp-tabnine', after = "nvim-cmp", run='powershell ./install.ps1', requires = 'hrsh7th/nvim-cmp'}
  elseif path_sep == '/' then
        use {'tzachar/cmp-tabnine', run='./install.sh', requires = 'hrsh7th/nvim-cmp'}
  else
      print("Unknown OS")
  end
  print("查看有没有其它问题,这个消息每次都能看到")
  use {"windwp/nvim-autopairs"}
  -- use "terrortylor/nvim-comment"
  use { 'numToStr/Comment.nvim' }
  use {"kylechui/nvim-surround"}
  use { 'kkharji/lspsaga.nvim' }  
  use {'simrat39/symbols-outline.nvim'}
  -- 常见编程语言代码段
  use("rafamadriz/friendly-snippets")
  -- rust-tools
  use {"simrat39/rust-tools.nvim" }
  -- debug
  use("mfussenegger/nvim-dap")
  use("theHamsta/nvim-dap-virtual-text")
  use("rcarriga/nvim-dap-ui")
  use ("nvim-telescope/telescope-dap.nvim")
  use ("nvim-telescope/telescope-packer.nvim")
  use {
    "nvim-telescope/telescope-frecency.nvim", requires = {"kkharji/sqlite.lua"}
  }
  use {'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
  -- git
  use {
    "lewis6991/gitsigns.nvim",
    tag = "v0.6",
  }
  -- dirrview 
  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
  -- terminal
  use {"akinsho/toggleterm.nvim",} 
  -- todo 
  -- Lua
  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
  }
  -- clangd
  use {"p00f/clangd_extensions.nvim"}
  -- cmake
  use {"Shatur/neovim-cmake"}
  --  motion
  use {
    "phaazon/hop.nvim", -- like easymotion, but more powerful
    branch = "v2", -- optional but strongly recommended
  }
  use {'ggandor/leap.nvim', require = 'tpope/vim-repeat'}

  use {"d86leader/vim-cpp-helper"}
  -- translator
  use "voldikss/vim-translator"
  -- save and reload
  use "Pocco81/AutoSave.nvim"
  use "djoshea/vim-autoread"
  -- 管理工具lsp dap linter format
  use { "williamboman/mason.nvim" }
  use {
    'sudormrfbin/cheatsheet.nvim',

    requires = {
      {'nvim-telescope/telescope.nvim'},
      {'nvim-lua/popup.nvim'},
      {'nvim-lua/plenary.nvim'},
    }
  }
  use 'karb94/neoscroll.nvim' --平滑滚动
  use {'edluffy/specs.nvim'} --位置提示
  use {'rcarriga/nvim-notify'} -- 提示框
  -- init.lua
  use "lukas-reineke/indent-blankline.nvim"
  use "chentoast/marks.nvim"
  use { 'NvChad/nvim-colorizer.lua'}
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end
})
