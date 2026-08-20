To install these themes in Ghostty you can put (move or link) `jb-dark` and `jb-light`
into Ghostty config directory under `themes` subdirectory `$XDG_CONFIG_DIR/ghostty/themes`
or `~/.config/ghostty/themes` and set the `theme` config like this:

```ini
theme = light:jb-light,dark:jb-dark
```

To have Ghostty switch themes automatically set `window-theme` option to `auto` or `system`

If you use only one theme just set it like this:

```ini
theme = jb-dark
```

To match Ghostty's background to the statusbar while Neovim is open, enable the
color scheme integration before loading it:

```lua
require("jb").setup({
    integrations = {
        ghostty = true,
    },
})
vim.cmd("colorscheme jb")
```

The integration restores Ghostty's configured background when Neovim exits.

> [!NOTE]
> The integration sets a fixed Ghostty background using OSC 11. While this
> override is active, Ghostty cannot notify Neovim when the system appearance
> changes, so Neovim's `background` option will no longer switch automatically
> based on Ghostty's background. Use
> [f-person/auto-dark-mode.nvim](https://github.com/f-person/auto-dark-mode.nvim)
> together with this integration to synchronize `vim.o.background` directly
> with the system theme.

If you don't want to add theme files into Ghostty config directory you can set
`theme` option to an absolute path to the theme file:

```ini
theme = "/home/nick/projects/jb.nvim/extras/ghostty/jb-dark"
```

See also:
- [`theme` option reference](https://ghostty.org/docs/config/reference#theme)
- [`window-theme` option reference](https://ghostty.org/docs/config/reference#window-theme)
