local M = {}

---@alias EnforceFloatStyle {
---  style: vim.api.keyset.win_config,
---  condition?: fun(bufnr: integer, enter: boolean, config: vim.api.keyset.win_config): boolean
---}

---@class jb.Config
---@field enforce_float_style? EnforceFloatStyle[] Configuration to enforce float border styles
M.defaults = {
    -- Disable bold or italic for all highlights
    disable_hl_args = {
        bold = false,
        italic = false,
    },
    snacks = {
        explorer = {
            -- Enable folke/snacks.nvim styling for explorer
            enabled = true,
        },
    },
    telescope = {
        -- Enable telescope.nvim styling
        enabled = true,
    },
    -- Enable this to remove background from Normal and NormalNC
    transparent = false,
    enforce_float_style = nil,
}

---@type jb.Config
M.options = nil

---@param options? jb.Config
function M.setup(options)
    M.options = vim.tbl_deep_extend("force", {}, M.defaults, options or {})
end

---@param opts? jb.Config
function M.extend(opts)
    return opts and vim.tbl_deep_extend("force", {}, M.options, opts) or M.options
end

setmetatable(M, {
    __index = function(_, k)
        if k == "options" then
            return M.defaults
        end
    end,
})

return M
