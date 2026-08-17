LOCAL_PATH := device/xiaomi/aristotle

# The V8 tree is consumed exclusively by Kleaf/Bazel.  Do not let Android Make
# discover KernelSU userspace Android.mk files inside the kernel source.
PRODUCT_SOURCE_ROOT_DIRS += -kernel/xiaomi

PRODUCT_SHIPPING_API_LEVEL := 33
PRODUCT_ENFORCE_VINTF_MANIFEST := true
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION := false
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/mediatek \
    hardware/mediatek/libmtkperf_client \
    hardware/xiaomi \
    vendor/xiaomi/aristotle

PRODUCT_SYSTEM_PARTITIONS_FILE_SYSTEM_TYPE := erofs

PRODUCT_PACKAGES += \
    update_engine \
    update_engine_sideload \
    update_verifier \
    checkpoint_gc \
    otapreopt_script \
    fastbootd \
    android.hardware.fastboot@1.1-impl.custom \
    create_pl_dev.recovery \
    android.hardware.boot-service.default_recovery \
    android.hardware.health-service.mediatek-recovery

AB_OTA_POSTINSTALL_CONFIG += \
    RUN_POSTINSTALL_system=true \
    POSTINSTALL_PATH_system=system/bin/otapreopt_script \
    FILESYSTEM_TYPE_system=erofs \
    POSTINSTALL_OPTIONAL_system=true \
    RUN_POSTINSTALL_vendor=true \
    POSTINSTALL_PATH_vendor=bin/checkpoint_gc \
    FILESYSTEM_TYPE_vendor=erofs \
    POSTINSTALL_OPTIONAL_vendor=true

# Stock Android 16 ships AIDL Audio Core/Effect v3 as proprietary services.
# Do not add the obsolete compatibility HIDL audio service here.
PRODUCT_PACKAGES += \
    audio.bluetooth.default \
    audio.usb.default \
    android.hardware.bluetooth.audio-impl \
    MtkInCallService

PRODUCT_PACKAGES += \
    vibratorfeature-wrapper \
    PowerOffAlarm \
    IFAAService

PRODUCT_VENDOR_PROPERTIES += ro.vendor.sensors.xiaomi.udfps=true

# Fingerprint, sensors, lights, power/mtkpower and health are the complete
# Android 16 stock AIDL services selected by the fresh vendor inventory. Do not
# install source replacement services with the same VINTF instances.

PRODUCT_PACKAGES += \
    CarrierConfigOverlayMT6895 \
    FrameworksResOverlayMT6895 \
    SettingsOverlayMT6895 \
    SystemUIOverlayMT6895 \
    TetheringResOverlayMT6895 \
    WifiResOverlayMT6895 \
    LineageApertureOverlayMT6895 \
    LineageDialerMT6895 \
    LineageSDKOverlayMT6895 \
    LineageSettingsOverlayMT6895 \
    LineageSystemUIOverlayMT6895 \
    PowerOffAlarmOverlayMT6895

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/fstab.mt6895:$(TARGET_COPY_OUT_VENDOR_RAMDISK)/first_stage_ramdisk/fstab.mt6895 \
    $(LOCAL_PATH)/rootdir/fstab.mt6895:$(TARGET_COPY_OUT_RECOVERY)/root/first_stage_ramdisk/fstab.mt6895 \
    $(LOCAL_PATH)/configs/powerhint.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json \
    $(LOCAL_PATH)/configs/thermal_info_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config.json

$(call inherit-product, vendor/mediatek/ims/ims.mk)
$(call inherit-product-if-exists, vendor/xiaomi/aristotle/aristotle-vendor.mk)
