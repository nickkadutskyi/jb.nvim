# 🎨 JB for Neovim

<p>Color scheme for Neovim, inspired by JetBrains IDEs.</p>

<table width="100%">
  <tr>
    <th>Dark</th>
    <th>Light</th>
  </tr>
  <tr>
    <td>
      <img src="" alt="Dark" />
    </td>
    <td>
      <img src="" alt="Light" />
    </td>
  </tr>
</table>

## Features

- Supports both light and dark themes
- Terminal colors.


<details>
<summary>Supported Languages</summary>

| Language | Treesitter | Semantic |
|----------|------------|----------|
| C/C++    | ✅         | ⚠️       |
| Lua      | ✅         | ✅       |

</details>


<details>
<summary>Supported Plugins</summary>

| Plugin                                                         | Source                                                                        |
|----------------------------------------------------------------|-------------------------------------------------------------------------------|
| [nvim-scrollbar](https://github.com/petertriho/nvim-scrollbar) | [`highlights["Plugin.petertriho/nvim-scrollbar"]`](lua/jb/palette.json#L1295) |

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
        vim.cmd("colorscheme jb")
    end,
}
```

### Usage

```lua
vim.cmd("colorscheme jb")
```

```vim
colorscheme jb
```

## Configuration

n/a

## Overriding Colors & Highlight Groups

n/a

## Extras

n/a

## Contributing

n/a
