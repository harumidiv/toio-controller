#!/usr/bin/env python3
"""Bump MARKETING_VERSION / CURRENT_PROJECT_VERSION in project.pbxproj.

Usage: bump_version.py <pbxproj_path> [major|minor|patch]

- MARKETING_VERSION is bumped by the given component (default: patch).
  e.g. 4.2.11 -> patch: 4.2.12 / minor: 4.3.0 / major: 5.0.0
- Every numeric CURRENT_PROJECT_VERSION is incremented by 1.
  Per-target gaps between targets are preserved (all values move together).
"""
import re
import sys

BUMPS = ("major", "minor", "patch")


def bump_version(current: str, kind: str) -> str:
    parts = [int(p) for p in current.split(".")]
    while len(parts) < 3:
        parts.append(0)
    major, minor, patch = parts[0], parts[1], parts[2]
    if kind == "major":
        return f"{major + 1}.0.0"
    if kind == "minor":
        return f"{major}.{minor + 1}.0"
    return f"{major}.{minor}.{patch + 1}"


def main() -> int:
    if len(sys.argv) < 2:
        print("usage: bump_version.py <pbxproj_path> [major|minor|patch]")
        return 2
    path = sys.argv[1]
    kind = sys.argv[2] if len(sys.argv) > 2 else "patch"
    if kind not in BUMPS:
        print(f"ERROR: bump type must be one of {BUMPS}, got: {kind}")
        return 2

    with open(path, encoding="utf-8") as f:
        text = f.read()

    marketing = re.findall(r"MARKETING_VERSION = ([^;]+);", text)
    if not marketing:
        print("ERROR: no MARKETING_VERSION found")
        return 1
    distinct = sorted(set(marketing))
    if len(distinct) != 1:
        print(f"ERROR: MARKETING_VERSION values differ across targets: {distinct}")
        return 1
    current = distinct[0]
    if not re.fullmatch(r"[0-9]+(\.[0-9]+)*", current):
        print(f"ERROR: MARKETING_VERSION is not numeric: {current}")
        return 1
    new_version = bump_version(current, kind)
    text, n = re.subn(
        r"MARKETING_VERSION = [^;]+;",
        f"MARKETING_VERSION = {new_version};",
        text,
    )
    print(f"MARKETING_VERSION {current} -> {new_version} ({kind} bump, {n} entries)")

    bumped = []

    def bump(match):
        value = match.group(1)
        if value.isdigit():
            bumped.append(value)
            return f"CURRENT_PROJECT_VERSION = {int(value) + 1};"
        print(f"WARNING: skipped non-numeric CURRENT_PROJECT_VERSION: {value}")
        return match.group(0)

    text = re.sub(r"CURRENT_PROJECT_VERSION = ([^;]+);", bump, text)
    if not bumped:
        print("ERROR: no numeric CURRENT_PROJECT_VERSION found")
        return 1
    print(
        "CURRENT_PROJECT_VERSION +1: "
        f"{len(bumped)} entries ({', '.join(sorted(set(bumped)))} -> +1)"
    )

    with open(path, "w", encoding="utf-8") as f:
        f.write(text)
    print(f"NEW_VERSION={new_version}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
