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
        default_box_shadowed = {
            { "▕", "DialogFloatBorderOuter" }, -- Top Left corner
            { "▔", "DialogFloatBorder" }, -- Title border
            { "▏", "DialogFloatBorderOuterShadowedLight" }, -- Top Right corner

            { "▏", "DialogFloatBorderOuterShadowedDark" },

            { " ", "DialogFloatBorderOuterShadowedDark" }, -- Bottom Right corner
            { "▔", "DialogFloatBorderOuterShadowedDark" }, -- Footer border
            { " ", "DialogFloatBorderOuterShadowedLight" }, -- Bottom Left corner

            { "▕", "DialogFloatBorderOuterShadowedLight" },
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
        default_box_header_shadowed = {
            { "▕", "DialogFloatBorderOuter" }, -- Top Left corner
            { " ", "DialogFloatBorderTop" }, -- Title border
            { "▏", "DialogFloatBorderOuterShadowedLight" }, -- Top Right corner

            { "▏", "DialogFloatBorderOuterShadowedDark" },

            { " ", "DialogFloatBorderOuterShadowedDark" }, -- Bottom Right corner
            { "▔", "DialogFloatBorderOuterShadowedDark" }, -- Footer border
            { " ", "DialogFloatBorderOuterShadowedLight" }, -- Bottom Left corner

            { "▕", "DialogFloatBorderOuterShadowedLight" },
        },
        default_box_split_top = {
            { "▕", "DialogFloatBorderOuter" }, -- Top Left corner
            { " ", "DialogFloatBorderTop" }, -- Title border
            { "▏", "DialogFloatBorderOuter" }, -- Top Right corner

            { "▏", "DialogFloatBorderOuter" },

            { " ", "DialogFloatBorderOuterShadowedDark" }, -- Bottom Right corner
            { "▔", "DialogFloatBorderOuterShadowedDark" }, -- Footer border
            { " ", "DialogFloatBorderOuterShadowedLight" }, -- Bottom Left corner

            { "▕", "DialogFloatBorderOuter" },
        },
        default_box_split_top_shadowed = {
            { "▕", "DialogFloatBorderOuter" }, -- Top Left corner
            { " ", "DialogFloatBorderTop" }, -- Title border
            { "▏", "DialogFloatBorderOuterShadowedLight" }, -- Top Right corner

            { "▏", "DialogFloatBorderOuterShadowedDark" }, -- Top Right corner

            { "▏", "DialogFloatBorderOuterShadowedDark" },
            { "▁", "DialogFloatBorderBetween" }, -- Footer border
            { "▕", "DialogFloatBorderOuterShadowedLight" },

            { "▕", "DialogFloatBorderOuterShadowedLight" },
        },
        default_box_split_top_no_footer = {
            { "▕", "DialogFloatBorderOuter" }, -- Top Left corner
            { " ", "DialogFloatBorderTop" }, -- Title border
            { "▏", "DialogFloatBorderOuter" }, -- Top Right corner

            { "▏", "DialogFloatBorderOuter" },

            { "", "DialogFloatBorderOuter" },
            { "", "DialogFloatBorderBetween" }, -- Footer border
            { "", "DialogFloatBorderOuter" },

            { "▕", "DialogFloatBorderOuter" },
        },
        default_box_split_top_no_footer_shadowed = {
            { "▕", "DialogFloatBorderOuter" }, -- Top Left corner
            { " ", "DialogFloatBorderTop" }, -- Title border
            { "▏", "DialogFloatBorderOuterShadowedLight" }, -- Top Right corner

            { "▏", "DialogFloatBorderOuterShadowedDark" }, -- Top Right corner

            { "", "DialogFloatBorderOuter" },
            { "", "DialogFloatBorderBetween" }, -- Footer border
            { "", "DialogFloatBorderOuter" },

            { "▕", "DialogFloatBorderOuterShadowedLight" },
        },
        default_box_split_middle = {
            { "▕", "DialogFloatBorderOuter" }, -- Top Left corner
            { "▔", "DialogFloatBorderBetween" }, -- Title border
            { "▏", "DialogFloatBorderOuter" }, -- Top Right corner
            { "▏", "DialogFloatBorderOuter" },
            { "▏", "DialogFloatBorderOuter" },
            { "▁", "DialogFloatBorderBetween" }, -- Footer border
            { "▕", "DialogFloatBorderOuter" },
            { "▕", "DialogFloatBorderOuter" },
        },
        default_box_split_middle_shadowed = {
            { "▕", "DialogFloatBorderOuterShadowedLight" }, -- Top Left corner
            { "▔", "DialogFloatBorderBetween" }, -- Title border
            { "▏", "DialogFloatBorderOuterShadowedDark" }, -- Top Right corner

            { "▏", "DialogFloatBorderOuterShadowedDark" },

            { "▏", "DialogFloatBorderOuterShadowedDark" },
            { "▁", "DialogFloatBorderBetween" }, -- Footer border
            { "▕", "DialogFloatBorderOuterShadowedLight" },

            { "▕", "DialogFloatBorderOuterShadowedLight" },
        },
        default_box_split_middle_shadowed_no_footer = {
            { "▕", "DialogFloatBorderOuterShadowedLight" }, -- Top Left corner
            { "▔", "DialogFloatBorderBetween" }, -- Title border
            { "▏", "DialogFloatBorderOuterShadowedDark" }, -- Top Right corner

            { "▏", "DialogFloatBorderOuterShadowedDark" },

            { "", "DialogFloatBorderOuterShadowedDark" },
            { "", "DialogFloatBorderBetween" }, -- Footer border
            { "", "DialogFloatBorderOuterShadowedLight" },

            { "▕", "DialogFloatBorderOuterShadowedLight" },
        },
        default_box_split_bottom = {
            { "▕", "DialogFloatBorderOuter" },
            { " ", "DialogFloatBorder" }, -- Title border
            { "▏", "DialogFloatBorderOuter" },

            { "▏", "DialogFloatBorderOuter" },

            { "▏", "DialogFloatBorderOuter" },
            { "▁", "DialogFloatBorderCorner" }, -- Footer border
            { "▕", "DialogFloatBorderOuter" },

            { "▕", "DialogFloatBorderOuter" },
        },
        default_box_split_bottom_shadowed_header = {
            { "▕", "DialogFloatBorderOuterShadowedLight" }, -- Top Left corner
            { " ", "DialogFloatBorderTop" }, -- Title border
            { "▏", "DialogFloatBorderOuterShadowedDark" }, -- Top Right corner

            { "▏", "DialogFloatBorderOuterShadowedDark" },

            { " ", "DialogFloatBorderOuterShadowedDark" }, -- Bottom Right corner
            { "▔", "DialogFloatBorderOuterShadowedDark" }, -- Footer border
            { " ", "DialogFloatBorderOuterShadowedLight" }, -- Bottom Left corner

            { "▕", "DialogFloatBorderOuterShadowedLight" },
        },
        default_box_split_bottom_shadowed = {
            { "▕", "DialogFloatBorderOuterShadowedLight" }, -- Top Left corner
            { " ", "DialogFloatBorder" }, -- Title border
            { "▏", "DialogFloatBorderOuterShadowedDark" }, -- Top Right corner

            { "▏", "DialogFloatBorderOuterShadowedDark" },

            { " ", "DialogFloatBorderOuterShadowedDark" }, -- Bottom Right corner
            { "▔", "DialogFloatBorderOuterShadowedDark" }, -- Footer border
            { " ", "DialogFloatBorderOuterShadowedLight" }, -- Bottom Left corner

            { "▕", "DialogFloatBorderOuterShadowedLight" },
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
    local orig_set_config = vim.api.nvim_win_set_config

    local function get_config(bufnr, config)
        for _, rule in ipairs(conf) do
            if rule.condition then
                vim.validate("condition", rule.condition, "function", "condition must be a function")
                if rule.condition(bufnr, config) then
                    return vim.tbl_deep_extend("force", config, rule.style or {}), rule.after
                end
            end
        end
        return config, nil
    end

    ---@param bufnr integer Buffer to display, or 0 for current buffer
    ---@param enter boolean Enter the window (make it the current window)
    ---@param config vim.api.keyset.win_config Map defining the window configuration. Keys:
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.api.nvim_open_win = function(bufnr, enter, config)
        local updated_config, after_fn = get_config(bufnr, config)

        local win_id = orig_open_win(bufnr, enter, updated_config)

        if after_fn then
            vim.validate("after", after_fn, "function", "after must be a function")
            after_fn(win_id, bufnr, updated_config)
        end

        return win_id
    end

    ---@param win_id integer Buffer to display, or 0 for current buffer
    ---@param config vim.api.keyset.win_config Map defining the window configuration. Keys:
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.api.nvim_win_set_config = function(win_id, config)
        local bufnr = vim.api.nvim_win_get_buf(win_id)
        local updated_config, after_fn = get_config(bufnr, config)

        orig_set_config(win_id, updated_config)

        if after_fn then
            vim.validate("after", after_fn, "function", "after must be a function")
            after_fn(win_id, bufnr, updated_config)
        end
    end
end

return M
