local M = {}

local opts = nil

local DEFAULT_OPTS = {
    show_jumps = false,
    min_jump = 30,
    popup = {
        delay_ms = 10,
        inc_ms = 5,
        blend = 10,
        width = 20,
        winhl = "PMenu",
    },
    ignore_filetypes = {},
    ignore_buftypes = {
        nofile = true,
    },
}

local function set_config_col(config, col)
    if type(config.col) == "table" then
        config.col[false] = col
        return
    end

    config.col = col
end

function M.show_specs(popup)
    local specs = require("specs")
    local start_win_id = vim.api.nvim_get_current_win()

    if not specs.should_show_specs(start_win_id) then
        return
    end

    popup = popup or {}

    local resolved_opts = vim.tbl_deep_extend("force", opts, { popup = popup })
    local cursor_col = vim.fn.wincol() - 1
    local cursor_row = vim.fn.winline() - 1
    local bufh = vim.api.nvim_create_buf(false, true)
    local win_id = vim.api.nvim_open_win(bufh, false, {
        relative = "win",
        width = 1,
        height = 1,
        col = cursor_col,
        row = cursor_row,
        style = "minimal",
    })

    vim.api.nvim_set_option_value("winhl", "Normal:" .. resolved_opts.popup.winhl, { win = win_id })
    vim.api.nvim_set_option_value("winblend", resolved_opts.popup.blend, { win = win_id })

    local count = 0
    local config = vim.api.nvim_win_get_config(win_id)
    local timer = vim.uv.new_timer()
    local closed = false

    timer:start(resolved_opts.popup.delay_ms, resolved_opts.popup.inc_ms, vim.schedule_wrap(function()
        if closed or vim.api.nvim_get_current_win() ~= start_win_id then
            if not closed then
                timer:stop()
                timer:close()
                pcall(vim.api.nvim_win_close, win_id, true)
                closed = true
            end

            return
        end

        if not vim.api.nvim_win_is_valid(win_id) then
            return
        end

        local blend = resolved_opts.popup.fader(resolved_opts.popup.blend, count)
        local dimensions = resolved_opts.popup.resizer(resolved_opts.popup.width, cursor_col, count)

        if blend ~= nil then
            vim.api.nvim_set_option_value("winblend", blend, { win = win_id })
        end

        if dimensions ~= nil then
            set_config_col(config, dimensions[2])
            vim.api.nvim_win_set_config(win_id, config)
            vim.api.nvim_win_set_width(win_id, dimensions[1])
        end

        if blend == nil and dimensions == nil then
            timer:stop()
            timer:close()
            vim.api.nvim_win_close(win_id, true)
            return
        end

        count = count + 1
    end))
end

function M.setup(user_opts)
    local specs = require("specs")

    opts = vim.tbl_deep_extend("force", DEFAULT_OPTS, user_opts or {})
    specs.setup(opts)
    specs.show_specs = M.show_specs
end

return M
