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

-- Function to deduplicate LSP locations
local function deduplicate_locations(locations)
    local seen = {}
    local result = {}
    
    for _, location in ipairs(locations) do
        -- Create a unique key based on file and position
        local key = string.format("%s:%d:%d", 
            location.uri or location.targetUri, 
            location.range and location.range.start.line or location.targetSelectionRange.start.line,
            location.range and location.range.start.character or location.targetSelectionRange.start.character
        )
        
        if not seen[key] then
            seen[key] = true
            table.insert(result, location)
        end
    end
    
    return result
end

-- Custom definition handler that deduplicates results
local function goto_definition_dedupe()
    local params = vim.lsp.util.make_position_params()
    vim.lsp.buf_request(0, 'textDocument/definition', params, function(err, result, ctx, config)
        if err then
            vim.notify('Error getting definition: ' .. err.message, vim.log.levels.ERROR)
            return
        end
        
        if not result or vim.tbl_isempty(result) then
            vim.notify('No definition found', vim.log.levels.INFO)
            return
        end
        
        -- Deduplicate the results
        local deduplicated = deduplicate_locations(result)
        
        -- Use vim.lsp.util.jump_to_location for the deduplicated results
        if #deduplicated == 1 then
            vim.lsp.util.jump_to_location(deduplicated[1], 'utf-8')
        else
            vim.lsp.util.set_qflist(vim.lsp.util.locations_to_items(deduplicated, 'utf-8'))
            vim.cmd('copen')
        end
    end)
end

-- Custom references handler that deduplicates results
local function goto_references_dedupe()
    local params = vim.lsp.util.make_position_params()
    params.context = { includeDeclaration = true }
    vim.lsp.buf_request(0, 'textDocument/references', params, function(err, result, ctx, config)
        if err then
            vim.notify('Error getting references: ' .. err.message, vim.log.levels.ERROR)
            return
        end
        
        if not result or vim.tbl_isempty(result) then
            vim.notify('No references found', vim.log.levels.INFO)
            return
        end
        
        -- Deduplicate the results
        local deduplicated = deduplicate_locations(result)
        
        -- Set quickfix list with deduplicated references
        local items = vim.lsp.util.locations_to_items(deduplicated, 'utf-8')
        vim.fn.setqflist({}, ' ', { title = 'LSP references', items = items })
        vim.cmd('copen')
    end)
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
                    "jedi_language_server",
                    "pyright",
                    "marksman",
                    "bashls",
                    "ruff",
                    "terraformls",
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
                goto_references_dedupe,
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
                    goto_definition_dedupe,
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
            lspconfig.ruff.setup({
                capabilities = capabilities,
                on_attach = on_attach_func,
            })
            lspconfig.terraformls.setup({
                capabilities = capabilities,
                on_attach = on_attach_func,
            })
        end,
    },
}
