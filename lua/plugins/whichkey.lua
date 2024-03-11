return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 300
    end,
    config = function()
        local wk = require("which-key")

        wk.register({
            ["<leader>"] = {
                c = {
                    name = "[C]ode",
                    -- a = "[A]ction",
                },
                -- e = "[E]rror Popup",
                f = {
                    name = "[F]ind"
                },
                g = {
                    name = "[G]o",
                    -- c = {
                    --     name = "Comment (line)",
                    --     c = "Toggle line comment",
                    --     o = "Insert comment next line",
                    --     O = "Insert comment previous line",
                    --     A = "Insert comment end of line",
                    -- },
                    -- b = {
                    --     name = "Comment (block)",
                    --     c = "Toggle block comment",
                    --     ["<leader>"] = "Toggle region block comment",
                    -- },
                    -- d = "[D]efinition",
                    -- D = "[D]eclaration",
                    -- r = "[R]eferences on Quick Fix List",
                },
                h = {
                    "[H]arpoon"
                },
                -- k = "Signature Help",
                -- l = {
                --     name = "[L]ocation List",
                --     o = "open",
                --     c = "close",
                -- },
                -- q = {
                --     name = "[Q]uick Fix List",
                --     o = "open",
                --     c = "close",
                -- },
                -- w = {
                --     name = "LSP [W]orkspace",
                --     a = "[A]dd",
                --     r = "[R]emove",
                --     l = "[L]ist",
                -- },
            },
            { mode = "n" },
        })

        wk.register({
            ["["] = {
                name = "Go To Prev",
                -- d = "[D]iagnostic",
            },
        })

        wk.register({
            ["]"] = {
                name = "Go To Next",
                -- d = "[D]iagnostic",
            },
        })

        -- local visualMappings = {
        --     ["<leader>"] = {
        --         g = {
        --             name = "[G]o",
        --             c = "Toggle region line [C]omment",
        --             b = "Toggle region [B]lock comment",
        --         },
        --     },
        -- }
        -- wk.register(visualMappings, { mode = "v" })
        -- wk.register(visualMappings, { mode = "x" })
        -- wk.register(visualMappings, { mode = "s" })
    end,
    opts = {},
}
