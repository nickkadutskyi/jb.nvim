-- Provides a set of common border styles

local M = {}

M.borders = {
    -- Best for full height tool window (float/split) pinned to the left or right (e.g. project view)
    tool_window = {
        left = {
            { " ", "ToolWindowFloatBorderTop" },
            { " ", "ToolWindowFloatBorderTop" }, -- Title border
            { "▕", "ToolWindowFloatBorder" },
            { "▕", "ToolWindowFloatBorder" },
            { "▕", "ToolWindowFloatBorder" },
            " ", -- Footer border
            { " ", "ToolWindowFloatBorderTop" },
            { " ", "ToolWindowFloatBorderTop" },
        },
        right = {
            { "▏", "ToolWindowFloatBorder" },
            { " ", "ToolWindowFloatBorderTop" }, -- Title border
            { " ", "ToolWindowFloatBorderTop" },
            { " ", "ToolWindowFloatBorderTop" },
            { " ", "ToolWindowFloatBorderTop" },
            " ", -- Footer border
            { "▏", "ToolWindowFloatBorder" },
            { "▏", "ToolWindowFloatBorder" },
        },
    },
    -- Best for modal (float) that shows up in the middle of the screen (e.g. search)
    dialog = {
        default = {
            { "▏", "DialogFloatBorderCorner" },
            { " ", "DialogFloatBorderTop" }, -- Title border
            { "▕", "DialogFloatBorderCorner" },
            { "▕", "DialogFloatBorder" },
            { "▕", "DialogFloatBorderCorner" },
            { " ", "DialogFloatBorderTop" }, -- Footer border
            { "▏", "DialogFloatBorderCorner" },
            { "▏", "DialogFloatBorder" },
        },
        split_top = {
            { "▏", "DialogFloatBorderCorner" },
            { " ", "DialogFloatBorderTop" }, -- Title border
            { "▕", "DialogFloatBorderCorner" },
            { "▕", "DialogFloatBorder" },
            { "▕", "DialogFloatBorder" },
            { "‾", "DialogFloatBorderBetween" }, -- Footer border
            { "▏", "DialogFloatBorder" },
            { "▏", "DialogFloatBorder" },
        },
        split_bottom = {
            { "▏", "DialogFloatBorder" },
            { " ", "DialogFloatBorder" }, -- Title border
            { "▕", "DialogFloatBorder" },
            { "▕", "DialogFloatBorderEditorArea" },
            { "▕", "DialogFloatBorderCorner" },
            { " ", "DialogFloatBorderTop" }, -- Footer border
            { "▏", "DialogFloatBorderCorner" },
            { "▏", "DialogFloatBorderEditorArea" },
        },
        default_box = {
            { "▕", "DialogFloatBorderOuter" }, -- Top Left corner
            { "▔", "DialogFloatBorder" }, -- Title border
            { "▏", "DialogFloatBorderOuter" }, -- Top Right corner
            { "▏", "DialogFloatBorderOuter" },
            { "▏", "DialogFloatBorderOuter" },
            { "▁", "DialogFloatBorder" }, -- Footer border
            { "▕", "DialogFloatBorderOuter" },
            { "▕", "DialogFloatBorderOuter" },
        },
        default_box_header = {
            { "▕", "DialogFloatBorderOuter" }, -- Top Left corner
            { " ", "DialogFloatBorderTop" }, -- Title border
            { "▏", "DialogFloatBorderOuter" }, -- Top Right corner

            { "▏", "DialogFloatBorderOuter" },

            { "▏", "DialogFloatBorderOuter" },
            { "▁", "DialogFloatBorder" }, -- Footer border
            { "▕", "DialogFloatBorderOuter" },

            { "▕", "DialogFloatBorderOuter" },
        },
    },
    -- Best for modal (float) that shows up in the context (e.g. completion)
    popup = {
        { "▏", "ToolWindowFloatBorder" },
        { " ", "ToolWindowFloatBorderTop" }, -- Title border
        { "▕", "ToolWindowFloatBorder" },
        { "▕", "ToolWindowFloatBorder" },
        { "▕", "ToolWindowFloatBorder" },
        " ", -- Footer border
        { "▏", "ToolWindowFloatBorder" },
        { "▏", "ToolWindowFloatBorder" },
    },
    notification = {
        { "▕", "DialogNotificationFloatBorderOuter" }, -- Top Left corner
        { "▔", "DialogNotificationFloatBorder" }, -- Title border
        { "▏", "DialogNotificationFloatBorderOuter" }, -- Top Right corner
        { "▏", "DialogNotificationFloatBorderOuter" },
        { "▏", "DialogNotificationFloatBorderOuter" },
        { "▁", "DialogNotificationFloatBorder" }, -- Footer border
        { "▕", "DialogNotificationFloatBorderOuter" },
        { "▕", "DialogNotificationFloatBorderOuter" },
    },
}

---@param conf EnforceFloatStyle[]
M.enforce_float_style = function(conf)
    if not conf then
        return
    end

    if conf.style ~= nil then
        conf = { conf }
    end

    local orig_open_win = vim.api.nvim_open_win

    --- @param buffer integer Buffer to display, or 0 for current buffer
    --- @param enter boolean Enter the window (make it the current window)
    --- @param config vim.api.keyset.win_config Map defining the window configuration. Keys:
    vim.api.nvim_open_win = function(bufnr, enter, config)
        local run_after = {}
        for _, rule in ipairs(conf) do
            local condition = rule.condition
            if not condition or condition(bufnr, enter, config) then
                if rule.style then
                    config = vim.tbl_deep_extend("force", config, rule.style)
                end
                if rule.after then
                    table.insert(run_after, rule.after)
                end
                break
            end
        end

        local win_id = orig_open_win(bufnr, enter, config)
        for _, after in ipairs(run_after) do
            after(win_id, bufnr, enter, config)
        end
        return win_id
    end
end

return M
