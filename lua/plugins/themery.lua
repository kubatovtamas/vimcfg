-- ┌─────────────────────────────────────────────────────────────────┐
-- │ Light / dark toggle config                                        │
-- │ Edit these two values to pick what <leader>tm switches between.   │
-- │ Each must match a `name` in the curated list below.               │
-- └─────────────────────────────────────────────────────────────────┘
local light_theme = "Cyberdream Light"
local dark_theme = "Cyberdream Dark"

-- Curated entries: friendly names and explicit variant handling for the
-- colorschemes whose light/dark mode is controlled by a sticky setup()
-- call rather than a distinct colorscheme file (cyberdream, onedark).
-- These take priority; the raw colorscheme list below fills in the rest.
local curated = {
	{
		name = "Cyberdream Light",
		colorscheme = "cyberdream-light",
		before = [[require("cyberdream").setup({ variant = "light" })]],
	},
	{
		name = "Cyberdream Dark",
		colorscheme = "cyberdream",
		before = [[require("cyberdream").setup({ variant = "default" })]],
	},
	-- onedark force-overrides its style to "light" whenever vim.o.background
	-- is "light" (see onedark M.colorscheme), so a previous light theme would
	-- leave the dark style stuck on light. Set background to match the style
	-- first, exactly as onedark's own toggle() does.
	{
		name = "OneDark Light",
		colorscheme = "onedark",
		before = [[vim.o.background = "light" require("onedark").setup({ style = "light" })]],
	},
	{
		name = "OneDark Dark",
		colorscheme = "onedark",
		before = [[vim.o.background = "dark" require("onedark").setup({ style = "dark" })]],
	},
	{ name = "Kanagawa Wave", colorscheme = "kanagawa-wave" },
	{ name = "Kanagawa Dragon", colorscheme = "kanagawa-dragon" },
	{ name = "Kanagawa Lotus", colorscheme = "kanagawa-lotus" },
	{ name = "Catppuccin Latte", colorscheme = "catppuccin-latte" },
	{ name = "Catppuccin Frappe", colorscheme = "catppuccin-frappe" },
	{ name = "Catppuccin Macchiato", colorscheme = "catppuccin-macchiato" },
	{ name = "Catppuccin Mocha", colorscheme = "catppuccin-mocha" },
}

return {
	"zaldih/themery.nvim",
	lazy = false,
	-- Loads after the colorscheme plugins (priority 1000) so every
	-- plugin colorscheme is registered before we enumerate them.
	config = function()
		local themery = require("themery")

		-- Start from the curated entries, tracking which raw colorschemes
		-- they already cover so we don't list those twice.
		local themes = {}
		local covered = {}
		for _, entry in ipairs(curated) do
			table.insert(themes, entry)
			covered[entry.colorscheme] = true
		end

		-- Append every other colorscheme available to :colorscheme
		-- (remaining plugin schemes + Vim builtins) so the picker offers
		-- the full set, not just the curated ones.
		for _, name in ipairs(vim.fn.getcompletion("", "color")) do
			if not covered[name] then
				table.insert(themes, { name = name, colorscheme = name })
				covered[name] = true
			end
		end

		themery.setup({
			themes = themes,
			livePreview = true,
		})

		-- First run only: Themery has no saved selection yet (and does not
		-- auto-apply one), so seed the default to the light theme. On later
		-- startups Themery restores the saved pick, so this branch is skipped.
		if not themery.getCurrentTheme() then
			themery.setThemeByName(light_theme, true)
		end

		-- Open the picker.
		vim.keymap.set("n", "<leader>tp", "<cmd>Themery<CR>", { desc = "[T]heme [p]icker" })

		-- Toggle between the configured light and dark themes.
		vim.keymap.set("n", "<leader>tm", function()
			local current = themery.getCurrentTheme()
			if current and current.name == light_theme then
				themery.setThemeByName(dark_theme, true)
			else
				themery.setThemeByName(light_theme, true)
			end
		end, { desc = "[T]heme [m]ode: toggle light/dark" })
	end,
}
