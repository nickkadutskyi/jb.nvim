local config = require("jb.config")
local utils = require("jb.utils")

local opts_per_hl = {
    Normal = { transparent = true },
    NormalNC = { transparent = true },
}

setmetatable(opts_per_hl, {
    __index = function(_, k)
        return {}
    end,
})

local M = {}

M.setup = config.setup

---@type fun(o: table): string
function M.dump(o)
    if type(o) == "table" then
        local s = "{ "
        for k, v in pairs(o) do
            if type(k) ~= "number" then
                k = '"' .. k .. '"'
            end
            s = s .. "[" .. k .. "] = " .. M.dump(v) .. ","
        end
        return s .. "} "
    else
        return tostring(o)
    end
end

function M.disable_hl_args(hl, opts)
    if opts.disable_hl_args.bold then
        hl.bold = nil
    end
    if opts.disable_hl_args.italic then
        hl.italic = nil
    end
    return hl
end

---@type fun(opts?: jb.Config)
function M.load(opts)
    opts = require("jb.config").extend(opts)

    local profile = vim.o.background -- 'dark' or 'light'
    local palette = utils.read_palette("/lua/jb/palette.json")
    local colors = palette.colors
    local highlights = palette.highlights
    local hl_groups = {}
    local set_hl_delayed = {}

    -- Apply snacks.nvim configs
    if not opts.snacks.explorer.enabled then
        -- Remove explorer highlights if snacks.nvim is not enabled
        highlights["Plugin.folke/snacks.nvim.explorer"] = nil
    end

    for _, groups in pairs(highlights) do
        for group, attrs in pairs(groups) do
            -- groups with `nil` or `""` values are skipped
            local hl = {}
            local transparent = opts_per_hl[group].transparent and opts.transparent or false
            if type(attrs) == "string" and string.find(attrs, "|") ~= nil then
                -- Handling paths like `General|Text|...` pointing to a color
                -- in the palette from JB's colors
                local props = utils.get_hl_props(colors, attrs, profile)
                if group == props.name then
                    hl = props.hl
                else
                    if hl_groups[props.name] == nil then
                        vim.api.nvim_set_hl(0, props.name, M.disable_hl_args(props.hl, opts))
                        hl_groups[props.name] = true
                    end
                    hl.link = props.name
                end
            elseif type(attrs) == "string" and attrs ~= "" then
                -- Handling links, non-path string is a link to another hl group
                -- Will be created after all groups are set
                hl.link = attrs
                set_hl_delayed[group] = hl
            elseif type(attrs) == "table" then
                -- Handling attributes, tables are treated as hl group properties
                -- If table is empty then it creates a cleared hl group
                local last_hl_name = nil
                local last_attr = nil
                local nolink = false
                -- Iterate over attributes and set hl properties
                for attr, value in pairs(attrs) do
                    if attr == "nolink" then
                        nolink = value
                    else
                        last_attr = attr
                        if type(value) == "string" and string.find(value, "|") ~= nil then
                            last_hl_name = string.gsub(value, "|", "_")
                            local props = utils.get_hl_props(colors, value, profile)
                            hl[attr] = props.prop or props.hl[attr]
                        else
                            hl[attr] = value
                        end
                    end
                end
                -- Customize group name if only one attribute is set
                local group_name = (utils.table_length(attrs) == 1 and last_hl_name ~= nil)
                        and last_hl_name .. "-" .. last_attr
                    or group .. "_Custom"
                if not nolink then
                    vim.api.nvim_set_hl(0, group_name, M.disable_hl_args(hl, opts))
                    hl.link = group_name
                else
                    hl.bg = transparent and "NONE" or hl.bg
                    hl = hl
                end
            end
            -- Set hl group properties if value is not `nil` or `""`
            if attrs ~= nil and attrs ~= "" then
                local props = hl.link ~= nil and { link = hl.link } or hl
                vim.api.nvim_set_hl(0, group, M.disable_hl_args(props, opts))
            end
        end
    end

    -- Set delayed highlights after all groups are defined
    for group, hl in pairs(set_hl_delayed) do
        vim.api.nvim_set_hl(0, group, M.disable_hl_args(hl, opts))
    end

    -- Set ProjectColor highlight group
    local project_color = utils.get_project_color_hl()
    local status_line_color = utils.get_hl_props(colors, "Custom|StatusBar.bg", profile)
    vim.api.nvim_set_hl(0, "ProjectColor", M.disable_hl_args(project_color, opts))
    -- Tinted variants based on project color
    local tinted_status_line_bg = utils.blend_colors(status_line_color.hl.bg, project_color.bg, 0.1)
    vim.api.nvim_set_hl(0, "StatusLineTinted", {
        bg = tinted_status_line_bg,
    })
    local tinted_status_line_secondary_bg = utils.blend_colors(status_line_color.hl.bg, project_color.bg, 0.025)
    vim.api.nvim_set_hl(0, "StatusLineSecondaryTinted", {
        bg = tinted_status_line_secondary_bg,
    })
    -- Tinted modes
    vim.api.nvim_set_hl(0, "StatusLineTintedNormal", {
        fg = status_line_color.hl.fg,
        bg = utils.blend_colors(
            status_line_color.hl.bg,
            utils.get_hl_props(colors, "IdeaVim|Modes|Normal", profile).hl.bg,
            0.1
        ),
    })
    vim.api.nvim_set_hl(0, "StatusLineTintedInsert", {
        fg = status_line_color.hl.fg,
        bg = utils.blend_colors(
            status_line_color.hl.bg,
            utils.get_hl_props(colors, "IdeaVim|Modes|Insert", profile).hl.bg,
            0.1
        ),
    })
    vim.api.nvim_set_hl(0, "StatusLineTintedVisual", {
        fg = status_line_color.hl.fg,
        bg = utils.blend_colors(
            status_line_color.hl.bg,
            utils.get_hl_props(colors, "IdeaVim|Modes|Visual", profile).hl.bg,
            0.1
        ),
    })
    vim.api.nvim_set_hl(0, "StatusLineTintedReplace", {
        fg = status_line_color.hl.fg,
        bg = utils.blend_colors(
            status_line_color.hl.bg,
            utils.get_hl_props(colors, "IdeaVim|Modes|Replace", profile).hl.bg,
            0.1
        ),
    })
    -- Tinted file VCS status

    local vcs_hls = {
        "VCS_Added_StatusLine",
        "VCS_Copied_StatusLine",
        "VCS_Deleted_StatusLine",
        "VCS_DeletedFromFileSystem_StatusLine",
        "VCS_HaveChangedDescendants_StatusLine",
        "VCS_HaveImmediateChangedChildren_StatusLine",
        "VCS_Ignored_StatusLine",
        "VCS_IgnoredIgnorePlugin_StatusLine",
        "VCS_Merged_StatusLine",
        "VCS_MergedWithConflicts_StatusLine",
        "VCS_Modified_StatusLine",
        "VCS_Renamed_StatusLine",
        "VCS_Unknown_StatusLine",
    }
    for _, hl in ipairs(vcs_hls) do
        local hl_props = vim.api.nvim_get_hl(0, { name = hl .. "_Custom" })
        vim.api.nvim_set_hl(0, hl .. "_Tinted", {
            fg = "#" .. string.format("%06x", (hl_props.fg or "")),
            bg = tinted_status_line_secondary_bg,
        })
    end
    vim.api.nvim_set_hl(0, "Custom_TabSel_Tinted", {
        fg = utils.get_hl_props(colors, "Custom|TabSel", profile).hl.fg,
        bg = tinted_status_line_secondary_bg,
    })
end

return M
