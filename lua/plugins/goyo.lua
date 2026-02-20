return {
	"junegunn/goyo.vim",
	config = function()
		-- Goyo configuration
		vim.g.goyo_width = "85%"
		vim.g.goyo_height = "100%"
		vim.g.goyo_linenr = 1
		
		-- Goyo enter callback
		local function goyo_enter()
			-- Hide UI elements
			vim.opt.showmode = false
			vim.opt.showcmd = false
			vim.opt.showtabline = 0
			-- Hide lualine
			require('lualine').hide()
			
			-- Enable wrap
			vim.wo.wrap = true
			vim.wo.linebreak = true
			
			-- Quit behavior setup
			vim.b.quitting = 0
			vim.b.quitting_bang = 0
			vim.api.nvim_create_autocmd("QuitPre", {
				buffer = 0,
				callback = function()
					vim.b.quitting = 1
				end,
			})
			vim.cmd([[cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!]])
		end
		
		-- Goyo leave callback
		local function goyo_leave()
			-- Restore UI elements
			vim.opt.showmode = true
			vim.opt.showcmd = true
			vim.opt.showtabline = 0
			-- Show lualine
			require('lualine').hide({unhide = true})
			
			-- Disable wrap (back to default)
			vim.wo.wrap = false
			vim.wo.linebreak = false
			
			-- Quit vim if this is the only remaining buffer
			if vim.b.quitting == 1 then
				local buflisted_count = 0
				for i = 1, vim.fn.bufnr('$') do
					if vim.fn.buflisted(i) == 1 then
						buflisted_count = buflisted_count + 1
					end
				end
				
				if buflisted_count == 1 then
					if vim.b.quitting_bang == 1 then
						vim.cmd('qa!')
					else
						vim.cmd('qa')
					end
				end
			end
		end
		
		-- Set up autocmds with nested flag
		vim.api.nvim_create_autocmd("User", {
			pattern = "GoyoEnter",
			callback = goyo_enter,
			nested = true,
		})
		
		vim.api.nvim_create_autocmd("User", {
			pattern = "GoyoLeave",
			callback = goyo_leave,
			nested = true,
		})
		
		-- Keymap to toggle Goyo (wrap is handled in callbacks)
		vim.keymap.set("n", "<leader>tw", ":Goyo<CR>", { noremap = true, desc = "[T]oggle [W]rite mode (Goyo)" })
	end,
}
