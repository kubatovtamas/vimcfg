return {
    {
        "hrsh7th/cmp-nvim-lsp",
    },
    {
        "L3MON4D3/LuaSnip",
        dependencies = {
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
        },
    },
    { "hrsh7th/cmp-buffer" },
    { "FelipeLema/cmp-async-path" },
    { "hrsh7th/cmp-cmdline" },
    { "onsails/lspkind-nvim" },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {},
        config = function(_, opts)
            require("lsp_signature").setup(opts)
        end,
    },
    {
        "linux-cultist/venv-selector.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
            "nvim-telescope/telescope.nvim",
            "mfussenegger/nvim-dap",
            "mfussenegger/nvim-dap-python",
        },
        config = function()
            require("venv-selector").setup({
                pipenv_path = "/Users/kuba/.local/share/virtualenvs",
                pyenv_path = "/Users/kuba/.pyenv",
                -- Your options go here
                -- name = "venv",
                -- auto_refresh = false
            })

            -- vim.api.nvim_create_autocmd("VimEnter", {
            --     desc = "Auto select virtualenv when Nvim opens in a Python project",
            --     pattern = "*",
            --     callback = function()
            --         local cwd = vim.fn.getcwd()
            --         local pyproject_toml = vim.fn.findfile("pyproject.toml", cwd .. ";")
            --         local pipfile = vim.fn.findfile("Pipfile", cwd .. ";")
            --
            --         -- Check if either pyproject.toml or Pipfile exists
            --         if pyproject_toml ~= "" or pipfile ~= "" then
            --             require("venv-selector").retrieve_from_cache()
            --         end
            --     end,
            --     once = true,
            -- })
        end,
        keys = {
            { "<leader>pvs", "<cmd>VenvSelect<cr>"},
            { "<leader>pvc", "<cmd>VenvSelectCached<cr>" },
            { "<leader>pvl", "<cmd>VenvSelectCurrent<cr>" },
        },
    },
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local lspkind = require("lspkind")
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if luasnip.expandable() then
                            luasnip.expand()
                        elseif cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                    { name = "async_path" },
                    -- { name = "rg" },
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = "symbol_text", -- show only symbol annotations
                        maxwidth = 75, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                        -- can also be a function to dynamically calculate max width such as
                        -- maxwidth = function() return math.floor(0.45 * vim.o.columns) end,
                        ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                    }),
                },
            })
            -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
            })
        end,
    },
}
