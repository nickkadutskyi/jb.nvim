local M = {}

---@alias profile "light" | "dark"

-- Function to read the JSON palette
---@return table
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

--- Function to resolve a path in the palette
--- @param colors table
--- @param path string
--- @param profile profile
--- @param inherit_level ?number
--- @return vim.api.keyset.highlight
function M.resolve_path(colors, path, profile, inherit_level)
    inherit_level = inherit_level or 0
    local path_spl = M.split(path, "|")
    local node = colors
    for i, v in pairs(path_spl) do
        if i < #path_spl and type(node[v]) == "table" then
            node = node[v]
        elseif i == #path_spl and type(node[v]) == "table" and type(node[v][profile]) == "table" then
            return node[v][profile]
        elseif
            i == #path_spl
            and (type(node[v]) == "string" or type(node[v][profile]) == "string")
            -- Allows only three levels of inheritance
            and inherit_level <= 3
        then
            return M.resolve_path(colors, (node[v][profile] or node[v]), profile, inherit_level + 1)
        else
            error("Invalid path: " .. path .. "; Missing node: " .. v)
        end
    end
    error("Nothing to resolve from.")
end

--- Function to get colors from palette table
--- @param colors table
--- @param path_prop string
--- @param profile profile
--- @return {name: string, hl: table, prop: string|nil|boolean}
function M.get_hl_props(colors, path_prop, profile)
    local path_prop_spl = M.split(path_prop, ".")
    local prop = path_prop_spl[2]
    local hl = M.resolve_path(colors, path_prop_spl[1], profile)
    -- local hl = node[profile]
    -- if type(hl) == "string" then
    --     hl = M.resolve_path(colors, hl)[profile]
    -- end
    local hl_group_name = string.gsub(path_prop_spl[1], "|", "_")
    if prop ~= nil and type(hl[prop]) == nil then
        error("Invalid property: " .. prop .. " for " .. path_prop)
    end
    if type(hl) ~= "table" then
        error("Invalid highlight at: " .. path_prop .. ". Inspection: " .. vim.inspect(hl))
    end
    return { name = hl_group_name, hl = hl, prop = hl[prop] }
end

function M.split(str, sep)
    sep = sep or "%s"
    local t = {}
    for substr in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(t, substr)
    end
    return t
end

return M
