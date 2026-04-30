local M = {}

---@alias profile "light" | "dark" | "light_cb"

local resolve_path_cache = setmetatable({}, { __mode = "k" })
local hl_props_cache = setmetatable({}, { __mode = "k" })
local compiled_palette_cache = nil

---@param cache table<table, table<string, table<string, any>>>
---@param colors table
---@param profile profile
---@return table<string, any>
local function get_profile_cache(cache, colors, profile)
    local colors_cache = cache[colors]
    if colors_cache == nil then
        colors_cache = {}
        cache[colors] = colors_cache
    end

    local profile_cache = colors_cache[profile]
    if profile_cache == nil then
        profile_cache = {}
        colors_cache[profile] = profile_cache
    end

    return profile_cache
end

---@param colors table
---@param path_prop string
---@param profile profile
---@return {name: string, hl: table, prop: string|nil|boolean}|nil
local function get_compiled_hl_prop(colors, path_prop, profile)
    local path_props = colors.__path_props
    local resolved_hls = colors.__resolved_hls
    if type(path_props) ~= "table" or type(resolved_hls) ~= "table" then
        return nil
    end

    local path_meta = path_props[path_prop]
    if type(path_meta) ~= "table" then
        return nil
    end

    local profile_hls = resolved_hls[profile]
    if type(profile_hls) ~= "table" then
        return nil
    end

    local base_path = path_meta.base
    local hl = profile_hls[base_path]
    if type(hl) ~= "table" then
        return nil
    end

    local prop = path_meta.prop
    local prop_value = nil
    if prop == false then
        prop = nil
    elseif type(prop) == "string" and hl[prop] == nil then
        error("Invalid property: " .. prop .. " for " .. path_prop)
    elseif prop ~= nil then
        prop_value = hl[prop]
    end

    return {
        name = path_meta.name,
        hl = hl,
        prop = prop_value,
    }
end

---@return table|nil
local function get_cached_compiled_palette()
    if compiled_palette_cache ~= nil then
        return compiled_palette_cache
    end

    local ok, compiled_palette = pcall(require, "jb.palette_compiled")
    if not ok then
        return nil
    end

    if
        type(compiled_palette) ~= "table"
        or type(compiled_palette.highlights) ~= "table"
        or type(compiled_palette.resolved_hls) ~= "table"
        or type(compiled_palette.path_props) ~= "table"
        or type(compiled_palette.icons) ~= "table"
    then
        return nil
    end

    compiled_palette_cache = {
        colors = {
            Custom = {
                Icons = compiled_palette.icons,
            },
            __resolved_hls = compiled_palette.resolved_hls,
            __path_props = compiled_palette.path_props,
        },
        highlights = compiled_palette.highlights,
    }

    return compiled_palette_cache
end

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

    if path == default_path then
        local compiled = get_cached_compiled_palette()
        if compiled ~= nil then
            return compiled
        end
    end

    local plugin_dir = vim.fn.expand("<sfile>:p:h:h")
    local palette_path = plugin_dir .. path
    local file = io.open(palette_path, "r")
    if not file then
        error("Could not open palette.json at " .. palette_path)
    end
    local content = file:read("*a")
    file:close()
    local json_decode = (vim.json and vim.json.decode) or vim.fn.json_decode
    local ok, palette = pcall(json_decode, content)
    if not ok then
        error("Failed to parse palette.json: " .. palette)
    end
    return palette
end

--- Function to resolve a path in the palette
---
---@param colors table
---@param path string
---@param profile profile
---@param inherit_level ?number
---@param prev_paths ?table<string>
---
---@return vim.api.keyset.highlight
local function resolve_path_uncached(colors, path, profile, inherit_level, prev_paths)
    inherit_level = inherit_level or 0
    prev_paths = prev_paths or {}

    local path_spl = M.split(path, "|")
    local node = colors

    -- For _cb profiles, derive the base profile used as fallback when a _cb variant is absent
    local base_profile = profile:match("^(.-)_cb$") or profile

    for i, v in pairs(path_spl) do
        -- if node[v] == nil then
        --     error(string.format("Missing node '%s' in path '%s'.", v, path))
        -- end

        if i < #path_spl and type(node[v]) == "table" then
            -- If not last node, go deeper
            node = node[v]
        elseif i == #path_spl and type(node[v]) == "table" and type(node[v][profile] or node[v][base_profile]) == "table" then
            -- If last node is a table, return the profile (fall back to base_profile for _cb)
            return node[v][profile] or node[v][base_profile]
        elseif
            i == #path_spl
            and (
                type(node[v]) == "string"
                or (type(node[v]) == "table" and type(node[v][profile] or node[v][base_profile]) == "string")
            )
            -- Allows only three levels of inheritance
            and inherit_level <= 4
        then
            -- If last node is a string or a table with a profile that is a string,
            -- try to resolve it as a path
            table.insert(prev_paths, path)
            local ref = type(node[v]) == "string" and node[v] or (node[v][profile] or node[v][base_profile])
            return resolve_path_uncached(colors, ref, profile, inherit_level + 1, prev_paths)
        elseif node[v] == vim.NIL then
            -- NOTE: vim.NIL is null in JSON and it just clears hl group
            return {}
        elseif node[v] == nil then
            local p = (vim.tbl_count(prev_paths) > 0 and table.concat(prev_paths, " > ") .. " > " or "") .. path
            error(string.format("Missing node '%s' in path '%s'.", v, p))
        else
            error(
                string.format(
                    "Node '%s' is not defined properly in path '%s'.\n"
                        .. "Expecting a table with keys 'light' and 'dark' or nil.\n"
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

---@return vim.api.keyset.highlight
function M.resolve_path(colors, path, profile, inherit_level, prev_paths)
    profile = profile or "light"

    assert(colors, "`colors` table is required.")
    assert(type(colors) == "table", string.format("Invalid palette structure. Expected a table, got %s.", type(colors)))
    assert(path, "`path` is required.")
    assert(type(path) == "string", string.format("`path` must be a string, got %s.", type(path)))

    if inherit_level == nil and prev_paths == nil then
        local resolved_hls = colors.__resolved_hls
        if type(resolved_hls) == "table" and type(resolved_hls[profile]) == "table" then
            local resolved = resolved_hls[profile][path]
            if resolved ~= nil then
                return resolved
            end
        end

        local profile_cache = get_profile_cache(resolve_path_cache, colors, profile)
        if profile_cache[path] ~= nil then
            return profile_cache[path]
        end

        local resolved = resolve_path_uncached(colors, path, profile, 0, {})
        profile_cache[path] = resolved
        return resolved
    end

    return resolve_path_uncached(colors, path, profile, inherit_level, prev_paths)
end

---Function to get colors from palette table
---@param colors table
---@param path_prop string
---@param profile profile
---@return {name: string, hl: table, prop: string|nil|boolean}
function M.get_hl_props(colors, path_prop, profile)
    profile = profile or "light"

    local profile_cache = get_profile_cache(hl_props_cache, colors, profile)
    if profile_cache[path_prop] ~= nil then
        return profile_cache[path_prop]
    end

    local from_compiled = get_compiled_hl_prop(colors, path_prop, profile)
    if from_compiled ~= nil then
        profile_cache[path_prop] = from_compiled
        return from_compiled
    end

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
    local result = { name = hl_group_name, hl = hl, prop = hl[prop] }
    profile_cache[path_prop] = result
    return result
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

---@return vim.api.keyset.highlight, vim.api.keyset.highlight
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

    -- Background: High saturation (0.7) and lightness (0.5)
    local r1, g1, b1 = M.hsl_to_rgb(hue, 0.7, 0.5)

    -- Foreground: White or near-white
    local r2, g2, b2 = 255, 255, 255

    -- Foreground for icon: High saturation (0.8) and lightness (0.4)
    -- Make it less light and more saturated for better contrast
    local r3, g3, b3 = M.hsl_to_rgb(hue, 0.8, 0.4)

    local bg_based_bg = string.format("#%02X%02X%02X", r1, g1, b1)
    local bg_basesd_fg = string.format("#%02X%02X%02X", r2, g2, b2)

    local fg_based_fg = string.format("#%02X%02X%02X", r3, g3, b3)

    return { bg = bg_based_bg, fg = bg_basesd_fg }, { fg = fg_based_fg }
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
