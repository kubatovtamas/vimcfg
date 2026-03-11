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

local function infer_position_encoding(window)
    local bufnr = vim.api.nvim_get_current_buf()
    if type(window) == "number" and vim.api.nvim_win_is_valid(window) then
        bufnr = vim.api.nvim_win_get_buf(window)
    end

    local encoding = nil
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
        local capability_encodings = vim.tbl_get(client, "config", "capabilities", "general", "positionEncodings")
        local client_encoding = client.offset_encoding
            or client.encoding
            or client.config.offset_encoding
            or (capability_encodings and capability_encodings[1])
        if client_encoding ~= nil then
            if encoding == nil then
                encoding = client_encoding
            elseif encoding ~= client_encoding then
                return nil
            end
        end
    end

    return encoding
end

local function patch_make_position_params()
    if vim.lsp.util._copilot_position_encoding_patch_applied then
        return
    end

    local original_make_position_params = vim.lsp.util.make_position_params
    vim.lsp.util.make_position_params = function(window, position_encoding)
        position_encoding = position_encoding or infer_position_encoding(window)
        return original_make_position_params(window, position_encoding)
    end
    vim.lsp.util._copilot_position_encoding_patch_applied = true
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
                    "basedpyright",
                    "marksman",
                    "bashls",
                    "terraformls",
                    "ruff",
                },
                automatic_enable = {
                    -- These are configured below. Exclude them here to avoid duplicate default clients.
                    exclude = { "lua_ls", "basedpyright", "marksman", "bashls", "terraformls", "ruff" },
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
            patch_make_position_params()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            capabilities.general = vim.tbl_deep_extend("force", capabilities.general or {}, {
                positionEncodings = { "utf-16" },
            })
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
            lspconfig.basedpyright.setup({
                capabilities = capabilities,
                settings = {
                    basedpyright = {
                        disableLanguageServices = false, -- Keep full LSP features on (hover/defs/refs/completion/actions).
                        disableOrganizeImports = true, -- Disable basedpyright organize-imports action; use Ruff for import sorting.
                        disableTaggedHints = false, -- Keep tagged hint diagnostics (deprecated/unused/unreachable tags).
                        analysis = {
                            diagnosticMode = "workspace", -- Analyze entire workspace, not only open files.
                            autoSearchPaths = true, -- Auto-detect common import roots (e.g. src/).
                            autoImportCompletions = true, -- Offer auto-import completion items.
                            useLibraryCodeForTypes = true, -- Infer types from library source when stubs are missing.
                            typeCheckingMode = "recommended", -- Enable stricter recommended ruleset.
                            inlayHints = {
                                variableTypes = true, -- Show inferred variable type hints.
                                callArgumentNames = true, -- Show argument-name hints at call sites.
                                callArgumentNamesMatching = true, -- Show hints even when arg name matches parameter name.
                                functionReturnTypes = true, -- Show inferred return-type hints for functions.
                                genericTypes = true, -- Show inferred generic type parameter hints.
                            },
                        },
                    },
                },
                on_attach = function(client, bufnr)
                    on_attach_func(client, bufnr, false)
                end,
            })
            lspconfig.terraformls.setup({
                capabilities = capabilities,
                on_attach = on_attach_func,
            })
            lspconfig.ruff.setup({
                capabilities = capabilities,
                on_attach = on_attach_func,
            })
        end,
    },
}
