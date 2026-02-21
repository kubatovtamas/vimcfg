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

				null_ls.builtins.formatting.shfmt,
				require("none-ls-shellcheck.diagnostics"),
				require("none-ls-shellcheck.code_actions"),
			},
		})
		vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "[G]o [F]ormat" })

        -- Set up an autocommand to set the keymap only for json file types
        vim.api.nvim_create_autocmd("FileType", {
            pattern = "json",
            callback = function()
                vim.api.nvim_buf_set_keymap(0, 'n', '<leader>gf', [[:lua vim.cmd('%!jq .')<CR>]], { noremap = true, silent = true })
            end
        })
	end,
}
