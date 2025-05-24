local M = {}

---@alias profile "light" | "dark"

---@type fun(t: table): number
function M.table_length(t)
    local count = 0
    for _ in pairs(t) do
        count = count + 1
    end
    return count
end

-- Function to read the JSON palette
---@param path? string
---@return table
function M.read_palette(path)
    local default_path = "/lua/jb/palette.json"
    path = path == "" and default_path or (path or default_path)
    local plugin_dir = vim.fn.expand("<sfile>:p:h:h")
    local palette_path = plugin_dir .. path
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
function M.resolve_path(colors, path, profile, inherit_level, prev_paths)
    profile = profile or "light"
    inherit_level = inherit_level or 0
    prev_paths = prev_paths or {}

    assert(colors, "`colors` table is required.")
    assert(type(colors) == "table", string.format("Invalid palette structure. Expected a table, got %s.", type(colors)))
    assert(path, "`path` is required.")
    assert(type(path) == "string", string.format("`path` must be a string, got %s.", type(path)))

    local path_spl = M.split(path, "|")
    local node = colors

    for i, v in pairs(path_spl) do
        if node[v] == nil then
            error(string.format("Missing node '%s' in path '%s'.", v, path))
        end

        if i < #path_spl and type(node[v]) == "table" then
            -- If not last node, go deeper
            node = node[v]
        elseif i == #path_spl and type(node[v]) == "table" and type(node[v][profile]) == "table" then
            -- If last node is a table, return the profile
            return node[v][profile]
        elseif
            i == #path_spl
            and (type(node[v]) == "string" or (type(node[v]) == "table" and type(node[v][profile]) == "string"))
            -- Allows only three levels of inheritance
            and inherit_level <= 3
        then
            -- If last node is a string or a table with a profile that is a string,
            -- try to resolve it as a path
            return M.resolve_path(colors, (node[v][profile] or node[v]), profile, inherit_level + 1, prev_paths)
        elseif node[v] == nil then
            error(string.format("Missing node '%s' in path '%s'.", v, path))
        else
            error(
                string.format(
                    "Node '%s' is not defined properly in path '%s'.\n"
                        .. "Expecting a table with keys 'light' and 'dark'.\n"
                        .. "Got: %s\n",
                    v,
                    path,
                    vim.inspect(node[v])
                )
            )
        end
    end
    error("Nothing to resolve from.")
end

---Function to get colors from palette table
---@param colors table
---@param path_prop string
---@param profile profile
---@return {name: string, hl: table, prop: string|nil|boolean}
function M.get_hl_props(colors, path_prop, profile)
    local path_prop_spl = M.split(path_prop, ".")
    local prop = path_prop_spl[2]
    local hl = M.resolve_path(colors, path_prop_spl[1], profile)
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
    if str == "" then
        return { "" }
    else
        for substr in string.gmatch(str, "([^" .. sep .. "]+)") do
            table.insert(t, substr)
        end
    end
    return t
end

--- @return vim.api.keyset.highlight
function M.get_project_color_hl()
    local cwd = vim.fn.getcwd()
    ---@type string
    local name = vim.fs.basename(cwd)
    local parent = vim.fs.basename(vim.fs.dirname(cwd))
    local parent_parent = vim.fs.basename(vim.fs.dirname(vim.fn.fnamemodify(cwd, ":h")))
    ---Add numbers to hashs to make it more random
    local num_parent = tonumber(parent) or 1
    local num_name = 1
    for _, v in ipairs({ name:byte(-3, -1) }) do
        num_name = num_name + v
    end
    ---Get hashs and ensure within 0-255 range
    ---@type number
    local r, g, b =
        M.string_to_hash(parent_parent) % 255,
        (M.string_to_hash(parent) * num_parent) % 255,
        (M.string_to_hash(name) * num_name) % 255

    ---Calculate hue from sum of hashs
    local hue = (r + g + b) % 360 / 360

    -- Background: High saturation (0.8) and lightness (0.5)
    local r1, g1, b1 = M.hsl_to_rgb(hue, 0.7, 0.5)

    -- Foreground: White or near-white
    local r2, g2, b2 = 255, 255, 255

    return { bg = string.format("#%02X%02X%02X", r1, g1, b1), fg = string.format("#%02X%02X%02X", r2, g2, b2) }
end

--- Blend two colors together
---@param color1 string # Hex color in format "#RRGGBB"
---@param color2 string # Hex color in format "#RRGGBB"
---@param factor number # Blend factor (0.0 to 1.0, where 0.0 is full color1, 1.0 is full color2)
---@return string # Resulting hex color
function M.blend_colors(color1, color2, factor)
    -- Remove '#' if present
    color1 = color1:gsub("#", "")
    color2 = color2:gsub("#", "")

    -- Convert hex to RGB
    local r1, g1, b1 = tonumber(color1:sub(1, 2), 16), tonumber(color1:sub(3, 4), 16), tonumber(color1:sub(5, 6), 16)
    local r2, g2, b2 = tonumber(color2:sub(1, 2), 16), tonumber(color2:sub(3, 4), 16), tonumber(color2:sub(5, 6), 16)

    -- Blend colors
    local r = math.floor(r1 + (r2 - r1) * factor)
    local g = math.floor(g1 + (g2 - g1) * factor)
    local b = math.floor(b1 + (b2 - b1) * factor)

    -- Convert back to hex
    return string.format("#%02X%02X%02X", r, g, b)
end

---@param str string
---@return number
function M.string_to_hash(str)
    if str == "" then
        return 0
    end

    local hash = 0
    for i = 1, #str do
        local char = string.byte(str, i)
        -- Simulate Java's 32-bit integer arithmetic
        hash = ((hash * 31) + char) % 0x100000000
        -- Handle negative numbers (Java's int is signed)
        if hash >= 0x80000000 then
            hash = hash - 0x100000000
        end
    end
    return hash
end

function M.rgb_to_hue(r, g, b)
    -- Normalize RGB values to 0-1 range
    r = r / 255
    g = g / 255
    b = b / 255

    local max = math.max(r, g, b)
    local min = math.min(r, g, b)
    local delta = max - min
    local hue = 0

    if delta == 0 then
        return 0
    elseif max == r then
        hue = 60 * (((g - b) / delta) % 6)
    elseif max == g then
        hue = 60 * (((b - r) / delta) + 2)
    elseif max == b then
        hue = 60 * (((r - g) / delta) + 4)
    end

    -- Ensure hue is positive
    if hue < 0 then
        hue = hue + 360
    end

    return hue
end

function M.hsl_to_rgb(h, s, l)
    if s == 0 then
        return l, l, l
    end

    local function hue2rgb(p, q, t)
        if t < 0 then
            t = t + 1
        end
        if t > 1 then
            t = t - 1
        end
        if t < 1 / 6 then
            return p + (q - p) * 6 * t
        end
        if t < 1 / 2 then
            return q
        end
        if t < 2 / 3 then
            return p + (q - p) * (2 / 3 - t) * 6
        end
        return p
    end

    local q = l < 0.5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q

    local r = hue2rgb(p, q, h + 1 / 3)
    local g = hue2rgb(p, q, h)
    local b = hue2rgb(p, q, h - 1 / 3)

    return math.floor(r * 255), math.floor(g * 255), math.floor(b * 255)
end

return M
