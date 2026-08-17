#!/usr/bin/env -S PYTHONPATH=../../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0

"""Extract Xiaomi 13T Android 16 proprietary files into the fresh staging tree.

This module deliberately has no inherited/common module and no blob fixups.
Fixups may only be added after an Android 16 ELF/linker failure demonstrates
that they are necessary.
"""

from os import path

from extract_utils.fixups_lib import lib_fixups as lib_fixups_base
from extract_utils.main import ExtractUtils, ExtractUtilsModule
from extract_utils.tools import android_root


def lib_fixup_xiaomi_suffix(lib: str, partition: str, *args, **kwargs):
    """Disambiguate a Xiaomi C++ blob from an unrelated AOSP Rust crate."""
    return f"{lib}-xiaomi" if partition == "system_ext" else None


lib_fixups = {
    **lib_fixups_base,
    ("libsink",): lib_fixup_xiaomi_suffix,
}


module = ExtractUtilsModule(
    "aristotle",
    "xiaomi",
    # extract-utils is rooted at derp/, while this independent implementation
    # must remain one directory above it until validation is complete.
    device_rel_path="../fresh/device/xiaomi/aristotle",
    blob_fixups={},
    lib_fixups=lib_fixups,
    namespace_imports=[
        "hardware/mediatek",
        "hardware/xiaomi",
    ],
)

# Keep all generated output isolated from the historical/active vendor tree.
# Generate final-tree path references while physically staging output under
# fresh/. This makes the generated vendor tree relocatable without rewriting.
project_root = path.realpath(path.join(android_root, ".."))
module.vendor_rel_path = "vendor/xiaomi/aristotle"
module.vendor_path = path.join(project_root, "fresh/vendor/xiaomi/aristotle")
module.vendor_rro_path = path.join(module.vendor_path, "rro_overlays")


if __name__ == "__main__":
    ExtractUtils.device(module).run()
