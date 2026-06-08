return {
	url = "https://codeberg.org/andyg/leap.nvim",
	config = function()
		local apply_backdrop = function()
			require("leap.user").set_backdrop_highlight("Comment")
		end

		vim.api.nvim_create_autocmd("ColorScheme", {
			group = vim.api.nvim_create_augroup("LeapBackdrop", {}),
			callback = apply_backdrop,
		})
		apply_backdrop()

        require('leap.user').set_repeat_keys('<enter>', '<backspace>')

		vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)")
		vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)")
		vim.keymap.set({ "x", "o" }, "R", function()
			require("leap.treesitter").select({
				opts = require("leap.user").with_traversal_keys("R", "r"),
			})
		end)

		require("leap").opts.equivalence_classes = { " \t\r\n", "([{", ")]}", "'\"`" }
	end,
}
