#!/usr/bin/env python3

import argparse

import semver
import tomlkit

parser = argparse.ArgumentParser("bump", description="Bump version in pyproject.toml")
parser.add_argument("package", choices=["lib", "client"], help="Choose which package to bump")
parser.add_argument("--major", action="store_true", help="Bump major version")
parser.add_argument("--minor", action="store_true", help="Bump minor version")
parser.add_argument("--patch", action="store_true", help="Bump patch version")

def main():
    args = parser.parse_args()

    if [args.major, args.minor, args.patch].count(True) != 1:
        parser.error("One (and only one) of major, minor, patch must be selected")

    pyproject_file = f"{args.package}/pyproject.toml"
    with open(pyproject_file) as f:
        pyproject = tomlkit.parse(f.read())

    ver = semver.Version.parse(pyproject["project"]["version"])
    if args.major:
        ver = ver.bump_major()
    elif args.minor:
        ver = ver.bump_minor()
    else:
        ver = ver.bump_patch()

    pyproject["project"]["version"] = str(ver)

    with open(pyproject_file, "w") as f:
        tomlkit.dump(pyproject, f)

if __name__ == "__main__":
    main()