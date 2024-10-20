# JB for Neovim

<p>Color scheme for Neovim, inspired by JetBrains IDEs.</p>

## Features

- Supports both light and dark themes

## Installation

### Lazy

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

<details>
<summary>Supported Plugins</summary>

<!-- plugins:start -->

| Plugin                                                 | Source                                                                  |
|--------------------------------------------------------|-------------------------------------------------------------------------|
| [nvim-scrollbar](https://github.com/petertriho/nvim-scrollbar) | [`highlights["Plugin.petertriho/nvim-scrollbar"]`](lua/jb/palette.json#L1295) |


</details>
