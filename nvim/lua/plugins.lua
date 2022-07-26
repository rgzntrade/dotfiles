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
pcall(
  vim.cmd,
  [[
augroup packer_user_config
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerSync
augroup end
]]
)

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
  -- alpha-nvim 
  use "goolord/alpha-nvim"
  -- project
  use("ahmedkhalf/project.nvim")
  -- session
  use "Shatur/neovim-session-manager"
  -- which-key
  use "folke/which-key.nvim"
  --- zf-native 
  use "natecraddock/telescope-zf-native.nvim"
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
use "romgrk/nvim-treesitter-context"
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

  -- 常见编程语言代码段
  use("rafamadriz/friendly-snippets")
  -- rust-tools
  use {"simrat39/rust-tools.nvim" }
  -- debug
  use("mfussenegger/nvim-dap")
  use("theHamsta/nvim-dap-virtual-text")
  use("rcarriga/nvim-dap-ui")
  use ("nvim-telescope/telescope-dap.nvim")
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end
})
