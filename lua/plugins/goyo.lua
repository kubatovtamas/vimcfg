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
			local buflisted_count = #vim.fn.getbufinfo({ buflisted = 1 })
			if vim.b.quitting == 1 and buflisted_count == 1 then
				if vim.b.quitting_bang == 1 then
					vim.cmd('qa!')
				else
					vim.cmd('qa')
				end
			end
		end
		
		-- Set up autocmds with nested flag
		local goyo_group = vim.api.nvim_create_augroup("nvim.goyo.events", { clear = true })
		vim.api.nvim_create_autocmd("User", {
			pattern = "GoyoEnter",
			group = goyo_group,
			callback = goyo_enter,
			nested = true,
		})
		
		vim.api.nvim_create_autocmd("User", {
			pattern = "GoyoLeave",
			group = goyo_group,
			callback = goyo_leave,
			nested = true,
		})
		
		-- Keymap to toggle Goyo (wrap is handled in callbacks)
		vim.keymap.set("n", "<leader>tw", function()
			local current_buf = vim.api.nvim_get_current_buf()
			vim.cmd("Goyo")
			vim.schedule(function()
				if vim.api.nvim_buf_is_valid(current_buf) and vim.api.nvim_get_current_buf() ~= current_buf then
					vim.api.nvim_set_current_buf(current_buf)
				end
			end)
		end, { noremap = true, desc = "[T]oggle [W]rite mode (Goyo)" })
	end,
}
