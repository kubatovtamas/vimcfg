return {
	{
		"williamboman/mason.nvim",
		lazy = false,
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		lazy = false,
		opts = {
			auto_install = true,
		},
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ruff_lsp",
					"jedi_language_server",
					"pyright",
					"marksman",
				},
				automatic_installation = true,
				modifiable = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		lazy = false,
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")

			local opts = { noremap = true, silent = true }

			vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

			vim.keymap.set(
				"n",
				"<leader>ge",
				vim.diagnostic.setloclist,
				{ desc = "[e]rrors (loclist)", noremap = true, silent = true }
			)
			vim.keymap.set("n", "<leader>lo", ":lopen<cr>", { noremap = true, silent = true })
			vim.keymap.set("n", "<leader>lc", ":lclose<cr>", { noremap = true, silent = true })

            print('DEBUG MESSAGE reee')
			local on_attach_base = function(client, bufnr)
                print('Starting' .. vim.inspect(client))
				-- local bufopts = { noremap = true, silent = true, buffer = bufnr }
				local bufopts = { noremap = true, buffer = bufnr }

				vim.api.nvim_set_keymap("i", "<c-tab>", "<c-x><c-o>", { noremap = true, silent = true })
				vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

				vim.keymap.set("n", "gd", vim.lsp.buf.declaration, bufopts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
				vim.keymap.set("n", "k", vim.lsp.buf.hover, bufopts)
				vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, bufopts)
				vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
				vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
				vim.keymap.set("n", "<leader>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, bufopts)
			vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)

				vim.keymap.set(
					"n",
					"<leader>ga",
					vim.lsp.buf.code_action,
					{ noremap = true, silent = true, buffer = bufnr, desc = "Code [A]ction" }
				)

				vim.keymap.set(
					"n",
					"gr",
					vim.lsp.buf.references,
					{ noremap = true, silent = true, buffer = bufnr, desc = "[R]eferences (quickfixlist)" }
				)
				vim.keymap.set("n", "<leader>qo", ":copen<CR>", { noremap = true, silent = true })
				vim.keymap.set("n", "<leader>qc", ":cclose<CR>", { noremap = true, silent = true })
			end

			local on_attach_ruff = function(client, bufnr)
				-- Disable features that Pyright will handle
				client.server_capabilities.hoverProvider = false
				client.server_capabilities.definitionProvider = false
				client.server_capabilities.referencesProvider = false
				client.server_capabilities.diagnosticProvider = true
				-- Add other capabilities that you want to disable here

				-- Keep the formatting feature
				if client.server_capabilities.documentFormattingProvider then
					vim.keymap.set("n", "<leader>gf", function()
						vim.lsp.buf.format({ async = true })
					end, { buffer = bufnr, desc = "[F]ormat" })
				end
			end

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach_base,
			})

			lspconfig.marksman.setup({
				capabilities = capabilities,
				on_attach = on_attach_base,
			})

			lspconfig.pyright.setup({
				capabilities = capabilities,
				on_attach = on_attach_base,
			})

			lspconfig.ruff_lsp.setup({
				capabilities = capabilities,
				on_attach = on_attach_ruff,
				init_options = {
					settings = {
						args = {},
					},
				},
			})
		end,
	},
}
