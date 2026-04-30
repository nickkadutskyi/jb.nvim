local function split(str, sep)
    sep = sep or "%s"
    local t = {}
    if str == "" then
        return { "" }
    end
    for substr in string.gmatch(str, "([^" .. sep .. "]+)") do
        table.insert(t, substr)
    end
    return t
end

---@param colors table
---@param path string
---@param profile "light"|"dark"|"light_cb"
---@param inherit_level? number
---@param prev_paths? string[]
---@return table
local function resolve_path(colors, path, profile, inherit_level, prev_paths)
    profile = profile or "light"
    inherit_level = inherit_level or 0
    prev_paths = prev_paths or {}

    local base_profile = profile:match("^(.-)_cb$") or profile

    local path_spl = split(path, "|")
    local node = colors

    for i, v in pairs(path_spl) do
        if i < #path_spl and type(node[v]) == "table" then
            node = node[v]
        elseif i == #path_spl and type(node[v]) == "table" and type(node[v][profile] or node[v][base_profile]) == "table" then
            return node[v][profile] or node[v][base_profile]
        elseif
            i == #path_spl
            and (
                type(node[v]) == "string"
                or (type(node[v]) == "table" and type(node[v][profile] or node[v][base_profile]) == "string")
            )
            and inherit_level <= 4
        then
            table.insert(prev_paths, path)
            local ref = type(node[v]) == "string" and node[v] or (node[v][profile] or node[v][base_profile])
            return resolve_path(colors, ref, profile, inherit_level + 1, prev_paths)
        elseif node[v] == vim.NIL then
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

---@param t table
---@return boolean, integer
local function is_array(t)
    local max = 0
    local count = 0
    for k in pairs(t) do
        if type(k) ~= "number" or k < 1 or k % 1 ~= 0 then
            return false, 0
        end
        count = count + 1
        if k > max then
            max = k
        end
    end

    if max ~= count then
        return false, 0
    end

    return true, max
end

---@param t table
---@return (string|number)[]
local function sorted_keys(t)
    local keys = {}
    for k in pairs(t) do
        keys[#keys + 1] = k
    end
    table.sort(keys, function(a, b)
        local ta, tb = type(a), type(b)
        if ta == tb then
            if ta == "number" then
                return a < b
            end
            return tostring(a) < tostring(b)
        end
        return ta < tb
    end)
    return keys
end

---@param key string|number
---@return string
local function serialize_key(key)
    if type(key) == "number" then
        return "[" .. key .. "]"
    end
    return "[" .. string.format("%q", key) .. "]"
end

---@param value any
---@param seen table<table, boolean>
---@return string
local function serialize(value, seen)
    local value_type = type(value)

    if value == vim.NIL then
        return "vim.NIL"
    end

    if value_type == "string" then
        return string.format("%q", value)
    end

    if value_type == "number" or value_type == "boolean" then
        return tostring(value)
    end

    if value_type == "nil" then
        return "nil"
    end

    if value_type ~= "table" then
        error("Unsupported type for serialization: " .. value_type)
    end

    if seen[value] then
        error("Cannot serialize cyclic tables")
    end
    seen[value] = true

    local out = { "{" }
    local array, array_len = is_array(value)

    if array then
        for i = 1, array_len do
            out[#out + 1] = serialize(value[i], seen) .. ","
        end
    else
        for _, key in ipairs(sorted_keys(value)) do
            local serialized = serialize(value[key], seen)
            out[#out + 1] = serialize_key(key) .. "=" .. serialized .. ","
        end
    end
    out[#out + 1] = "}"

    seen[value] = nil
    return table.concat(out)
end

local this_file = debug.getinfo(1, "S").source:sub(2)
local script_dir = vim.fn.fnamemodify(this_file, ":p:h")
local repo_root = vim.fn.fnamemodify(script_dir, ":h")

local palette_json_path = repo_root .. "/lua/jb/palette.json"
local palette_compiled_path = repo_root .. "/lua/jb/palette_compiled.lua"

local file = assert(io.open(palette_json_path, "r"), "Failed to open palette.json")
local content = file:read("*a")
file:close()

local json_decode = (vim.json and vim.json.decode) or vim.fn.json_decode
local palette = assert(json_decode(content), "Failed to decode palette.json")
local colors = palette.colors
local highlights = palette.highlights
local icons = colors.Custom and colors.Custom.Icons
assert(type(icons) == "table", "palette.colors.Custom.Icons is required")

local path_props = {}
local base_paths = {}

---@param path_prop string
local function add_path_prop(path_prop)
    if type(path_prop) ~= "string" or not path_prop:find("|", 1, true) then
        return
    end

    local parts = split(path_prop, ".")
    local base_path = parts[1]
    local prop = parts[2]

    if base_path == nil or base_path == "" then
        return
    end

    path_props[path_prop] = {
        name = string.gsub(base_path, "|", "_"),
        base = base_path,
        prop = prop or false,
    }
    base_paths[base_path] = true
end

for _, groups in pairs(highlights) do
    for _, attrs in pairs(groups) do
        if type(attrs) == "string" then
            add_path_prop(attrs)
        elseif type(attrs) == "table" then
            for _, value in pairs(attrs) do
                if type(value) == "string" then
                    add_path_prop(value)
                end
            end
        end
    end
end

-- Additional runtime lookups outside the main highlight loop.
add_path_prop("Custom|StatusBar.bg")
add_path_prop("IdeaVim|Modes|Normal")
add_path_prop("IdeaVim|Modes|Insert")
add_path_prop("IdeaVim|Modes|Visual")
add_path_prop("IdeaVim|Modes|Replace")
add_path_prop("Custom|TabSel")

local resolved_hls = {
    light = {},
    dark = {},
    light_cb = {},
}

for base_path in pairs(base_paths) do
    resolved_hls.light[base_path] = resolve_path(colors, base_path, "light")
    resolved_hls.dark[base_path] = resolve_path(colors, base_path, "dark")
    resolved_hls.light_cb[base_path] = resolve_path(colors, base_path, "light_cb")
end

local compiled = {
    version = 2,
    highlights = highlights,
    icons = icons,
    resolved_hls = resolved_hls,
    path_props = path_props,
}

local output = {
    "-- Auto-generated by scripts/generate_palette_compiled.lua.\n",
    "-- Do not edit this file directly.\n\n",
    "return ",
    serialize(compiled, {}),
    "\n",
}

local out_file = assert(io.open(palette_compiled_path, "w"), "Failed to open output file")
out_file:write(table.concat(output))
out_file:close()

print("Generated " .. palette_compiled_path)
