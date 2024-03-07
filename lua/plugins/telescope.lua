return {
	'nvim-telescope/telescope.nvim',
	branch = '0.1.x',
	dependencies = {
		'nvim-lua/plenary.nvim',
		-- Fuzzy Finder Algorithm which requires local dependencies to be built.
		-- Only load if `make` is available. Make sure you have the system
		-- requirements installed.
		{
			'nvim-telescope/telescope-fzf-native.nvim',
			-- NOTE: If you are having trouble with this installation,
			-- refer to the README for telescope-fzf-native for more instructions.
			build = 'make',
			cond = function()
				return vim.fn.executable 'make' == 1
			end,
		},
	},
	config = function()
		-- [[ Configure Telescope ]]
		-- See `:help telescope` and `:help telescope.setup()`
		require('telescope').setup {
			defaults = {
				mappings = {
					i = (function()
						local actions = require('telescope.actions')
						return {
							['<C-u>'] = actions.git_reset_soft,
							['<C-d>'] = actions.delete_buffer,
							['<C-n>'] = actions.move_selection_previous,
							['<C-p>'] = actions.move_selection_next,
						}
					end)(),
				},
			},
		}

		-- Enable telescope fzf native, if installed
		pcall(require('telescope').load_extension, 'fzf')

		local telescopefn = require('telescope.builtin')

		-- See `:help telescope.builtin`
		vim.keymap.set('n', '<leader>?', telescopefn.oldfiles, { desc = '[?] Find recently opened files' })
		vim.keymap.set('n', '<leader><space>', telescopefn.buffers, { desc = '[ ] Find existing buffers' })
		vim.keymap.set('n', '<leader>/', function()
			-- You can pass additional configuration to telescope to change theme, layout, etc.
			telescopefn.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
				winblend = 10,
				previewer = false,
			})
		end, { desc = '[/] Fuzzily search in current buffer' })

		vim.keymap.set('n', '<leader>gf', telescopefn.git_files, { desc = 'Search [G]it [F]iles' })
		vim.keymap.set('n', '<leader>sf', telescopefn.find_files, { desc = '[S]earch [F]iles' })
		vim.keymap.set('n', '<leader>sh', telescopefn.help_tags, { desc = '[S]earch [H]elp' })
		vim.keymap.set('n', '<leader>sw', telescopefn.grep_string, { desc = '[S]earch current [W]ord' })
		vim.keymap.set('n', '<leader>sg', telescopefn.live_grep, { desc = '[S]earch by [G]rep' })
		vim.keymap.set('n', '<leader>sd', telescopefn.diagnostics, { desc = '[S]earch [D]iagnostics' })
		vim.keymap.set('n', '<leader>sr', telescopefn.resume, { desc = '[S]earch [R]esume' })
		vim.keymap.set('n', '<leader>sm', telescopefn.marks, { desc = '[S]earch [M]arks' })

		-- Slightly advanced example of overriding default behavior and theme
		vim.keymap.set('n', '<leader>/', function()
			-- You can pass additional configuration to telescope to change theme, layout, etc.
			telescopefn.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
				winblend = 10,
				previewer = false,
			})
		end, { desc = '[/] Fuzzily search in current buffer' })

		-- Also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular pickers
		vim.keymap.set('n', '<leader>s/', function()
			telescopefn.live_grep {
				grep_open_files = true,
				prompt_title = 'Live Grep in Open Files',
			}
		end, { desc = '[S]earch [/] in Open Files' })
	end,
}
