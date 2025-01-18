To install these themes in Alacritty you can use import directive like this:

```toml
[general]
import = ["~/projects/jb.nvim/extras/alacritty/jb-dark.toml"]
```
Unfortunately Alacritty doesn't provide a config to make it switch themes or configs
based on the current system theme but there are workarounds. E.g. you can
import a symlink and change that symlink based on the current system theme.

This is what I do:

```toml
[general]
import = [
    "/nix/store/9vid34k7zky0qgqi6wlq2c0kma8i2pqr-light.toml",
    "~/.config/alacritty/alacritty_theme.toml"
]
```
First import is my default theme in case alacritty_theme.toml is missing
for any reason. Then I import alacritty_theme.toml which is a symlink to
a current theme file which will override the default one.

On macOS I use [dark-mode-notify](https://github.com/bouk/dark-mode-notify) to
automatically run a script that switches the symlink to the appropriate theme file.
E.g. here is [my nix home-manager config](https://github.com/nickkadutskyi/nixos-config/blob/main/users/nick/services/home-alacritty-theme.nix)
for dark-mode-notify LaunchAgent

See also:
- [`import` option reference](https://alacritty.org/config-alacritty.html#s1)
