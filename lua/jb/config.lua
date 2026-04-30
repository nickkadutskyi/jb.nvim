local M = {}

---@alias EnforceFloatStyle {
---   style: vim.api.keyset.win_config,
---   condition?: fun(bufnr: integer, config: vim.api.keyset.win_config, win_id?: integer): (boolean),
---   after?: fun(win_id: integer, bufnr: integer, config: vim.api.keyset.win_config): (nil)
--- }

---@alias jb.DisabledPlugin
---| "MeanderingProgrammer/render-markdown.nvim"
---| "NeogitOrg/neogit"
---| "Saghen/blink.cmp"
---| "SmiteshP/nvim-navic"
---| "b0o/incline.nvim"
---| "dmtrKovalenko/fff.nvim"
---| "folke/lazy.nvim"
---| "folke/snacks.nvim.explorer"
---| "folke/snacks.nvim.notifier"
---| "folke/trouble.nvim"
---| "github/copilot.vim"
---| "hrsh7th/nvim-cmp"
---| "ibhagwan/fzf-lua"
---| "kevinhwang91/nvim-ufo"
---| "lewis6991/gitsigns.nvim"
---| "lukas-reineke/indent-blankline.nvim"
---| "nvim-telescope/telescope.nvim"
---| "nvim-treesitter/nvim-treesitter-context"
---| "petertriho/nvim-scrollbar"
---| "rcarriga/nvim-notify"
---| "sindrets/diffview.nvim"
---| "supermaven-inc/supermaven-nvim"
---| "vim-scripts/netrw.vim"
---| "yetone/avante.nvim"

---@class jb.Config
---@field enforce_float_style? EnforceFloatStyle[] Configuration to enforce float border styles
---@field disabled_plugins? jb.DisabledPlugin[] Plugin highlight sets to disable (without `Plugin.` prefix)
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
    -- Disable plugin highlight sets by plugin id, e.g. "nvim-telescope/telescope.nvim"
    disabled_plugins = {},
    -- Enable this to remove background from Normal and NormalNC
    transparent = false,
    -- Enable colorblind-friendly palette (light mode only)
    colorblind = false,
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
