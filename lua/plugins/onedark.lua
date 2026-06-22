return {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("onedark").setup({
            style = "light",
        })
        -- Themery owns the active colorscheme on startup (see themery.lua),
        -- so no colorscheme is applied here.
    end,
}
