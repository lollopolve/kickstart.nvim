require('options')
require('keymaps')

if vim.g.vscode then
	return
end

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	}
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	-- Useful plugin to show you pending keybinds.
	{
		'folke/which-key.nvim',
		event = 'VeryLazy',
		opts = {},
		config = function()
			local whichkey = require('which-key')

			-- document existing key chains
			whichkey.register {
				['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
				['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
				['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
				['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
				['<leader>t'] = { name = '[T]oggle git action', _ = 'which_key_ignore' },
				['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
				['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
				['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
			}
		end
	},

	-- Set lualine as statusline
	-- See `:help lualine.txt`
	{
		'nvim-lualine/lualine.nvim',
		opts = {
			options = {
				icons_enabled = false,
				theme = 'onedark',
				component_separators = '|',
				section_separators = '',
			},
		},
	},

	-- Theme inspired by Atom
	{
		'navarasu/onedark.nvim',
		priority = 1000,
		config = function()
			require('onedark').setup {
				style = 'warmer',
			}
			vim.cmd.colorscheme 'onedark'
		end,
	},

	-- Detect tabstop and shiftwidth automatically
	'tpope/vim-sleuth',

	-- Add indentation guides even on blank lines
	-- Enable `lukas-reineke/indent-blankline.nvim`
	-- See `:help indent_blankline.txt`
	{
		'lukas-reineke/indent-blankline.nvim',
		main = 'ibl',
		opts = {},
	},

	{
		'mbbill/undotree',
		opts = {},
		config = function()
			vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = "[U]ndo tree" })
		end,
	},

	-- "gc" to comment visual regions/lines
	{ 'numToStr/Comment.nvim', opts = {} },

	-- Autoclose brackets
	{
		'm4xshen/autoclose.nvim',
		opts = {
			disable_filetypes = { 'text', 'markdown' },
		},
	},

	{
		'folke/todo-comments.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		opts = { signs = false },
	},

	-- Fuzzy finder
	require 'plugins.telescope',

	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = true,
	},

	-- Adds git related signs to the gutter, as well as utilities for managing changes
	-- See `:help gitsigns.txt`
	require 'plugins.gitsigns',

	-- Language Server Protocol
	require 'plugins.lsp',

	-- Autoformat
	{
		'stevearc/conform.nvim',
		opts = {
			notify_on_error = false,
			format_on_save = {
				timeout_ms = 500,
				lsp_fallback = true,
			},
			formatters_by_ft = {
				lua = { 'stylua' },
				-- Conform will run multiple formatters sequentially
				-- python = { "isort", "black" },
				-- Use a sub-list to run only the first available formatter
				-- javascript = { { "prettierd", "prettier" } },
			},
		},
	},

	-- Autocompletion
	require 'plugins.cmp',

	-- Highlight, edit, and navigate code
	-- See `:help nvim-treesitter`
	require 'plugins.treesitter',

	-- Debug Adapter Protocol
	require 'plugins.dap',
})
