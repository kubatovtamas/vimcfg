-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "TelescopeResults",
--   callback = function(ctx)
--     vim.api.nvim_buf_call(ctx.buf, function()
--       vim.fn.matchadd("TelescopeParent", "\t\t.*$")
--       vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
--     end)
--   end,
-- })
--
-- local function filenameFirst(_, path)
--   local tail = vim.fs.basename(path)
--   local parent = vim.fs.dirname(path)
--   if parent == "." then
--     return tail
--   end
--   return string.format("%s\t\t%s", tail, parent)
-- end

return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {
                    path_display = { "smart" },
					layout_config = {
						center = {
							height = 0.4,
							preview_cutoff = 40,
							prompt_position = "top",
							width = 0.5,
						},
						horizontal = {
							height = 0.9,
							preview_cutoff = 120,
                            preview_width = 0.4,
							prompt_position = "bottom",
							width = 0.9,
						},
					},
				},
				pickers = {
					find_files = {
						theme = "dropdown",
					},
					live_grep = {
						theme = "dropdown",
					},
				},
				extensions = {},
			})

			local builtin = require("telescope.builtin")

			-- File Pickers
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]iles" })
			vim.keymap.set("n", "<leader>fgr", builtin.live_grep, { desc = "[GR]ep" })
			vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[W]ord" })

			-- Vim Pickers
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[H]elp" })
			vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[K]eymaps" })
			vim.keymap.set("n", "<leader>fm", builtin.man_pages, { desc = "[M]an" })

			vim.keymap.set("n", "<leader>f.", builtin.oldfiles, { desc = 'Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader>fv", builtin.git_files, { desc = "[V]ersion Controlled Files" })
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[B]uffers" })

			vim.keymap.set("n", "<leader>fs", builtin.builtin, { desc = "[S]ettings" })
			vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "[R]esume" })

			-- LSP Pickers
			vim.keymap.set("n", "<leader>flr", builtin.lsp_references, { desc = "[L]sp [R]eferences" })
			vim.keymap.set("n", "<leader>fli", builtin.lsp_incoming_calls, { desc = "[L]sp [I]incoming Calls" })
			vim.keymap.set("n", "<leader>flo", builtin.lsp_outgoing_calls, { desc = "[L]sp [O]utgoing Calls" })
			vim.keymap.set("n", "<leader>fls", builtin.lsp_document_symbols, { desc = "[L]sp [S]ymbols (Document)" })
			vim.keymap.set(
				"n",
				"<leader>flS",
				builtin.lsp_dynamic_workspace_symbols,
				{ desc = "[L]sp [S]ymbols (Workspace)" }
			)
			vim.keymap.set("n", "<leader>fle", builtin.diagnostics, { desc = "[L]sp [E]rror Diagnostics" })
			vim.keymap.set("n", "<leader>fld", builtin.lsp_definitions, { desc = "[L]sp [D]efinition" })
			vim.keymap.set("n", "<leader>f/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 30,
					previewer = true,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			-- Git Pickers
			-- Lists git commits with diff preview, checkout action <cr>, reset mixed <C-r>m, reset soft <C-r>s and reset hard <C-r>h
			vim.keymap.set("n", "<leader>fgc", builtin.git_commits, { desc = "[G]it [C]ommits" })
			-- Lists all branches with log preview, checkout action <cr>, track action <C-t>, rebase action<C-r>, create action <C-a>, switch action <C-s>, delete action <C-d> and merge action <C-y>
			vim.keymap.set("n", "<leader>fgb", builtin.git_branches, { desc = "[G]it [B]ranches" })
			vim.keymap.set("n", "<leader>fgs", builtin.git_status, { desc = "[G]it [S]tatus" })

			-- Treesitter Picker
			vim.keymap.set("n", "<leader>ft", builtin.treesitter, { desc = "[T]reesitter" })

			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
}
