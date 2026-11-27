local M = {}

local palettes = {
    dark = {
        "#000000",
        "#F27481",
        "#6BCC62",
        "#E0CE70",
        "#5594FA",
        "#C092FA",
        "#47CCBD",
        "#CED0D6",
        "#4E5157",
        "#FF6B7A",
        "#67FF59",
        "#FFEC1A",
        "#3399FF",
        "#D970FF",
        "#40FFE9",
        "#FFFFFF",
    },
    light = {
        "#000000",
        "#C93645",
        "#357D1F",
        "#B2A400",
        "#225CD6",
        "#6E32E5",
        "#007A80",
        "#BEC0C5",
        "#6C707E",
        "#FF5462",
        "#3DCC3D",
        "#D4BB00",
        "#009DFF",
        "#D659FF",
        "#31C4B3",
        "#D2D4D9",
    },
}

function M.apply(background)
    for i, color in ipairs(palettes[background]) do
        vim.g["terminal_color_" .. (i - 1)] = color
    end
end

return M
