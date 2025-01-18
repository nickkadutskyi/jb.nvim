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

If you don't want to add theme files into Ghostty config directory you can set
`theme` option to an absolute path to the theme file:

```ini
theme = "/home/nick/projects/jb.nvim/extras/ghostty/jb-dark"
```

See also:
- [`theme` option reference](https://ghostty.org/docs/config/reference#theme)
- [`window-theme` option reference](https://ghostty.org/docs/config/reference#window-theme)

