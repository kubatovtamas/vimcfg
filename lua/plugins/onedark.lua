return {
    "navarasu/onedark.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        require("onedark").setup({
            style = "light",
        })
        -- Not calling load() here so kanagawa stays the default.
        -- Switch to the light theme on demand with :colorscheme onedark

        vim.cmd.colorscheme("onedark")
    end,
}
