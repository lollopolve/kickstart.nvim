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
			whichkey.add({
				{ '<leader>c',    desc = '[C]ode' },
				{ '<leader>d',    desc = '[D]ocument', },
				{ '<leader>g',    desc = '[G]it', },
				{ '<leader>h',    desc = 'Git [H]unk' },
				{ '<leader>t',    desc = '[T]oggle git action' },
				{ '<leader>r',    desc = '[R]ename' },
				{ '<leader>s',    desc = '[S]earch' },
				{ '<leader>w',    desc = '[W]orkspace' },
			})
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
		'stevearc/oil.nvim',
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {},
	},

	{
		'mbbill/undotree',
		opts = {},
		config = function()
			vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle, { desc = '[U]ndo tree' })
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

	{
		'folke/todo-comments.nvim',
		dependencies = { 'nvim-lua/plenary.nvim' },
		opts = { signs = false },
	},

	-- Fuzzy finder
	require 'plugins.telescope',

	{
		'kdheepak/lazygit.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
		config = function()
			local lazygit = require('lazygit')

			vim.keymap.set('n', '<leader>gg', lazygit.lazygit, { desc = 'Open Lazy[G]it' })

			require('telescope').load_extension('lazygit')
		end
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
