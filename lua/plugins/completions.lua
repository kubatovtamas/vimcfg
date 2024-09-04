return {
	{
		"hrsh7th/cmp-nvim-lsp",
	},
	{
		"L3MON4D3/LuaSnip",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
	},
	{ "hrsh7th/cmp-buffer" },
	{ "FelipeLema/cmp-async-path" },
	{ "hrsh7th/cmp-cmdline" },
	{ "onsails/lspkind-nvim" },
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			require("lsp_signature").setup(opts)
		end,
	},
	{
		"linux-cultist/venv-selector.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
			"mfussenegger/nvim-dap",
			"mfussenegger/nvim-dap-python", --optional
			{ "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
		},
		branch = "regexp",
		lazy = false,
		config = function()
			require("venv-selector").setup({
				pipenv_path = "/Users/kuba/.local/share/virtualenvs",
				pyenv_path = "/Users/kuba/.pyenv",
				settings = {
					search = {
						my_venvs = {
							command = "fd '(python|python3(.[0-9]+)?)$' ~/code/ --type x --type l --hidden --no-ignore",
						},
					},
					options = {
						on_venv_activate_callback = nil, -- callback function for after a venv activates
						enable_default_searches = true, -- switches all default searches on/off
						enable_cached_venvs = true, -- use cached venvs that are activated automatically when a python file is registered with the LSP.
						cached_venv_automatic_activation = true, -- if set to false, the VenvSelectCached command becomes available to manually activate them.
						activate_venv_in_terminal = true, -- activate the selected python interpreter in terminal windows opened from neovim
						set_environment_variables = true, -- sets VIRTUAL_ENV or CONDA_PREFIX environment variables
						notify_user_on_venv_activation = true, -- notifies user on activation of the virtual env
						search_timeout = 10, -- if a search takes longer than this many seconds, stop it and alert the user
						debug = true, -- enables you to run the VenvSelectLog command to view debug logs
						-- fd_binary_name = M.find_fd_command_name(), -- plugin looks for `fd` or `fdfind` but you can set something else here
						require_lsp_activation = true, -- require activation of an lsp before setting env variables

						-- telescope viewer options
						on_telescope_result_callback = nil, -- callback function for modifying telescope results
						show_telescope_search_type = true, -- shows which of the searches found which venv in telescope
						telescope_filter_type = "substring", -- when you type something in telescope, filter by "substring" or "character"
					},
				},
			})
		end,
		keys = {
			{ "<leader>pvs", "<cmd>VenvSelect<cr>" },
			-- { "<leader>pvc", "<cmd>VenvSelectCached<cr>" },
			-- { "<leader>pvl", "<cmd>VenvSelectCurrent<cr>" },
		},
	},
	{
		"hrsh7th/nvim-cmp",
		event = { "InsertEnter", "CmdlineEnter" },
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")
			require("luasnip.loaders.from_vscode").lazy_load()

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({ select = false }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if luasnip.expandable() then
							luasnip.expand()
						elseif cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.jumpable(1) then
							luasnip.jump(1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
					{ name = "async_path" },
					-- { name = "rg" },
				}),
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text", -- show only symbol annotations
						maxwidth = 75, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
						-- can also be a function to dynamically calculate max width such as
						-- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
						ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
					}),
				},
			})
			-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})
		end,
	},
}
