#!/usr/bin/env python3
"""Verify pinned report dependencies are fully loaded from private targets."""

from __future__ import annotations

import argparse
from importlib import import_module
from importlib.metadata import PackageNotFoundError, distribution
from pathlib import Path
import sys


EXPECTED = {
    "python-docx": ("docx", "1.2.0"),
    "lxml": ("lxml", "6.0.2"),
    "typing-extensions": ("typing_extensions", "4.16.0"),
}


def is_within(path: Path, roots: tuple[Path, ...]) -> bool:
    resolved = path.resolve()
    return any(resolved == root or resolved.is_relative_to(root) for root in roots)


def metadata_path(distribution_name: str) -> Path:
    package = distribution(distribution_name)
    files = package.files
    if files is None:
        raise ValueError(f"{distribution_name} has no installed-file metadata")
    metadata_files = [
        Path(package.locate_file(item))
        for item in files
        if item.name == "METADATA" and any(part.casefold().endswith(".dist-info") for part in item.parts)
    ]
    if len(metadata_files) != 1:
        raise ValueError(
            f"{distribution_name} must expose exactly one .dist-info/METADATA file; "
            f"found {len(metadata_files)}"
        )
    return metadata_files[0]


def validate(targets: list[str]) -> list[str]:
    roots = tuple(Path(target).expanduser().resolve(strict=True) for target in targets)
    if not roots:
        raise ValueError("at least one private dependency target is required")

    results: list[str] = []
    for distribution_name, (module_name, expected_version) in EXPECTED.items():
        module = import_module(module_name)
        module_file = getattr(module, "__file__", None)
        if not module_file or not is_within(Path(module_file), roots):
            raise ValueError(f"{distribution_name} module was not loaded from a private target: {module_file}")

        package = distribution(distribution_name)
        if package.version != expected_version:
            raise ValueError(
                f"{distribution_name} version must be {expected_version}, found {package.version}"
            )
        package_metadata = metadata_path(distribution_name)
        if not is_within(package_metadata, roots):
            raise ValueError(
                f"{distribution_name} metadata was not loaded from a private target: {package_metadata}"
            )
        results.append(f"{distribution_name}=={package.version}")
    return results


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--target", action="append", required=True, help="Approved private dependency directory.")
    args = parser.parse_args(argv)
    try:
        results = validate(args.target)
    except (ImportError, PackageNotFoundError, OSError, ValueError) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        return 2
    print(", ".join(results))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
