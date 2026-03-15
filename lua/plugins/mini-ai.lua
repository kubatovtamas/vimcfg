return {
    "nvim-mini/mini.ai",
    version = false,
    config = function()
        -- Usage cheatsheet:
        -- - Start with `a` (around) or `i` (inside).
        -- - Qualify with `n` / `l`: `an`/`in` for next, `al`/`il` for last.
        -- - Edge motions: `g[` and `g]`.
        -- - Builtin textobjects:
        --   - `b` brackets alias
        --   - `q` quotes alias
        --   - `t` tag
        --   - `f` function call
        --   - `a` argument
        --   - Also direct bracket/quote keys like `(` `[` `{` `<` `"` `'` `` ` ``
        -- - "Default separator textobject" means punctuation/separator runs can act as
        --   textobjects too, so `mini.ai` can target non-letter boundaries even when
        --   there is no named builtin alias involved.
        require("mini.ai").setup({
            -- Table with textobject id as fields, textobject specification as values.
            -- Also use this to disable builtin textobjects. See |MiniAi.config|.
            custom_textobjects = nil,

            -- Module mappings. Use '' (empty string) to disable one.
            mappings = {
                -- Main textobject prefixes
                around = "a",
                inside = "i",

                -- Next/last variants
                around_next = "an",
                inside_next = "in",
                around_last = "al",
                inside_last = "il",

                -- Move cursor to corresponding edge of `a` textobject
                goto_left = "g[",
                goto_right = "g]",
            },

            -- Number of lines within which textobject is searched
            n_lines = 50,

            -- How to search for object
            search_method = "cover_or_next",

            -- Whether to disable showing non-error feedback
            silent = false,
        })
    end,
}
