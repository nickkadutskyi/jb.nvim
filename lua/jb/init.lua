local M = {}

local utils = require("jb.utils")

---@type fun(t: table): number
local function table_length(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

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

---@type fun()
function M.setup()
    local profile = vim.o.background -- 'dark' or 'light'
    local palette = utils.read_palette()
    local colors = palette.colors
    local highlights = palette.highlights
    local hl_groups = {}
    local set_hl_delayed = {}

    for _, groups in pairs(highlights) do
        for group, attrs in pairs(groups) do
            -- groups with `nil` or `""` values are skipped
            local hl = {}
            if type(attrs) == "string" and string.find(attrs, "|") ~= nil then
                -- Handling paths like `General|Text|...` pointing to a color
                -- in the palette from JB's colors
                local props = utils.get_hl_props(colors, attrs, profile)
                if group == props.name then
                    hl = props.hl
                else
                    if hl_groups[props.name] == nil then
                        vim.api.nvim_set_hl(0, props.name, props.hl)
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
                -- Iterate over attributes and set hl properties
                for attr, value in pairs(attrs) do
                    last_attr = attr
                    if type(value) == "string" and string.find(value, "|") ~= nil then
                        last_hl_name = string.gsub(value, "|", "_")
                        local props = utils.get_hl_props(colors, value, profile)
                        hl[attr] = props.prop or props.hl[attr]
                    else
                        hl[attr] = value
                    end
                end
                -- Customize group name if only one attribute is set
                local group_name = (table_length(attrs) == 1 and last_hl_name ~= nil)
                        and last_hl_name .. "-" .. last_attr
                    or group .. "_Custom"
                vim.api.nvim_set_hl(0, group_name, hl)
                hl.link = group_name
            end
            -- Set hl group properties if value is not `nil` or `""`
            if attrs ~= nil and attrs ~= "" then
                local props = hl.link ~= nil and { link = hl.link } or hl
                vim.api.nvim_set_hl(0, group, props)
            end
        end
    end

    -- Set delayed highlights after all groups are defined
    for group, hl in pairs(set_hl_delayed) do
        vim.api.nvim_set_hl(0, group, hl)
    end

    -- Set ProjectColor highlight group
    vim.api.nvim_set_hl(0, "ProjectColor", utils.get_project_color_hl())
end

return M
