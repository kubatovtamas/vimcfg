local M = {}

local timer = nil
local state = nil

local function stop_timer()
    if timer then
        timer:stop()
        timer:close()
        timer = nil
    end
    state = nil
end

local function clamp(value, min_value, max_value)
    return math.max(min_value, math.min(max_value, value))
end

local function centered_row(winid)
    return math.ceil(vim.api.nvim_win_get_height(winid) / 2)
end

local function can_center(winid, line)
    local height = vim.api.nvim_win_get_height(winid)
    local total_lines = vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(winid))
    local target_top = line - centered_row(winid) + 1
    local target_bottom = target_top + height - 1
    return target_top >= 1 and target_bottom <= total_lines
end

local function recenter_if_possible(winid)
    local line = vim.api.nvim_win_get_cursor(winid)[1]
    if can_center(winid, line) then
        vim.api.nvim_win_call(winid, function()
            vim.cmd.normal({ bang = true, args = { "zz" } })
        end)
    end
end

local function set_cursor_line(winid, line)
    local cursor = vim.api.nvim_win_get_cursor(winid)
    vim.api.nvim_win_set_cursor(winid, { line, cursor[2] })
end

local function step_scroll()
    if not state or not vim.api.nvim_win_is_valid(state.winid) then
        stop_timer()
        return
    end

    if state.remaining_steps <= 0 then
        stop_timer()
        return
    end

    local cursor = vim.api.nvim_win_get_cursor(state.winid)
    local total_lines = vim.api.nvim_buf_line_count(vim.api.nvim_win_get_buf(state.winid))
    local next_line = clamp(cursor[1] + state.direction, 1, total_lines)

    if next_line == cursor[1] then
        stop_timer()
        return
    end

    set_cursor_line(state.winid, next_line)
    recenter_if_possible(state.winid)
    state.remaining_steps = state.remaining_steps - 1

    if state.remaining_steps <= 0 then
        stop_timer()
    end
end

local function resolve_step_time(total_steps, opts)
    if opts.step_time then
        return opts.step_time
    end

    local duration = opts.duration or 160
    return math.max(5, math.floor(duration / math.max(total_steps, 1)))
end

function M.is_scrolling()
    return state ~= nil
end

function M.stop()
    stop_timer()
end

function M.scroll_half_page(direction, opts)
    opts = opts or {}

    local direction_step = direction == "down" and 1 or -1
    local winid = vim.api.nvim_get_current_win()
    local total_steps = opts.lines or vim.wo.scroll

    if total_steps <= 0 then
        return
    end

    stop_timer()

    state = {
        winid = winid,
        direction = direction_step,
        remaining_steps = total_steps,
    }

    step_scroll()

    if not state then
        return
    end

    local step_time = resolve_step_time(total_steps, opts)
    timer = vim.uv.new_timer()
    timer:start(step_time, step_time, vim.schedule_wrap(step_scroll))
end

return M
