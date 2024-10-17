local M = {}

-- Function to read the JSON palette
function M.read_palette()
    local plugin_dir = vim.fn.expand("<sfile>:p:h:h")
    local palette_path = plugin_dir .. "/lua/jb/palette.json"
    local file = io.open(palette_path, "r")
    if not file then
        error("Could not open palette.json at " .. palette_path)
    end
    local content = file:read("*a")
    file:close()
    local ok, palette = pcall(vim.fn.json_decode, content)
    if not ok then
        error("Failed to parse palette.json: " .. palette)
    end
    return palette
end

-- Function to resolve a path in the palette
---@param colors table
---@param path string
---@param inherit_level ?number
---@return table
function M.resolve_path(colors, path, inherit_level)
    inherit_level = inherit_level or 0
    local path_spl = M.split(path, "|")
    local node = colors
    for i, v in pairs(path_spl) do
        if i < #path_spl and type(node[v]) == "table" then
            node = node[v]
        elseif i == #path_spl and type(node[v]) == "table" and node[v].light ~= nil and node[v].dark ~= nil then
            return node[v]
        elseif
            i == #path_spl
            and type(node[v]) == "string"
            -- Allows only two levels of inheritance
            and inherit_level <= 2
        then
            return M.resolve_path(colors, node[v], inherit_level + 1)
        else
            error("Invalid path: " .. path .. "; Missing node: " .. v)
        end
    end
    error("Nothing to resolve from.")
end

-- Function to get colors from palette table
---@param colors table
---@param path_prop string
---@return {name: string, hl: table, prop: string|nil}
function M.get_hl_props(colors, path_prop, profile)
    local path_prop_spl = M.split(path_prop, ".")
    local prop = path_prop_spl[2]
    local node = M.resolve_path(colors, path_prop_spl[1])
    local hl_group_name = string.gsub(path_prop_spl[1], "|", "_")
    if prop ~= nil then
        if type(node[profile][prop]) ~= "string" then
            error("Invalid property: " .. prop .. " for " .. path_prop)
        end
        return { name = hl_group_name, hl = node[profile], prop = node[profile][prop] }
    else
        return { name = hl_group_name, hl = node[profile], prop = nil }
    end
end

function M.split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

return M
