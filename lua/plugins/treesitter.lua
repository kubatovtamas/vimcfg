return {
    -- main branch requires the `tree-sitter` CLI on PATH to compile parsers
    -- (macOS: `brew install tree-sitter-cli`, separate from the `tree-sitter` lib formula)
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
        local ts = require("nvim-treesitter")
        local failed = {} ---@type table<string, true>

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "*",
            callback = function(args)
                local lang = vim.treesitter.language.get_lang(args.match) or args.match
                if failed[lang] or not vim.tbl_contains(ts.get_available(), lang) then
                    return
                end
                if not vim.tbl_contains(ts.get_installed("parsers"), lang) then
                    pcall(function()
                        ts.install({ lang }):wait(30000)
                    end)
                    if not vim.tbl_contains(ts.get_installed("parsers"), lang) then
                        failed[lang] = true
                        vim.notify("nvim-treesitter: failed to install parser for '" .. lang .. "'", vim.log.levels.WARN)
                        return
                    end
                end
                vim.treesitter.start(args.buf, lang)
                vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
            end,
        })
    end,
}
