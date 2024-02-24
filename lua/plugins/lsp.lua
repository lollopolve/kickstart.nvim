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
			zls = {},
			gopls = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
				},
			},
			lua_ls = {
				Lua = {
					workspace = { checkThirdParty = false },
					telemetry = { enable = false },
					-- NOTE: toggle below to ignore Lua_LS's noisy `missing-fields` warnings
					-- diagnostics = { disable = { 'missing-fields' } },
				},
			},
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
	end,
}
