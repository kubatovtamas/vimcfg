return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		"gbprod/none-ls-shellcheck.nvim",
	},
	config = function()
		require("mason").setup()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,

				null_ls.builtins.formatting.prettier,

				null_ls.builtins.formatting.ruff,

				null_ls.builtins.formatting.shfmt,
				require("none-ls-shellcheck.diagnostics"),
				require("none-ls-shellcheck.code_actions"),

				-- null_ls.builtins.formatting.isort,
				-- null_ls.builtins.formatting.black.with({
				--     extra_args = { "--line-length=120", "--skip-string-normalization" },
				-- }),
			},
		})
		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "[G]o [F]ormat" })

        -- local function format_json_with_jq()
        --     vim.cmd([[%!jq .]])
        -- end

-- vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
--     pattern = "[/?]",
--     callback = function()
--         vim.o.hlsearch = true -- Enable highlighting when entering search mode
--     end,
-- })
        -- Set up an autocommand to set the keymap only for json file types
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "json",
            callback = function()
                vim.api.nvim_buf_set_keymap(0, 'n', '<leader>gf', [[:lua vim.cmd('%!jq .')<CR>]], { noremap = true, silent = true })
            end
        })
	end,
}
