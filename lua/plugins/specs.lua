return {
    "edluffy/specs.nvim",
    config = function()
        local specs = require("specs")

        require("specs-compat").setup({
            -- Keep specs explicit for now. We'll trigger it from search mappings.
            show_jumps = false,
            min_jump = 30,
            popup = {
                delay_ms = 10,
                inc_ms = 5,
                blend = 10,
                width = 20,
                winhl = "Todo",
                fader = specs.linear_fader,  -- exp_fader
                resizer = specs.shrink_resizer,  -- shrink_resizer
            },
            ignore_filetypes = {},
            ignore_buftypes = {
                nofile = true,
            },
        })
    end,
}
