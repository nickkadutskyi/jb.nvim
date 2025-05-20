-- Provides icons similar to the ones used in JetBrains IDEs
-- Source: https://intellij-icons.jetbrains.design/

local M = {}

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

return M
