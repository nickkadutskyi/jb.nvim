-- Provides icons similar to the ones used in JetBrains IDEs
-- Source: https://intellij-icons.jetbrains.design/

local M = {}

M.icons = {
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
    EnumMember = "󰯱",
    Struct = "󰰡",

    Function = "󰯼",
    Variable = "󰰬",
    Constant = "󰯱",

    Text = "",
    Value = "󰰪",

    -- No icon for builtin keywords
    Keyword = "",

    -- JB template
    Snippet = "󰴹",

    Unit = "",
    Operator = "󱖦",

    Color = "",
    Reference = "󰬳",
    Event = "󱐋",
    TypeParameter = "󰰦",

    String = "󰯫",
    Number = "󰽾",
    Boolean = "",
    -- TODO: Reconsider theses icons
    Array = "",
    Object = "",
    Null = "󰟢",
}

return M
