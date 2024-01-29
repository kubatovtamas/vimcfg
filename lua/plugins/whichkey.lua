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
                    a = "[C]ode [A]ction",
                },
                D = "Type [D]efinition",
                e = "Open Diagnostics Menu",
                f = {
                    name = "[F]ind"
                },
                g = {
                    name = "Go",
                    c = {
                        name = "Comment (line)",
                        c = "Toggle line comment",
                        o = "Insert comment next line",
                        O = "Insert comment previous line",
                        A = "Insert comment end of line",
                    },
                    b = {
                        name = "Comment (block)",
                        c = "Toggle block comment",
                        ["<leader>"] = "Toggle region block comment",
                    },
                    d = "[D]efinition",
                    D = "[D]eclaration",
                    r = "[R]eferences on Quick Fix List",
                },
                k = "Signature Help",
                l = {
                    name = "[L]ocation List",
                    o = "open",
                    c = "close",
                },
                q = {
                    name = "[Q]uick Fix List",
                    o = "open",
                    c = "close",
                },
                w = {
                    name = "LSP [W]orkspace",
                    a = "[A]dd",
                    r = "[R]emove",
                    l = "[L]ist",
                },
            },
            { mode = "n" },
        })

        wk.register({
            ["["] = {
                name = "Go To Prev",
                d = "[D]iagnostic",
            },
        })

        wk.register({
            ["]"] = {
                name = "Go To Next",
                d = "[D]iagnostic",
            },
        })

        local visualMappings = {
            ["<leader>"] = {
                g = {
                    name = "Go",
                    c = "Toggle region line comment",
                    b = "Toggle region block comment",
                },
            },
        }
        wk.register(visualMappings, { mode = "v" })
        wk.register(visualMappings, { mode = "x" })
        wk.register(visualMappings, { mode = "s" })
    end,
    opts = {},
}
