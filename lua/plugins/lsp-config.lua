local function merge_tables(first_table, second_table)
    local res = {}
    for k, v in pairs(first_table) do
        res[k] = v
    end
    for k, v in pairs(second_table) do
        res[k] = v
    end
    return res
end

return {
    {
        "williamboman/mason.nvim",
        lazy = false,
        opts = {
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗",
                },
            },
        },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        opts = {
            auto_install = true,
        },
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "ruff_lsp",
                    "jedi_language_server",
                    "pyright",
                    "marksman",
                    "bashls",
                },
                automatic_installation = true,
                modifiable = true,
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
            require("java").setup()

            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")
            local opts = { noremap = true, silent = true }

            vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "[E]rrors Popup" })
            vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, merge_tables(opts, { desc = "Prev [D]iagnostic" }))
            vim.keymap.set("n", "]d", vim.diagnostic.goto_next, merge_tables(opts, { desc = "Next [D]iagnostic" }))

            vim.keymap.set(
                "n",
                "<leader>ge",
                vim.diagnostic.setloclist,
                merge_tables(opts, { desc = "[E]rrors (loclist)" })
            )
            vim.keymap.set("n", "<leader>lo", ":lopen<cr>", merge_tables(opts, { desc = "[L]oclist [O]pen" }))
            vim.keymap.set("n", "<leader>lc", ":lclose<cr>", merge_tables(opts, { desc = "[L]oclist [C]lose" }))

            vim.keymap.set(
                "n",
                "<leader>gr",
                vim.lsp.buf.references,
                merge_tables(opts, { desc = "[R]eferences (quickfixlist)" })
            )
            vim.keymap.set("n", "<leader>qo", ":copen<CR>", merge_tables(opts, { desc = "[Q]uickfix [O]pen" }))
            vim.keymap.set("n", "<leader>qc", ":cclose<CR>", merge_tables(opts, { desc = "[Q]uickfix [C]lose" }))

            local on_attach_func = function(client, bufnr, enable_formatting)
                if enable_formatting == nil then
                    enable_formatting = true
                end

                local bufopts = { noremap = true, silent = true, buffer = bufnr }

                vim.api.nvim_set_keymap("i", "<c-tab>", "<c-x><c-o>", { noremap = true, silent = true })
                vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

                vim.keymap.set(
                    "n",
                    "<leader>ga",
                    vim.lsp.buf.code_action,
                    merge_tables(bufopts, { desc = "[G]o Code [A]ction" })
                )

                vim.keymap.set(
                    "n",
                    "gD",
                    vim.lsp.buf.definition,
                    merge_tables(bufopts, { desc = "[D]efinition (Global)" })
                )
                -- vim.keymap.set("n", "gd", vim.lsp.buf.declaration, bufopts)
                -- vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)

                vim.keymap.set("n", "<leader>k", vim.lsp.buf.hover, merge_tables(bufopts, { desc = "Hover" }))
                vim.keymap.set(
                    "n",
                    "<leader>K",
                    vim.lsp.buf.signature_help,
                    merge_tables(bufopts, { desc = "Signature Help" })
                )

                if enable_formatting then
                    if client.server_capabilities.documentFormattingProvider then
                        vim.keymap.set("n", "<leader>gf", function()
                            vim.lsp.buf.format({ async = true })
                        end, { buffer = bufnr, desc = "[F]ormat" })
                    end
                end
            end

            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                on_attach = on_attach_func,
            })

            lspconfig.marksman.setup({
                capabilities = capabilities,
                on_attach = on_attach_func,
            })

            lspconfig.bashls.setup({
                capabilities = capabilities,
                on_attach = on_attach_func,
            })

            lspconfig.pyright.setup({
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    on_attach_func(client, bufnr, false)
                end,
            })

            lspconfig.ruff_lsp.setup({
                capabilities = capabilities,
                on_attach = on_attach_func,
            })

            lspconfig.jdtls.setup({
                capabilities = capabilities,
                on_attach = on_attach_func,
            })

            lspconfig.bashls.setup({
                capabilities = capabilities,
                on_attach = on_attach_func,
            })
        end,
    },
}
