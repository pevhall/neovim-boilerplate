--[[
  File: plugins.lua
  Description: This file needed for loading plugin list into lazy.nvim and loading plugins
  Info: Use <zo> and <zc> to open and close foldings
  See: https://github.com/folke/lazy.nvim
]]

require "helpers/globals"

return {
  -- Mason {{{
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      require "extensions.mason"
    end
  },
  -- }}}

  -- Neo Tree {{{
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
    },
    config = function ()
      require "extensions.neotree"
    end
  },
  -- }}}

  -- Telescope {{{
  {  -- use FZF within telescop
    'nvim-telescope/telescope-fzf-native.nvim', 
    build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.1',
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "ahmedkhalf/project.nvim",
    },
    config = function()
      require "extensions.telescope"
    end
  },
  -- }}}

--{{{ luasnip 
  {
    "L3MON4D3/LuaSnip",
    -- follow latest release.
    version = "2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    -- install jsregexp (optional!).
    build = "make install_jsregexp",
    config = function()
      require "extensions.luasnip"
    end
  }, -- }}}

  -- CMP {{{
  { 'tzachar/fuzzy.nvim', requires = {'nvim-telescope/telescope-fzf-native.nvim'} }, --fuzzy functions below required this
  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = {
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'tzachar/cmp-fuzzy-buffer',
--      'tzachar/cmp-fuzzy-path', --requires fd
      'hrsh7th/cmp-path',
--      'hrsh7th/cmp-emoji',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-nvim-lua',
    },
    config = function()
      require "extensions.cmp"
    end
  },
  -- }}}

  -- LSP Kind {{{
  {
    'onsails/lspkind-nvim',
    lazy = true,
    config = function()
      require "extensions.lspkind"
    end
  },
  -- }}}

  -- Git Signs {{{
  {
    'lewis6991/gitsigns.nvim',
    lazy = false,
    config = function()
      require "extensions.gitsigns"
    end
  },
  -- }}}

  -- Trouble {{{
  {
    "folke/trouble.nvim",
    lazy = true,
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require "extensions.trouble"
    end,
  },
  -- }}}

  -- TreeSitter {{{
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = false,
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require "extensions.treesitter"
    end
  },
  -- }}}

--{{{ TreeSitter TextObjects
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    config = function()
      require "extensions.treesitter_textobjects"
    end
  },

--}}}

--{{{ TreeSitter Context
  {
    'nvim-treesitter/nvim-treesitter-context',
  },

--}}}

  -- vim-visual-multi {{{
  {
    'mg979/vim-visual-multi',
  },
  -- }}}

  --  {{{ indent-blankline.nvim
  {
    'lukas-reineke/indent-blankline.nvim',
    config = function()
      require "extensions.indent_blankline"
    end,
  },
  -- }}}

  -- Theme: Sonokai {{{
  {
    "sainnhe/sonokai",
    lazy = false,
    config = function ()
      require "extensions.colorscheme.sonokai"
    end
  },
  -- }}}

  -- Theme: Material {{{
  {
    "marko-cerovac/material.nvim",
    config = function()
      require "extensions.colorscheme.material"
    end,
  },
  -- }}}

  -- Theme: Tokyonight {{{
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      require('tokyonight').setup ({
--       lualine_bold = true,
--       sidebars = { "qf", "vista_kind", "terminal", "packer" },
      })
    end,
  },
  -- }}}

  --  {{{ lualine
  {
    'nvim-lualine/lualine.nvim',
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require('lualine').setup {
        options = {
          theme = 'tokyonight'
        }
      }
    end,
  },
  -- }}}

}

-- vim:tabstop=2 shiftwidth=2 expandtab syntax=lua foldmethod=marker foldlevelstart=0 foldlevel=0
