# 🎨 JB for Neovim

<p>Color scheme for Neovim, inspired by JetBrains IDEs.</p>

<table width="100%">
  <tr>
    <th>Dark</th>
    <th>Light</th>
  </tr>
  <tr>
    <td>
        <img width="512" alt="dark-js" src="https://github.com/user-attachments/assets/dcff0247-868e-4aa4-bac1-22729099fb46" />
    </td>
    <td>
        <img width="512" alt="light-js" src="https://github.com/user-attachments/assets/89863d62-5c69-45f3-b21e-9e8c17cc3281" />
    </td>
  </tr>
</table>

## Features

- Supports both light and dark themes, with a colorblind-friendly palette for light mode
- Terminal colors
- Lualine theme included
- Lualine component for a Navigation Bar similar to JetBrains IDEs but only for dir path part
- Generates `ProjectColor` highlight group based on the path
- Generates highlights for icons `JBIcon<Kind>`
- Provides a table with icons visually similar to JB's ones

<details>
<summary>Supported Languages</summary>

| Language      | Syntax | Treesitter                     | Semantic     |
|---------------|--------|--------------------------------|--------------|
| .ignore Files | n/a    | ✅ (gitignore)                 | n/a          |
| ApacheConfig  | ✅     | n/a                            | n/a          |
| BibTeX        | ⚠️     | ✅ (bibtex)                    | n/a          |
| Blade         | n/a    | ✅ (EmranMR/tree-sitter-blade) | n/a          |
| C/C++         | ⚠️     | ✅ (c,cpp)                     | n/a          |
| CSS           | ⚠️     | ✅ (css)                       | n/a          |
| EditorConfig  | n/a    | ✅ (editorconfig)              | n/a          |
| Go            | ⚠️     | ✅ (go)                        | ✅ (gopls)   |
| Go Template   | ⚠️     | ✅ (gotmpl)                    | n/a          |
| GraphQL       | ⚠️     | ✅ (graphql)                   | n/a          |
| HTML          | ⚠️     | ✅ (html)                      | n/a          |
| Ini           | ⚠️     | ✅ (ini)                       | n/a          |
| Java          | ⚠️     | ✅ (java, javadoc)             | ✅ (jdtls)   |
| JavaScript    | ⚠️     | ✅ (javascript)                | ✅ (ts_ls)   |
| JSON          | ✅     | ✅ (json)                      | n/a          |
| LaTeX         | ⚠️     | ✅ (latex)                     | n/a          |
| Lua           | ⚠️     | ✅ (lua,luadoc)                | ✅ (lua_ls)  |
| Markdown      | ⚠️     | ✅ (markdown,markdown_inline)  | n/a          |
| Nix           | ⚠️     | ✅ (nix)                       | ✅ (nil_lsp) |
| PHP           | ⚠️     | ✅ (php,phpdoc)                | n/a          |
| Python        | ⚠️     | ✅ (python)                    | n/a          |
| RegExp        | ⚠️     | ✅ (regex)                     | n/a          |
| Ruby          | ⚠️     | ✅ (ruby)                      | ✅ (ruby_lsp)|
| Rust          | ⚠️     | ✅ (rust)                      | n/a          |
| Sass/SCSS     | ⚠️     | ✅ (scss)                      | n/a          |
| Scala         | ⚠️     | ✅ (scala)                     | n/a          |
| Shell Script  | ⚠️     | ✅ (bash)                      | n/a          |
| TOML          | ⚠️     | ✅ (toml)                      | n/a          |
| Twig          | n/a    | ✅ (twig)                      | n/a          |
| TypeScript    | ⚠️     | ✅ (typescript)                | ✅ (ts_ls)   |
| TSX/JSX       | ⚠️     | ✅ (tsx)                       | ✅ (ts_ls)   |
| XML           | ⚠️     | ✅ (xml)                       | n/a          |
| YAML          | ⚠️     | ✅ (yaml)                      | n/a          |
| Zig           | ⚠️     | ✅ (zig)                       | ✅ (zls)     |

</details>


<details>
<summary>Supported Plugins</summary>

| Plugin                                                                            | Source |
|-----------------------------------------------------------------------------------|--------|
| [avante.nvim](https://github.com/yetone/avante.nvim)                              | n/a    |
| [blink.cmp](https://github.com/Saghen/blink.cmp)                                  | n/a    |
| [copilot.vim](https://github.com/github/copilot.vim)                              | n/a    |
| [diffvie.nvim](https://github.com/sindrets/diffview.nvim)                         | n/a    |
| [fzf-lua](https://github.com/ibhagwan/fzf-lua)                                    | n/a    |
| [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)                       | n/a    |
| [indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim)   | n/a    |
| [neogit](https://github.com/NeogitOrg/neogit)                                     | n/a    |
| [netrw.vim](https://github.com/vim-scripts/netrw.vim)                             | n/a    |
| [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)                                   | n/a    |
| [nvim-notify](https://github.com/rcarriga/nvim-notify)                            | n/a    |
| [nvim-scrollbar](https://github.com/petertriho/nvim-scrollbar)                    | n/a    |
| [snacks.nvim](https://github.com/folke/snack.nvim)                                | n/a    |
| [supermaven-nvim](https://github.com/supermaven-inc/supermaven-nvim)              | n/a    |
| [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)                | n/a    |
| [trouble.nvim](https://github.com/folke/trouble.nvim)                             | n/a    |

</details>

## Installation

Install the theme with your preferred package manager, such as
[folke/lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
return {
    "nickkadutskyi/jb.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
        -- require("jb").setup({transparent = true})
        vim.cmd("colorscheme jb")
    end,
}
```
### Plugin Notes

#### hrsh7th/nvim-cmp

If you use `custom` view for entries (opts>view>entries>name) cmp creates
a custom window instead of native built-in popup. To improve the view you
can link highlight groups like this:

```lua
window = {
    completion = cmp.config.window.bordered({
        winhighlight = "Normal:Pmenu,FloatBorder:DialogFloatBorder,CursorLine:PmenuSel,Search:None",
    }),
    documentation = cmp.config.window.bordered({
        winhighlight = "Normal:Pmenu,FloatBorder:DialogFloatBorder,CursorLine:PmenuSel,Search:None",
    }),
},
```
You can have any config just make sure `Normal:Pmenu` and
`CursorLine:PmenuSel` is present in `winhighlight`.

### Usage

```lua
vim.cmd("colorscheme jb")
```

```vim
colorscheme jb
```

Change light/dark theme:

```lua
vim.o.background = "light"
```

```vim
set background=light
```

## Configuration

> [!IMPORTANT]
> Set the configuration **BEFORE** loading the color scheme `colorscheme jb`.

<details>
  <summary>Default Options</summary>

<!-- config:start -->

```lua
---@class jb.Config
M.defaults = {
    -- Disable bold or italic for all highlights
    disable_hl_args = {
        bold = false,
        italic = false,
    },
    -- Control snacks.nvim related styles
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
    -- Type: jb.DisabledPlugin[]
    -- Disable plugin highlight sets by plugin id, e.g. "nvim-telescope/telescope.nvim"
    disabled_plugins = {},
    -- Enable this to remove background from Normal and NormalNC
    transparent = false,
    -- Enable colorblind-friendly palette (light mode only)
    -- Replaces green/purple/teal tokens with blue and near-black alternatives
    colorblind = false,
}
```

<!-- config:end -->

</details>

## Overriding Colors & Highlight Groups

n/a

## Extras

Extra color configs for [Kitty](https://sw.kovidgoyal.net/kitty/conf.html),
[Alacritty](https://github.com/alacritty/alacritty),
[Ghostty](https://ghostty.org/) can be found in [extras](extras/).
To use them, refer to their respective documentation.

## Development

When changing `lua/jb/palette.json`, regenerate the compiled palette used at runtime:

```sh
nvim --headless -u NONE --noplugin \
  +'set runtimepath^=/absolute/path/to/jb.nvim' \
  +'lua dofile("/absolute/path/to/jb.nvim/scripts/generate_palette_compiled.lua")' \
  +qa
```

## Contributing

n/a
