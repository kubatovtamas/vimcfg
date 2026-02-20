return {
	"junegunn/goyo.vim",
	config = function()
		-- Goyo configuration
		vim.g.goyo_width = "85%"
		vim.g.goyo_height = "100%"
		vim.g.goyo_linenr = 1
		
		-- Combined toggle for goyo and wrap
		local function toggle_goyo_and_wrap()
			vim.cmd("Goyo")
			if vim.wo.wrap then
				vim.wo.wrap = false
				vim.wo.linebreak = false
			else
				vim.wo.wrap = true
				vim.wo.linebreak = true
			end
		end
		
		vim.keymap.set("n", "<leader>tw", toggle_goyo_and_wrap, { noremap = true, desc = "[T]oggle [W]rite mode (Goyo + Wrap)" })
	end,
}
