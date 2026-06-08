return {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("kanagawa").setup({
            theme = "wave",
            overrides = function(colors)
                return {
                    PreProc = { fg = colors.theme.syn.preproc, underline = false, undercurl = false },
                    ["@keyword.import"] = { fg = colors.theme.syn.preproc, underline = false, undercurl = false },
                }
            end,
        })

        -- vim.cmd.colorscheme("kanagawa")
    end,
}
