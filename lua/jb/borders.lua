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
}

return M
