return {
	'neovim/nvim-lspconfig',
	dependencies = {
		-- Automatically install LSPs to stdpath for neovim
		{ 'williamboman/mason.nvim',           opts = {} },
		{ 'williamboman/mason-lspconfig.nvim', opts = {} },

		-- Useful status updates for LSP
		{ 'j-hui/fidget.nvim',                 opts = {} },

		-- Additional lua configuration, makes nvim stuff amazing!
		{ 'folke/neodev.nvim',                 opts = {} },
	},
	config = function()
		local servers = {
			clangd = {},
			rust_analyzer = {},
			-- zls = {},
			gopls = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
				},
			},
			lua_ls = {
				settings = {
					Lua = {
						runtime = { version = 'LuaJIT' },
						workspace = {
							checkThirdParty = false,
							library = {
								'${3rd}/luv/library',
								unpack(vim.api.nvim_get_runtime_file('', true)),
							},
						},
						completion = {
							callSnippet = 'Replace',
						},
					},
				},
			},
			phpactor = {},
			templ = { filetypes = { 'templ' } },
			html = { filetypes = { 'html', 'twig' } },
		}

		-- Ensure the servers above are installed
		local mason_lspconfig = require 'mason-lspconfig'
		mason_lspconfig.setup {
			ensure_installed = vim.tbl_keys(servers),
		}

		-- [[ Configure LSP ]]
		--  This function gets run when an LSP connects to a particular buffer.
		local on_attach = function(_, bufnr)
			local nmap = function(keys, func, desc)
				if desc then
					desc = 'LSP: ' .. desc
				end

				vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
			end

			-- Navigation
			nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
			nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
			nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
			nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
			nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
			nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
			nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

			-- Actions
			nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
			nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

			-- Hover
			nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
			nmap('<leader>k', vim.lsp.buf.signature_help, 'Signature Documentation')

			-- Lesser used LSP functionality
			nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
			nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
			nmap('<leader>wl', function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, '[W]orkspace [L]ist Folders')

			-- Create a command `:Format` local to the LSP buffer
			vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
				vim.lsp.buf.format()
			end, { desc = 'Format current buffer with LSP' })
		end

		-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
		mason_lspconfig.setup_handlers {
			function(server_name)
				require('lspconfig')[server_name].setup {
					capabilities = capabilities,
					on_attach = on_attach,
					settings = servers[server_name],
					filetypes = (servers[server_name] or {}).filetypes,
				}
			end,
		}

		-- using custom config for zls
		require 'lspconfig'.zls.setup {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				warn_style = true,
				zig_exe_path = '/home/lollopolve/bin/zig/zig',
				zig_lib_path = '/home/lollopolve/bin/zig/lib',
			}
		}

		-- Go auto goimports
		vim.api.nvim_create_autocmd('BufWritePre', {
			pattern = '*.go',
			callback = function()
				local params = vim.lsp.util.make_range_params()
				params.context = { only = { 'source.organizeImports' } }
				-- buf_request_sync defaults to a 1000ms timeout. Depending on your
				-- machine and codebase, you may want longer. Add an additional
				-- argument after params if you find that you have to write the file
				-- twice for changes to be saved.
				-- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
				local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params)
				for cid, res in pairs(result or {}) do
					for _, r in pairs(res.result or {}) do
						if r.edit then
							local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or 'utf-16'
							vim.lsp.util.apply_workspace_edit(r.edit, enc)
						end
					end
				end
				vim.lsp.buf.format({ async = false })
			end
		})
	end,
}
