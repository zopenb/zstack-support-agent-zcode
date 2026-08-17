from __future__ import annotations

import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


PLUGIN_ROOT = Path(__file__).resolve().parents[1]
VALIDATOR = PLUGIN_ROOT / "scripts" / "validate-python-dependencies.py"
PACKAGES = {
    "python-docx": ("python_docx", "docx", "1.2.0"),
    "lxml": ("lxml", "lxml", "6.0.2"),
    "typing-extensions": ("typing_extensions", "typing_extensions", "4.16.0"),
}


def write_fixture(module_root: Path, metadata_root: Path) -> None:
    (module_root / "docx").mkdir(parents=True)
    (module_root / "docx" / "__init__.py").write_text("", encoding="ascii")
    (module_root / "lxml").mkdir(parents=True)
    (module_root / "lxml" / "__init__.py").write_text("", encoding="ascii")
    (module_root / "typing_extensions.py").write_text("", encoding="ascii")

    metadata_root.mkdir(parents=True, exist_ok=True)
    for project_name, (directory_name, _module_name, version) in PACKAGES.items():
        dist_info = metadata_root / f"{directory_name}-{version}.dist-info"
        dist_info.mkdir()
        metadata = dist_info / "METADATA"
        metadata.write_text(
            f"Metadata-Version: 2.1\nName: {project_name}\nVersion: {version}\n",
            encoding="ascii",
        )
        (dist_info / "RECORD").write_text(
            f"{dist_info.name}/METADATA,,\n{dist_info.name}/RECORD,,\n",
            encoding="ascii",
        )


def run_validator(module_root: Path, metadata_root: Path, approved_root: Path) -> subprocess.CompletedProcess[str]:
    environment = os.environ.copy()
    environment["PYTHONPATH"] = os.pathsep.join((str(module_root), str(metadata_root)))
    return subprocess.run(
        [sys.executable, "-S", str(VALIDATOR), "--target", str(approved_root)],
        text=True,
        capture_output=True,
        env=environment,
        check=False,
    )


class DependencyValidatorTests(unittest.TestCase):
    def test_accepts_modules_and_metadata_from_private_target(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            private = Path(temporary) / "private"
            write_fixture(private, private)
            result = run_validator(private, private, private)
        self.assertEqual(result.returncode, 0, result.stderr)

    def test_rejects_global_metadata_masquerading_as_private_install(self) -> None:
        with tempfile.TemporaryDirectory() as temporary:
            root = Path(temporary)
            private = root / "private"
            global_metadata = root / "global"
            write_fixture(private, global_metadata)
            result = run_validator(private, global_metadata, private)
        self.assertEqual(result.returncode, 2)
        self.assertIn("metadata was not loaded from a private target", result.stderr)


if __name__ == "__main__":
    unittest.main()
