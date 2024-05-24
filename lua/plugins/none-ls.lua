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

				null_ls.builtins.formatting.ruff_lsp,

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
	end,
}
