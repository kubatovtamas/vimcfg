return {
    "smjonas/inc-rename.nvim",
    config = function()
        vim.keymap.set("n", "<leader>rn", function()
            return ":IncRename " .. vim.fn.expand("<cword>")
        end, { expr = true, desc = "Rename Symbol"})
        require("inc_rename").setup()
    end,
}
