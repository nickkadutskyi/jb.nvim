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

---@type { by_filename: table<string, jb.Icon>,
---        by_extension: table<string, jb.Icon>,
---        by_filetype: table<string, jb.Icon> }
M.files = {
    by_filename = {
        [".ds_store"] = {
            name = "Configuration",
            icon = "",
        },
        [".editorconfig"] = {
            name = "Configuration",
            icon = "",
        },
        [".env"] = {
            name = "PlainText",
            icon = "",
        },
        [".env.example"] = {
            name = "PlainText",
            icon = "",
        },
        [".env.local"] = {
            name = "PlainText",
            icon = "",
        },
        [".env.staging"] = {
            name = "PlainText",
            icon = "",
        },
        [".env.prod"] = {
            name = "PlainText",
            icon = "",
        },
        [".env.production"] = {
            name = "PlainText",
            icon = "",
        },
        [".env.va"] = {
            name = "PlainText",
            icon = "",
        },
        [".envrc"] = {
            name = "PlainText",
            icon = "",
        },
        [".eslintrc.cjs"] = {
            name = "Eslint",
            icon = "",
            light = { color = "#4733BC", cterm_color = "61" },
            dark = { color = "#FFFFFF", cterm_color = "231" },
        },
        [".jsbeautifyrc"] = {
            name = "PlainText",
            icon = "",
        },
        [".gitattributes"] = {
            name = "PlainText",
            icon = "",
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
        [".luacheckrc"] = {
            name = "PlainText",
            icon = "",
        },
        [".php-version"] = {
            name = "PlainText",
            icon = "",
        },
        [".stylelintrc.json"] = {
            name = "Stylelint",
            icon = "",
            light = { color = "#000000", cterm_color = "16" },
            dark = { color = "#FFFFFF", cterm_color = "231" },
        },
        ["artisan"] = {
            name = "Php",
            icon = "󰌟",
        },
        ["composer.phar"] = {
            name = "Archive",
            icon = "󰿺",
        },
        ["composer.lock"] = {
            name = "Json",
            icon = "",
        },
        ["config"] = {
            name = "Configuration",
            icon = "",
        },
        ["flake.lock"] = {
            name = "Json",
            icon = "",
        },
        ["license"] = {
            name = "PlainText",
            icon = "",
        },
        ["license.md"] = {
            name = "PlainText",
            icon = "",
        },
        ["makefile"] = {
            name = "Makefile",
            icon = "",
            light = { color = "#3877E8", cterm_color = "32" },
            dark = { color = "#578CF0", cterm_color = "69" },
        },
        ["package.json"] = {
            name = "PackageJson",
            icon = "",
            light = { color = "#7A58E8", cterm_color = "98" },
            dark = { color = "#AF8EE6", cterm_color = "140" },
        },
        ["postcss.config.mjs"] = {
            name = "Js",
            icon = "",
        },
        ["postcss.config.cjs"] = {
            name = "Js",
            icon = "",
        },
        ["postcss.config.js"] = {
            name = "Js",
            icon = "",
        },
        ["readme.md"] = {
            name = "Md",
            icon = "",
        },
        ["symfony.lock"] = {
            name = "Json",
            icon = "",
        },
        ["tailwind.config.js"] = {
            name = "Js",
            icon = "",
        },
        ["tailwind.config.cjs"] = {
            name = "Js",
            icon = "",
        },
        ["tailwind.config.mjs"] = {
            name = "Js",
            icon = "",
        },
        ["tsconfig.json"] = {
            name = "Json",
            icon = "",
        },
        ["version"] = {
            name = "Version",
            icon = "",
            light = { color = "#6C707D", cterm_color = "60" },
            dark = { color = "#CED0D6", cterm_color = "188" },
        },
    },
    by_extension = {
        ["bib"] = {
            name = "Bibtex",
            icon = "󰯮",
            dark = { color = "#C1805B", cterm_color = "137" },
            light = { color = "#DD7430", cterm_color = "166" },
        },
        ["cfg"] = {
            name = "Configuration",
            icon = "",
            dark = { color = "#C9CBD0", cterm_color = "188" },
            light = { color = "#7B7E8A", cterm_color = "102" },
        },
        ["conf"] = {
            name = "Configuration",
            icon = "",
            dark = { color = "#C9CBD0", cterm_color = "188" },
            light = { color = "#7B7E8A", cterm_color = "102" },
        },
        ["css"] = {
            name = "Css",
            icon = "",
            light = { color = "#4985F3", cterm_color = "33" },
            dark = { color = "#578CF0", cterm_color = "69" },
        },
        ["css.map"] = {
            name = "Json",
            icon = "",
        },
        ["d.ts"] = {
            name = "Ts",
            icon = "",
        },
        ["env"] = {
            name = "PlainText",
            icon = "",
            light = { color = "#6C707D", cterm_color = "60" },
            dark = { color = "#CED0D6", cterm_color = "188" },
        },
        ["html"] = {
            name = "Html",
            icon = "",
            light = { color = "#4F955B", cterm_color = "71" },
            dark = { color = "#619160", cterm_color = "65" },
        },
        ["icn"] = {
            name = "Image",
            icon = "",
        },
        ["icns"] = {
            name = "Image",
            icon = "",
        },
        ["ico"] = {
            name = "Image",
            icon = "",
        },
        ["ini"] = {
            name = "Configuration",
            icon = "",
        },
        ["js"] = {
            name = "Js",
            icon = "",
            light = { color = "#F8B13E", cterm_color = "214" },
            dark = { color = "#EEC56C", cterm_color = "221" },
        },
        ["jpeg"] = {
            name = "Image",
            icon = "",
        },
        ["jpg"] = {
            name = "Image",
            icon = "",
        },
        ["json"] = {
            name = "Json",
            icon = "",
            light = { color = "#7A58E8", cterm_color = "98" },
            dark = { color = "#AF8EE6", cterm_color = "140" },
        },
        ["log"] = {
            name = "Log",
            icon = "󱂅",
            light = { color = "#8CC7DB", cterm_color = "110" },
            dark = { color = "#5893B0", cterm_color = "73" },
        },
        ["lua"] = {
            name = "Lua",
            icon = "",
            color = "#499ED4",
            cterm_color = "74",
        },
        ["md"] = {
            name = "Md",
            icon = "",
            light = { color = "#3877E8", cterm_color = "68" },
            dark = { color = "#578CF0", cterm_color = "69" },
        },
        ["neon"] = {
            name = "PlainText",
            icon = "",
        },
        ["nix"] = {
            icon = "",
            light = { color = "#5A75BC", cterm_color = "67" },
            dark = { color = "#FFFFFF", cterm_color = "231" },
            name = "Nix",
        },
        ["php"] = {
            name = "Php",
            icon = "󰌟",
            light = { color = "#3F7CE9", cterm_color = "32" },
            dark = { color = "#5689E9", cterm_color = "69" },
        },
        ["plist"] = {
            name = "Xml",
            icon = "󰗀",
        },
        ["png"] = {
            name = "Image",
            icon = "",
            light = { color = "#3877E8", cterm_color = "32" },
            dark = { color = "#578CF0", cterm_color = "69" },
        },
        ["rar"] = {
            name = "Archive",
            icon = "󰿺",
        },
        ["sass"] = {
            name = "Sass",
            icon = "󰟬",
            -- same in both light and dark themes
            color = "#C46E98",
            cterm_color = "167",
        },
        ["scss"] = {
            name = "Sass",
            icon = "󰟬",
        },
        ["scpt"] = {
            name = "AppleScript",
            icon = "",
            color = "#666666",
            cterm_color = "71",
        },
        ["svg"] = {
            name = "Image",
            icon = "",
        },
        ["tex"] = {
            name = "Tex",
            icon = "󰰤",
            light = { color = "#628D4B", cterm_color = "65" },
            dark = { color = "#89B670", cterm_color = "107" },
        },
        ["toml"] = {
            name = "Toml",
            icon = "󰰤",
            light = { color = "#3877E8", cterm_color = "32" },
            dark = { color = "#578CF0", cterm_color = "69" },
        },
        ["ts"] = {
            name = "Ts",
            icon = "",
            light = { color = "#4573E8", cterm_color = "33" },
            dark = { color = "#6089EF", cterm_color = "69" },
        },
        ["ttf"] = {
            name = "Env",
            icon = "",
        },
        ["txt"] = {
            name = "PlainText",
            icon = "",
        },
        ["vue"] = {
            name = "Vue",
            icon = "",
            dark = { color = "#5CB487", cterm_color = "72" },
            light = { color = "#1A6B3F", cterm_color = "72" },
        },
        ["wgt"] = {
            name = "Archive",
            icon = "󰿺",
        },
        ["xml"] = {
            name = "Xml",
            icon = "󰗀",
            light = { color = "#D77433", cterm_color = "172" },
            dark = { color = "#BC805C", cterm_color = "137" },
        },
        ["xml.dist"] = {
            name = "Xml",
            icon = "󰗀",
        },
        ["yaml"] = {
            name = "Yaml",
            icon = "󰰳",
            light = { color = "#D04A4F", cterm_color = "167" },
            dark = { color = "#D1655F", cterm_color = "167" },
        },
        ["yml"] = {
            name = "Yaml",
            icon = "󰰳",
        },
        ["zip"] = {
            name = "Archive",
            icon = "󰿺",
            light = { color = "#437EE9", cterm_color = "32" },
            dark = { color = "#5587E6", cterm_color = "69" },
        },
    },
    by_filetype = {},
}

return M
