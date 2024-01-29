return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defaults = {},
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
			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]iles"})
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "[G]rep"})
			vim.keymap.set("n", "<leader>fr", builtin.git_files, { desc = "Git Files"})
			vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[B]uffers"})
			vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[H]elp"})
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
