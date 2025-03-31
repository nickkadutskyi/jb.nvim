local M = {}

---@class jb.Config
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
    -- Enable this to remove background from Normal and NormalNC
    transparent = false,
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
