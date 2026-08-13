#!/usr/bin/env python3
"""Compare General and LanguageDefaults across IntelliJ palette scopes."""

import argparse
import json
from pathlib import Path
from typing import Any


MISSING = object()
SECTIONS = ("General", "LanguageDefaults")
BASELINE_SCOPE = "IntelliJ"


def flatten(value: Any, path: tuple[str, ...] = ()) -> dict[tuple[str, ...], Any]:
    if isinstance(value, dict) and value:
        result = {}
        for key, child in value.items():
            result.update(flatten(child, path + (key,)))
        return result
    return {path: value}


def format_value(value: Any) -> str:
    if value is MISSING:
        return "<missing>"
    return json.dumps(value, sort_keys=True, separators=(",", ":"))


def compare_section(scopes: dict[str, Any], section: str) -> int:
    present = {name: flatten(scope[section]) for name, scope in scopes.items() if section in scope}
    missing_scopes = [name for name in scopes if name not in present]

    if BASELINE_SCOPE not in present:
        raise ValueError(f"{BASELINE_SCOPE} does not contain {section}")

    print(section)
    print("=" * len(section))
    print("Present: " + (", ".join(present) or "none"))
    print("Missing: " + (", ".join(missing_scopes) or "none"))

    paths = sorted({path for values in present.values() for path in values})
    differences = 0
    for path in paths:
        baseline_value = present[BASELINE_SCOPE].get(path, MISSING)
        differing_values = {
            name: leaves.get(path, MISSING)
            for name, leaves in present.items()
            if name != BASELINE_SCOPE and leaves.get(path, MISSING) != baseline_value
        }
        if not differing_values:
            continue

        differences += 1
        print("\n" + "|".join(path))
        print(f"  {BASELINE_SCOPE}: {format_value(baseline_value)}")
        for name, value in differing_values.items():
            print(f"  {name}: {format_value(value)}")

    print(f"\n{differences} differing path(s)\n")
    return differences


def main() -> int:
    default_palette = Path(__file__).resolve().parents[1] / "lua/jb/intellij-palette.json"
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("palette", nargs="?", type=Path, default=default_palette)
    parser.add_argument(
        "--section",
        action="append",
        choices=SECTIONS,
        help="section to compare; may be supplied more than once (default: both)",
    )
    args = parser.parse_args()

    try:
        with args.palette.open(encoding="utf-8") as palette_file:
            scopes = json.load(palette_file)
    except (OSError, json.JSONDecodeError) as error:
        parser.error(str(error))

    if not isinstance(scopes, dict):
        parser.error("the palette root must be a JSON object")

    try:
        for section in args.section or SECTIONS:
            compare_section(scopes, section)
    except ValueError as error:
        parser.error(str(error))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
