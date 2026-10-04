local M = {}

local highlights = {
    border = "FloatBorder",
    normal = "FzfLuaFzfNormal",
    cursor = "FzfLuaFzfCursorLine",
    matched = "FzfLuaFzfMatch",
    title = "FzfLuaTitle",
    prompt = "FzfLuaFzfPrompt",
    active_file = "FzfLuaFzfCursorLine",
    frecency = "Number",
    debug = "Comment",
    combo_header = "Number",
    scrollbar = "FzfLuaFzfScrollbar",
    grep_match = "CustomFFFGrepMatch",
    grep_line_number = "CustomFFFGrepLineNr",
    grep_regex_active = "CustomFFFRegexActive",
    grep_regex_inactive = "CustomFFFRegexInactive",
    grep_fuzzy_active = "CustomFFFRegexInactive",
    suggestion_header = "WarningMsg",
    winhl = {
        preview = "Normal:Normal,IncSearch:FzfLuaSearch,FloatTitle:DialogFloatBorderTop",
    },
}

-- Picker configs may be recreated on every invocation. Keep their original
-- mappings so disabling the integration also works for reused configs.
local original_highlights = setmetatable({}, { __mode = "k" })

---@param enabled boolean
---@return EnforceFloatStyle[]
function M.setup(enabled)
    if not enabled then
        for picker_config, original in pairs(original_highlights) do
            picker_config.hl = original.hl
        end
        original_highlights = setmetatable({}, { __mode = "k" })
        return {}
    end

    local borders = require("jb.borders").borders.dialog
    local rules = {}
    local function add_rule(buffer, border)
        rules[#rules + 1] = {
            style = { border = border },
            condition = function(bufnr)
                -- Do not load fff until the user actually opens a picker.
                local picker = package.loaded["fff.picker_ui.picker_ui_state"]
                local state = picker and picker.state
                if not state or bufnr ~= state[buffer] then
                    return false
                end

                -- fff resolves window highlights after opening its windows.
                -- Apply mappings here so this works with either plugin load order.
                local picker_config = state.config
                if picker_config and not original_highlights[picker_config] then
                    original_highlights[picker_config] = { hl = picker_config.hl }
                    picker_config.hl = vim.tbl_deep_extend("force", {}, picker_config.hl or {}, highlights)
                end
                return true
            end,
        }
    end

    add_rule("input_buf", borders.default_box_split_top_no_footer_shadowed)
    add_rule("list_buf", borders.default_box_split_middle_shadowed_no_footer)
    add_rule("preview_buf", borders.default_box_split_bottom_shadowed_header)
    return rules
end

return M
