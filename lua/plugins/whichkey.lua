return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	init = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
	end,
	config = function()
		local wk = require("which-key")

		wk.add({
			{ mode = "n" },
			{
				{ "<leader>c", group = "[C]ode" },
				{ "<leader>f", group = "[F]ind" },
				{ "<leader>g", group = "[G]o" },
				{ "<leader>h", group = "[H]arpoon" },
			},
		})

		wk.add({
			{ "[", desc = "Go To Prev"},
		})

		wk.add({
			{ "]", desc = "Go To Next"},
		})

		-- local visualMappings = {
		--     ["<leader>"] = {
		--         g = {
		--             name = "[G]o",
		--             c = "Toggle region line [C]omment",
		--             b = "Toggle region [B]lock comment",
		--         },
		--     },
		-- }
		-- wk.register(visualMappings, { mode = "v" })
		-- wk.register(visualMappings, { mode = "x" })
		-- wk.register(visualMappings, { mode = "s" })
	end,
	opts = {},
}
