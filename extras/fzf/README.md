To install these themes in fzf you can point `FZF_DEFAULT_OPTS_FILE`
to one of the theme files:

```bash
export FZF_DEFAULT_OPTS_FILE=~/projets/jb.nvim/extras/fzf/jb-dark.fzfrc
```
If want to use light and dark theme depending on the current system theme you can
point `FZF_DEFAULT_OPTS_FILE` to a symlink to the appropriate theme file:

```bash
ln -s ~/projets/jb.nvim/extras/fzf/jb-dark.fzfrc ~/.config/fzf/fzfrc
export FZF_DEFAULT_OPTS_FILE=~/.config/fzf/fzfrc
```
Then you can have a separate script that will switch the symlink
to the appropriate theme file when system theme changes.

See also:
- [FZF Environment Variables](https://github.com/junegunn/fzf#environment-variables)
