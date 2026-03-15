return {
	"kylechui/nvim-surround",
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	event = "VeryLazy",
	init = function()
		vim.g.nvim_surround_no_mappings = true
	end,
	config = function()
		require("nvim-surround").setup({})

		vim.keymap.set("n", "<leader>gs", "<Plug>(nvim-surround-normal)", {
			desc = "Add surround around motion",
		})
		vim.keymap.set("n", "<leader>gS", "<Plug>(nvim-surround-normal-cur)", {
			desc = "Add surround around current line",
		})
		vim.keymap.set("n", "<leader>gss", "<Plug>(nvim-surround-normal-line)", {
			desc = "Add surround around motion on new lines",
		})
		vim.keymap.set("n", "<leader>gSS", "<Plug>(nvim-surround-normal-cur-line)", {
			desc = "Add surround around current line on new lines",
		})
		vim.keymap.set("x", "<leader>gs", "<Plug>(nvim-surround-visual)", {
			desc = "Add surround around selection",
		})
		vim.keymap.set("x", "<leader>gS", "<Plug>(nvim-surround-visual-line)", {
			desc = "Add surround around selection on new lines",
		})
		vim.keymap.set("n", "<leader>gsd", "<Plug>(nvim-surround-delete)", {
			desc = "Delete surround",
		})
		vim.keymap.set("n", "<leader>gsc", "<Plug>(nvim-surround-change)", {
			desc = "Change surround",
		})
	end,
}
