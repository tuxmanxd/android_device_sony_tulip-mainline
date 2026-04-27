KERNEL_SRC := $(TARGET_KERNEL_SOURCE)
KERNEL_OUT := $(PRODUCT_OUT)/obj/KERNEL_OBJ
KERNEL_CONFIG := $(KERNEL_OUT)/.config
TULIP_DTB := $(PRODUCT_OUT)/obj/KERNEL_OBJ/arch/arm64/boot/dts/qcom/msm8939-sony-xperia-kanuti-tulip.dtb

define make-kernel
	$(hide) cat $(PRODUCT_OUT)/kernel $(TULIP_DTB) > $(PRODUCT_OUT)/kernel-dtb
endef

$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES) $(TARGET_PREBUILT_INT_KERNEL)
	$(call pretty,"Success!: $@")
	$(make-kernel)
	$(hide) $(MKBOOTIMG) --kernel $(PRODUCT_OUT)/kernel-dtb \
		--ramdisk $(PRODUCT_OUT)/ramdisk.img \
		--base 0x80000000 --pagesize 2048 \
		--cmdline "$(BOARD_KERNEL_CMDLINE)" --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE))

$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) $(recovery_ramdisk) $(recovery_kernel) $(TARGET_PREBUILT_INT_KERNEL)
	$(call pretty,"DONE!: $@")
	$(make-kernel)
	$(hide) $(MKBOOTIMG) --kernel $(PRODUCT_OUT)/kernel-dtb \
		--ramdisk $(recovery_ramdisk) \
		--base 0x80000000 --pagesize 2048 \
		--cmdline "$(BOARD_KERNEL_CMDLINE)" --output $@
