local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function ()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
		end,
	},
	{'williamboman/mason.nvim'},
	{'williamboman/mason-lspconfig.nvim'},
	{ "NeogitOrg/neogit",
	  dependencies = {
		  "nvim-lua/plenary.nvim",         -- required
		  "sindrets/diffview.nvim",        -- optional - Diff integration
		  "nvim-telescope/telescope.nvim", -- optional
	  },
	  config = true
  	},
	  -- LSP Support
	{ 'VonHeikemen/lsp-zero.nvim',
	  branch = 'v3.x',
	  lazy = true,
	  config = false,
  	},
	{ 'neovim/nvim-lspconfig',
	  dependencies = {
		  {'hrsh7th/cmp-nvim-lsp'},
	  }
  	},
	-- Autocompletion
  	{ 'hrsh7th/nvim-cmp',
	  dependencies = {
		  {'L3MON4D3/LuaSnip'}
		},
	},
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		opts = {
			style = "storm"
		},
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons"},
		opts = {},
	}

})

vim.cmd[[colorscheme tokyonight]]

local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
  lsp_zero.default_keymaps({buffer = bufnr})
end)
require('mason').setup({})
require('mason-lspconfig').setup({
  handlers = {
    lsp_zero.default_setup,
  },
})
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    -- `Enter` key to confirm completion
    ['<CR>'] = cmp.mapping.confirm({select = false}),

    -- Ctrl+Space to trigger completion menu
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Navigate between snippet placeholder
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),

    -- Scroll up and down in the completion documentation
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  })
})

local wk = require("which-key")
wk.register(mappings, opts)
