return {
	"theprimeagen/harpoon",
	config = function()
		local mark = require("harpoon.mark")
		local ui = require("harpoon.ui")

		vim.keymap.set("n", "<leader>ha", mark.add_file, { desc = "[H]arpoon [A]dd File"})
		vim.keymap.set("n", "<leader>hm", ui.toggle_quick_menu, { desc = "[H]arpoon [M]enu"})

		vim.keymap.set("n", "<C-h>", function()
			ui.nav_file(1)
		end, { desc = "Harpoon Nav File 1"})
		vim.keymap.set("n", "<C-j>", function()
			ui.nav_file(2)
		end, { desc = "Harpoon Nav File 2"})
		vim.keymap.set("n", "<C-k>", function()
			ui.nav_file(3)
		end, { desc = "Harpoon Nav File 3"})
		vim.keymap.set("n", "<C-l>", function()
			ui.nav_file(4)
		end, { desc = "Harpoon Nav File 4"})
	end,
}
