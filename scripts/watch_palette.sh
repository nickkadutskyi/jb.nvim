#!/usr/bin/env bash

set -u

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
highlights="$repo_root/lua/jb/highlights.json"
intellij_palette="$repo_root/lua/jb/intellij-palette.json"
generator="$repo_root/scripts/generate_palette_compiled.lua"

signature() {
    cksum "$highlights" "$intellij_palette" 2>/dev/null
}

generate() {
    nvim --headless -u NONE --noplugin \
        "+set runtimepath^=$repo_root" \
        "+lua dofile(\"$generator\")" \
        +qa
}

previous_signature="$(signature)"
printf '\nWatching %s and %s' "$highlights" "$intellij_palette"

while sleep 1; do
    current_signature="$(signature)"
    if [[ "$current_signature" == "$previous_signature" ]]; then
        continue
    fi

    previous_signature="$current_signature"
    printf '\nPalette input changed; regenerating palette_compiled.lua...'
    if ! generate; then
        printf '\nGeneration failed; continuing to watch.' >&2
    fi
done
