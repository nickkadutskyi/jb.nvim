# JB Palette Exporter

Private IntelliJ-platform plugin that snapshots the active editor color scheme into `lua/jb/intellij-palette.json`. Hand-maintained Neovim colors remain in that file's `Neovim` scope, while highlight mappings live in `lua/jb/highlights.json`.

The plugin discovers colors from every language plugin loaded in the IDE. It has no compile-time dependencies on those plugins. Install the same plugin in IntelliJ, CLion, Rider, and other JetBrains IDEs.

## Build and install

From this directory:

```sh
./gradlew buildPlugin
```

To compile against the installed IntelliJ IDEA 2026.2 instead of downloading it:

```sh
./gradlew -PlocalPlatform="/Users/nick/Applications/IntelliJ IDEA.app" buildPlugin
```

Install the zip from `build/distributions/` with **Settings | Plugins | Install Plugin from Disk…**, then restart the IDE.

## Export workflow

Always export IntelliJ first. Each run overlays only the detected profile.

1. In **IntelliJ IDEA**, select **Islands Light** and run **Tools | Export Active Color Scheme Palette** (also available in Find Action).
2. Select **Islands Dark** and export to the same file.
3. Enable red-green adjustment and export Islands Light again (`light_cb`).
4. Keep red-green adjustment enabled, switch to Islands Dark, and export again (`dark_cb`).
5. Repeat those four passes in CLion, Rider, and any other IDE, always targeting the same file.

Profiles are detected from the scheme background (`light` or `dark`) plus `UISettings.colorBlindness` (`_cb` when set).

The default file name is `intellij-palette.json`. Choose the same path on later runs.

## Product routing

Color groups are scoped per IDE at the document root: `IntelliJ`, `Rider`, and so on.

- An IntelliJ export always overlays `IntelliJ`.
- Another IDE compares its `LanguageDefaults` group for the current profile to IntelliJ.
- If it matches, the exporter performs an add-only merge into `IntelliJ`. Missing languages such as C# are added and existing IntelliJ leaves are never overwritten.
- If it differs, only top-level color groups missing from IntelliJ are written under the current product. Shared groups such as `AngularTemplate` and `BashSupportPro` are ignored.
- References from a retained group are followed transitively. Any referenced group is included under the current product even if that dependency also exists in IntelliJ. This keeps product-specific inheritance relative to the product tree.
- If IntelliJ has no `LanguageDefaults` baseline, the snapshot is written under the current product and the notification tells you to export IntelliJ first.

A previous file with a `colors` wrapper or unscoped groups (`General`, `LanguageDefaults`, …) is flattened and wrapped under `IntelliJ` on the next export. Existing product trees such as `Rider` stay at the top level.

## Output shape

```json
{
  "IntelliJ": {
    "General": {
      "Text": {
        "DefaultText": {
          "light": {
            "fg": "#080808",
            "bg": "#FFFFFE"
          }
        }
      }
    },
    "LanguageDefaults": {
      "Keyword": {
        "light": {
          "fg": "#0033B3"
        }
      }
    }
  }
}
```

Inheritance references stay relative to the product tree, such as `LanguageDefaults|Keyword`.

Attribute values use the jb.nvim vocabulary: `fg`, `bg`, `sp`, `bold`, `italic`, `underline`, `undercurl`, `underdouble`, `underdotted`, `underdashed`, and `strikethrough`. Error-stripe colors are written under `ErrorStripeMark`. Inherited attributes become palette path references when the fallback descriptor is known. Empty attributes become `{}`. Missing providers are omitted, not written as empty values.

## Merge policy

Each export is a non-destructive leaf-level overlay:

- Preserve every existing root field that is not part of the current overlay.
- Overlay only descriptor paths returned by the current IDE, into the routed product tree.
- Update only the detected profile, such as `light_cb`.
- Preserve the other profiles at that descriptor.
- Preserve nested descriptors that the IDE did not return, even when siblings were exported.
- If a provider or descriptor throws, skip it and keep its existing JSON.
- Never delete fields automatically. Stale entries need manual cleanup.

Example: exporting `PHP|Keywords` from IntelliJ updates `IntelliJ|PHP|Keywords|light` and leaves `IntelliJ|PHP|DQLBuilder` unchanged.

## Updating the Neovim palette

Export directly to `lua/jb/intellij-palette.json`. Keep the hand-maintained
`Other` scope when updating the generated IDE scopes. Highlight mappings live
in `lua/jb/highlights.json`. After either file changes, regenerate the compiled
palette:

```sh
nvim --headless -u NONE --noplugin \
  +'set runtimepath^=/absolute/path/to/jb.nvim' \
  +'lua dofile("/absolute/path/to/jb.nvim/scripts/generate_palette_compiled.lua")' \
  +qa
```
