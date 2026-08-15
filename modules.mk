# Android 16 Xiaomi/MediaTek modules extracted from OS3.0.5.0.WMFMIXM.
#
# GKI modules, including the V8 dummy rust_binder.ko, are produced by Kleaf and
# are intentionally not listed here. depmod metadata is regenerated against the
# source-built V8 kernel; stock modules.load ordering remains authoritative.

ARISTOTLE_MODULES_PATH := device/xiaomi/aristotle/prebuilt/modules

BOARD_VENDOR_RAMDISK_KERNEL_MODULES := \
    $(wildcard $(ARISTOTLE_MODULES_PATH)/vendor_ramdisk/*.ko)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD := \
    $(strip $(shell cat $(ARISTOTLE_MODULES_PATH)/vendor_ramdisk/modules.load))
BOARD_VENDOR_RAMDISK_RECOVERY_KERNEL_MODULES_LOAD := \
    $(strip $(shell cat $(ARISTOTLE_MODULES_PATH)/vendor_ramdisk/modules.load.recovery))
BOARD_DO_NOT_STRIP_VENDOR_RAMDISK_MODULES := true

BOARD_VENDOR_KERNEL_MODULES := \
    $(wildcard $(ARISTOTLE_MODULES_PATH)/vendor_dlkm/*.ko)
BOARD_VENDOR_KERNEL_MODULES_LOAD := \
    $(strip $(shell cat $(ARISTOTLE_MODULES_PATH)/vendor_dlkm/modules.load))
BOARD_DO_NOT_STRIP_VENDOR_MODULES := true

# Stock Android 16 has an empty odm_dlkm. Keep the image present but do not
# invent module payloads for it.
BOARD_ODM_KERNEL_MODULES :=
