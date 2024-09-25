return {
	"kylechui/nvim-surround",
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	event = "VeryLazy",
	config = function()
        local nvim_surround = require("nvim-surround")
        nvim_surround.setup({
			keymaps = {
				insert = "<leader><C-g>s",
				insert_line = "<leader><C-g>S",
				normal = "<leader>gs",
				normal_cur = "<leader>gS",
				normal_line = "<leader>gss",
				normal_cur_line = "<leader>gSS",
				visual = "<leader>gs",
				visual_line = "<leader>gS",
				delete = "<leader>gsd",
				change = "<leader>gsc",
			},
		})
	end,
}
