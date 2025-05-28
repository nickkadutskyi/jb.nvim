-- Provides icons similar to the ones used in JetBrains IDEs
-- Source: https://intellij-icons.jetbrains.design/

---@class jb.icons
local M = {}

---@type table<vim.diagnostic.Severity, string>
M.diagnostic = {
    ERROR = "󰀨",
    WARN = "",
    INFO = "", -- Weak Warning
    HINT = "󰋼", -- Consideration
    [1] = "󰀨",
    [2] = "",
    [3] = "",
    [4] = "󰋼",
    E = "󰀨",
    W = "",
    I = "",
    N = "󰋼",
}

-- Even though colors help to distinguish between different types of icons,
-- the shape of the icon is more important.
---@type table<string, string>
M.kind = {
    File = "",
    Folder = "",
    Module = "󱓼",
    Package = "",

    Namespace = "󰰒",
    Interface = "󰰅",
    Class = "󰯳",
    Constructor = "󰰏",
    Method = "󰰑",
    Property = "󰰚",
    Field = "󰯺",

    Enum = "󰯹",
    -- Same as Constant (as in IntelliJ) since you already in the context of an enum
    EnumMember = "󰯱",
    Struct = "󰰡",

    Function = "󰯼",
    Variable = "󰰬",
    -- Should be rhomboid with `c` but not available in Nerd Font
    Constant = "󰯱",

    Text = "",
    Value = "󰰪",

    -- No icon for builtin keywords
    Keyword = "",
    Key = "",

    -- JB template
    Snippet = "󰴹",

    Unit = "",
    Operator = "󱖦",

    Color = "󰕰",
    Reference = "󰬳",
    Event = "󱐌",

    TypeParameter = "󰰦",

    -- IntelliJ's icons for String & Text look the same so picked something else
    String = "󰯫",
    Number = "󰽾",
    Boolean = "",
    Null = "∅",

    -- TODO: Reconsider theses icons, looks how LSs use theses kinds
    Array = "",
    Object = "",
}

---@alias jb.iconName string Name of the icon

---@class jb.ColorVairant
---@field color string Hex color code
---@field cterm_color string cterm color code

---@class jb.Icon
---@field icon string Nerd-font glyph
---@field light nil|jb.ColorVairant Color variant of the icon
---@field dark nil|jb.ColorVairant Color variant of the icon
---@field color nil|string Hex color code
---@field cterm_color nil|string cterm color code
---@field name jb.iconName

---@type {
---  by_filename: table<string, jb.Icon>,
---  by_extension: table<string, jb.Icon>,
---  by_filetype: table<string, jb.Icon>
---}
M.files = {
    by_filename = {
        [".editorconfig"] = {
            name = "EditorConfig",
            icon = "",
            dark = { color = "#C9CBD0", cterm_color = "188" },
            light = { color = "#7B7E8A", cterm_color = "102" },
        },
        [".env"] = {
            name = "Env",
            icon = "",
            light = { color = "#6C707D", cterm_color = "60" },
            dark = { color = "#CED0D6", cterm_color = "188" },
        },
        [".envrc"] = {
            name = "Envrc",
            icon = "",
            light = { color = "#6C707D", cterm_color = "60" },
            dark = { color = "#CED0D6", cterm_color = "188" },
        },
        [".gitignore"] = {
            name = "Gitignore",
            icon = "",
            light = { color = "#737783", cterm_color = "66" },
            dark = { color = "#C6C7CD", cterm_color = "188" },
        },
        [".htaccess"] = {
            name = "ApacheConfig",
            icon = "",
            light = { color = "#D16154", cterm_color = "167" },
            dark = { color = "#B24436", cterm_color = "167" },
        },
    },
    by_extension = {
        ["css"] = {
            name = "Css",
            icon = "",
            light = { color = "#4985F3", cterm_color = "33" },
            dark = { color = "#578CF0", cterm_color = "69" },
        },
        ["css.map"] = {
            name = "CssMap",
            icon = "",
            light = { color = "#7A58E8", cterm_color = "98" },
            dark = { color = "#AF8EE6", cterm_color = "140" },
        },
        ["env"] = {
            name = "Env",
            icon = "",
            light = { color = "#6C707D", cterm_color = "60" },
            dark = { color = "#CED0D6", cterm_color = "188" },
        },
        ["js"] = {
            name = "Js",
            icon = "",
            light = { color = "#F8B13E", cterm_color = "214" },
            dark = { color = "#EEC56C", cterm_color = "221" },
        },
        ["php"] = {
            name = "Php",
            -- icon = " ",
            -- icon = " ",
            icon = "󰌟",
            light = { color = "#3F7CE9", cterm_color = "32" },
            dark = { color = "#5689E9", cterm_color = "69" },
        },
        ["png"] = {
            name = "Png",
            icon = "",
            light = { color = "#3877E8", cterm_color = "32" },
            dark = { color = "#578CF0", cterm_color = "69" },
        },
        ["jpg"] = {
            name = "Jpg",
            icon = "",
            light = { color = "#3877E8", cterm_color = "32" },
            dark = { color = "#578CF0", cterm_color = "69" },
        },
        ["jpeg"] = {
            name = "Jpeg",
            icon = "",
            light = { color = "#3877E8", cterm_color = "32" },
            dark = { color = "#578CF0", cterm_color = "69" },
        },
        ["sass"] = {
            name = "Sass",
            icon = "󰟬",
            -- same in both light and dark themes
            color = "#C46E98",
            cterm_color = "167",
        },
        ["scss"] = {
            name = "Scss",
            icon = "󰟬",
            -- same in both light and dark themes
            color = "#C46E98",
            cterm_color = "167",
        },
        ["yml"] = {
            name = "Yml",
            icon = "󰰳",
            light = { color = "#D04A4F", cterm_color = "167" },
            dark = { color = "#D1655F", cterm_color = "167" },
        },
        ["yaml"] = {
            name = "Yaml",
            icon = "󰰳",
            light = { color = "#D04A4F", cterm_color = "167" },
            dark = { color = "#D1655F", cterm_color = "167" },
        },
        ["log"] = {
            name = "Log",
            icon = "",
            color = "#81e043",
        },
    },
    by_filetype = {},
}

return M
