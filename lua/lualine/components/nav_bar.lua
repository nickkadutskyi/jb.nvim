-- 󱓼 [cwd name|root name if file is outside of cwd] [path] [filetype] [filename]
-- Show module name (project directory or current cwd basename)
-- if no file is open or if current file is in cwd

-- if current file is outside of cwd, try to get its' module name

local M = require("lualine.component"):extend()
local utils = require("lualine.utils.utils")
local highlight = require("lualine.highlight")

local default_options = {
    padding = { left = 1, right = 0 }, -- padding around the icon
    -- icon_color_highlight = "JBIconModule",
    -- icon_color_current_highlight = "JBIconModuleProject",

    ---@class NavBarOptions
    nav_bar_opts = {
        separator = " › ", -- separator between nav bar items
        icon = { "󱓼 ", hl = "JBIconModuleProject" }, -- icon for the nav bar},
        hl = "",
    },
}

-- State

local _cache = {
    cwd = nil,
    in_cwd = {},
    project_name = nil,
    is_normal_buffer = {},
    module_name = {},
    module_root = {},
    path_components = {},
}

local _nav_state = {
    components = {},
    current_index = nil,
}

-- Helpers

---@return boolean
local function is_normal_buffer_uncached()
    local buftype = vim.bo.buftype
    local filetype = vim.bo.filetype

    -- Check if buffer has a special buftype (terminal, quickfix, help, etc.)
    if buftype ~= "" then
        return false
    end

    -- Check for special filetypes that indicate non-normal buffers
    local special_filetypes = {
        "netrw",
        "NvimTree",
        "neo-tree",
        "help",
        "qf",
        "quickfix",
        "terminal",
        "checkhealth",
        "man",
        "TelescopePrompt",
        "lazy",
        "mason",
        "lspinfo",
        "null-ls-info",
        "startify",
        "dashboard",
        "alpha",
        "trouble",
        "fugitive",
        "gitcommit",
        "DiffviewFiles",
        "packer",
        "minifiles",
        "oil",
        "undotree",
        "vista",
        "tagbar",
        "aerial",
        "Outline",
        "dap-repl",
        "dapui_watches",
        "dapui_stacks",
        "dapui_breakpoints",
        "dapui_scopes",
        "dapui_console",
        "notify",
        "noice",
        "nui",
    }

    for _, ft in ipairs(special_filetypes) do
        if filetype == ft then
            return false
        end
    end

    -- Check if buffer is modifiable (some special buffers are not modifiable)
    -- if not vim.bo.modifiable then
    --     return false
    -- end

    -- Check if buffer name suggests it's a special buffer
    local bufname = vim.fn.bufname()
    if bufname == "" then
        -- Empty buffer name could be a new file, which is normal
        return true
    end

    -- Check for special buffer name patterns
    local special_patterns = {
        "^term://", -- terminal buffers
        "^fugitive://", -- fugitive buffers
        "^diffview://", -- diffview buffers
        "^gitsigns://", -- gitsigns buffers
        "^dap%-", -- DAP buffers
        "^%[.*%]$", -- buffers with names like [No Name], [Scratch], etc.
    }

    for _, pattern in ipairs(special_patterns) do
        if bufname:match(pattern) then
            return false
        end
    end

    return true
end

---@return boolean
local function is_normal_buffer()
    local bufnr = vim.api.nvim_get_current_buf()

    -- Check if we have a cached result for this buffer
    if _cache.is_normal_buffer[bufnr] ~= nil then
        return _cache.is_normal_buffer[bufnr]
    end

    -- Calculate and cache the result
    local result = is_normal_buffer_uncached()
    _cache.is_normal_buffer[bufnr] = result

    return result
end

---@return string
local function get_cwd()
    if not _cache.cwd then
        _cache.cwd = vim.fn.getcwd()
    end
    return _cache.cwd
end

---@return string
local function get_project_name()
    if not _cache.project_name then
        _cache.project_name = vim.fn.fnamemodify(get_cwd(), ":t")
    end
    return _cache.project_name
end

---@param path string
---@return boolean
local function is_in_cwd(path)
    assert(type(path) == "string" and path ~= "", "Path must be a non-empty string")

    if _cache.in_cwd[path] ~= nil then
        return _cache.in_cwd[path]
    else
        _cache.in_cwd[path] = path:find(get_cwd(), 1, true) == 1
    end

    return _cache.in_cwd[path]
end

---@param path string
---@return string|nil
local function find_project_root(path)
    -- TODO: find other project root markers
    local root_markers = {
        ".git",
        ".github",
        "package.json",
        "Cargo.toml",
        "pyproject.toml",
        "setup.py",
        "go.mod",
        "pom.xml",
        "build.gradle",
        "Makefile",
        "CMakeLists.txt",
        ".projectile",
        ".root",
        "composer.json",
        ".editorconfig",
        ".idea",
        ".vscode",
        ".svn",
        "filetype.lua",
    }

    local current_dir = vim.fn.fnamemodify(path, ":h")

    while current_dir ~= "/" and current_dir ~= "" do
        for _, marker in ipairs(root_markers) do
            if
                vim.fn.filereadable(current_dir .. "/" .. marker) == 1
                or vim.fn.isdirectory(current_dir .. "/" .. marker) == 1
            then
                return current_dir
            end
        end
        current_dir = vim.fn.fnamemodify(current_dir, ":h")
    end

    return nil
end

---@param path string
---@return string|nil, string|nil
local function find_lsp_root(path)
    -- Get lsp client for current buffer
    -- Returns nil or string
    local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if next(clients) == nil then
        return nil
    end

    for _, client in pairs(clients) do
        local filetypes = client.filetypes or client.config.filetypes
        if filetypes and vim.tbl_contains(filetypes, buf_ft) then
            return client.config.root_dir, client.name
        end
    end

    return nil, nil
end

---@param path string
---@return string, string|nil
local function get_module(path)
    -- Check cache first
    if _cache.module_name[path] ~= nil then
        return _cache.module_name[path], _cache.module_root[path]
    end

    local module_name, module_root
    if is_in_cwd(path) then
        module_name = get_project_name()
        module_root = get_cwd()
    else
        -- Try to find project root using various methods
        local project_root = find_lsp_root(path) or find_project_root(path)

        if project_root then
            module_name = vim.fn.fnamemodify(project_root, ":t")
            module_root = project_root
        else
            -- Fallback: use deepest directory based on path type
            if vim.fn.fnamemodify(path, ":p") == path then
                -- Absolute path - use root "/"
                module_name = "/"
                module_root = nil
            else
                -- Relative path - use first directory component
                local parts = vim.split(path, "/")
                module_name = parts[1] or vim.fn.fnamemodify(path, ":t")
                module_root = nil
            end
        end
    end

    -- Cache the result
    _cache.module_name[path] = module_name
    _cache.module_root[path] = module_root
    return module_name, module_root
end

---@param path string
---@return string[]
local function get_path_components(path)
    if not path or path == "" then
        return {}
    end

    -- Check cache first
    if _cache.path_components[path] ~= nil then
        return _cache.path_components[path]
    end

    local components = {}

    if is_in_cwd(path) then
        -- File is in cwd, get relative path from cwd
        local relative_path = vim.fn.fnamemodify(path, ":.")

        -- Remove the filename, keep only directory components
        local dir_path = vim.fn.fnamemodify(relative_path, ":h")

        if dir_path ~= "." then
            components = vim.split(dir_path, "/")
        end
    else
        -- File is outside cwd, get path relative to its module root
        local module_name, project_root = get_module(path)

        if project_root then
            -- Get path relative to project root
            local relative_path = path:sub(#project_root + 2) -- +2 to skip the trailing "/"
            local dir_path = vim.fn.fnamemodify(relative_path, ":h")

            if dir_path ~= "." then
                components = vim.split(dir_path, "/")
            end
        else
            -- Fallback: get all directory components after module
            local dir_path = vim.fn.fnamemodify(path, ":h")

            if module_name == "/" then
                -- Absolute path, remove leading "/" and get all components except filename
                local parts = vim.split(dir_path:sub(2), "/") -- Remove leading "/"
                components = parts
            else
                -- Relative path, get components after the first directory (module)
                local parts = vim.split(dir_path, "/")
                for i = 2, #parts do
                    table.insert(components, parts[i])
                end
            end
        end
    end

    -- Cache the result
    _cache.path_components[path] = components
    return components
end

---@class NavBarOptions
local function build_nav_components(config)
    if not is_normal_buffer() then
        return _nav_state.components or {}
    end
    local path = vim.fn.expand("%:p")

    -- Handle empty path (no file open)
    if path == "" then
        local components = {}
        -- Just show the current working directory as module
        table.insert(components, {
            icon = config.icon,
            text = get_project_name(),
        })
        _nav_state.components = components
        _nav_state.current_index = #components
        return components
    end

    local components = {}

    -- Adds module
    local module_icon = config.icon
    -- Do not use ProjectColor for Icon if the file is not in cwd
    if not is_in_cwd(path) then
        module_icon = vim.tbl_deep_extend("force", config.icon, { hl = "JBIconModule" })
    end
    table.insert(components, {
        icon = module_icon,
        text = get_module(path),
    })

    -- Add path components (directory hierarchy)
    local path_components = get_path_components(path)
    for _, dir_name in ipairs(path_components) do
        table.insert(components, {
            text = dir_name,
        })
    end

    -- TODO: Add filename component with filetype icon
    -- TODO: Add navic component if available

    -- Store components in the navigation state
    _nav_state.components = components
    _nav_state.current_index = #components

    return components
end

-- Lualine API

function M:init(options)
    M.super.init(self, options)
    self.options = vim.tbl_deep_extend("keep", self.options or {}, default_options)
end

function M:update_status()
    ---@type NavBarOptions
    local config = self.options.nav_bar_opts
    local components = build_nav_components(config)

    local result_parts = {}
    for i, component in ipairs(components) do
        -- Process icon
        local icon = component.icon and component.icon[1] or nil
        local icon_hl = component.icon and component.icon.hl or nil
        if icon and icon_hl then
            icon = "%#" .. icon_hl .. "#" .. icon .. "%*"
        end

        -- Process text
        local text = component.text
        local text_hl = component.hl or config.hl or nil
        if text_hl then
            text = "%#" .. text_hl .. "#" .. text .. "%*"
        end
        local part = (icon or "") .. text

        table.insert(result_parts, part)
    end

    local result = table.concat(result_parts, config.separator)

    -- return is_in_cwd(path) and (get_project_name() .. self.options.nav_bar_opts.separator) or ""
    return result .. (config.separator or "")
end

-- Autocmds

-- CWD change detection
vim.api.nvim_create_autocmd({ "DirChanged" }, {
    group = vim.api.nvim_create_augroup("nav_bar-dir-changed", { clear = true }),
    callback = function(event)
        -- clears cached cwd when directory changes
        _cache.cwd = nil
        _cache.in_cwd = {}
        _cache.project_name = nil
        _cache.module_name = {}
        _cache.module_root = {}
    end,
})
-- Buffer normality result invalidation
vim.api.nvim_create_autocmd({ "BufModifiedSet", "FileType" }, {
    group = vim.api.nvim_create_augroup("nav_bar-buffer-changed", { clear = true }),
    callback = function(event)
        local bufnr = event.buf or vim.api.nvim_get_current_buf()
        _cache.is_normal_buffer[bufnr] = nil
    end,
})

return M
