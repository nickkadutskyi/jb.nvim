local M = {}

---@class jb.Config
M.defaults = {
    -- Enable this to disable setting the background color
    transparent = false,
}

---@type jb.Config
M.options = nil

---@param options? jb.Config
function M.setup(options)
    M.options = vim.tbl_deep_extend("force", {}, M.defaults, options or {})
end

return M
