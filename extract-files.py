#!/usr/bin/env -S PYTHONPATH=../../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: 2026 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0

"""Extract Xiaomi 13T Android 16 proprietary files."""

from extract_utils.fixups_blob import blob_fixup
from extract_utils.fixups_lib import lib_fixups as lib_fixups_base
from extract_utils.main import ExtractUtils, ExtractUtilsModule


def lib_fixup_xiaomi_suffix(lib: str, partition: str, *args, **kwargs):
    """Disambiguate a Xiaomi C++ blob from an unrelated AOSP Rust crate."""
    return f"{lib}-xiaomi" if partition == "system_ext" else None


def lib_fixup_graphics_common_v6_dependency(
    lib: str, partition: str, *args, **kwargs
):
    """Keep the stock V6 ELF as runtime-only while Soong consumers use V7."""
    return "android.hardware.graphics.common-V7-ndk"


lib_fixups = {
    **lib_fixups_base,
    (
        "android.hardware.graphics.common-V6-ndk",
    ): lib_fixup_graphics_common_v6_dependency,
    ("libsink",): lib_fixup_xiaomi_suffix,
}


blob_fixups = {
    (
        "vendor/bin/hw/mt6895/android.hardware.graphics.allocator-V2-service-mediatek.mt6895",
        "vendor/lib64/hw/mt6895/android.hardware.graphics.allocator-V2-mediatek.so",
        "vendor/lib64/hw/mt6895/mapper.mediatek.so",
    ): blob_fixup().replace_needed(
        "android.hardware.graphics.common-V6-ndk.so",
        "android.hardware.graphics.common-V7-ndk.so",
    ),
}


module = ExtractUtilsModule(
    "aristotle",
    "xiaomi",
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=[
        "hardware/mediatek",
        "hardware/xiaomi",
    ],
)


if __name__ == "__main__":
    ExtractUtils.device(module).run()
