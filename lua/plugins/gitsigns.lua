return {
	"lewis6991/gitsigns.nvim",
	config = function()
		local gitsigns = require("gitsigns")
		local last_hunk_nav
		local last_hunk_nav_buf
		local last_char_search

		local function set_last_hunk_nav(direction)
			last_hunk_nav = direction
			last_hunk_nav_buf = vim.api.nvim_get_current_buf()
			last_char_search = vim.deepcopy(vim.fn.getcharsearch())
		end

		local function nav_hunk(direction)
			set_last_hunk_nav(direction)
			gitsigns.nav_hunk(direction)
		end

		local function repeat_hunk_nav(reverse)
			if
				last_hunk_nav == nil
				or last_hunk_nav_buf ~= vim.api.nvim_get_current_buf()
				or not vim.deep_equal(vim.fn.getcharsearch(), last_char_search)
			then
				return reverse and "," or ";"
			end

			local direction = last_hunk_nav
			if reverse then
				direction = direction == "next" and "prev" or "next"
			end

			vim.schedule(function()
				nav_hunk(direction)
			end)

			return "<Ignore>"
		end

		gitsigns.setup({
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			numhl = true, -- Toggle with `:Gitsigns toggle_numhl`
			linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
			word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			watch_gitdir = {
				follow_files = true,
			},
			auto_attach = true,
			attach_to_untracked = true,
			current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
			current_line_blame_opts = {
				virt_text = true,
				virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
				delay = 1000,
				ignore_whitespace = false,
				virt_text_priority = 100,
			},
			current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
			sign_priority = 6,
			update_debounce = 100,
			status_formatter = nil, -- Use default
			max_file_length = 40000, -- Disable if file is longer than this (in lines)
			preview_config = {
				-- Options passed to nvim_open_win
				border = "single",
				style = "minimal",
				relative = "cursor",
				row = 0,
				col = 1,
			},
			-- yadm = {
			-- 	enable = false,
			-- },
		})

		vim.keymap.set("n", "]h", function()
			nav_hunk("next")
		end, { desc = "Next [H]unk" })
		vim.keymap.set("n", "[h", function()
			nav_hunk("prev")
		end, { desc = "Prev [H]unk" })
		vim.keymap.set("n", ";", function()
			return repeat_hunk_nav(false)
		end, { expr = true, desc = "Repeat hunk nav or native ;" })
		vim.keymap.set("n", ",", function()
			return repeat_hunk_nav(true)
		end, { expr = true, desc = "Reverse hunk nav or native ," })
	end,
}
