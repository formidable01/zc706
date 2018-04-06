ROOT_DIR := $(shell pwd)
KERNEL_DIR := ${ROOT_DIR}/kernel-source

.PHONY: kernel_uimage
kernel_uimage:
	make -j4 -C ${KERNEL_DIR} UIMAGE_LOADADDR=0x2080000 uImage  ARCH=arm
	cp -p ${KERNEL_DIR}/arch/arm/boot/uImage images/

.PHONY: kernel_zimage
kernel_zimage:
	make -j4 -C ${KERNEL_DIR} zImage
	cp -p ${KERNEL_DIR}/arch/arm/boot/zImage images/

.PHONY: kernel_dtb
kernel_dtb:
	make -j4 -C ${KERNEL_DIR} zynq-zc706.dtb
	cp -p ${KERNEL_DIR}/arch/arm/boot/dts/zynq-zc706.dtb images/

.PHONY: kernel_oldconfig
kernel_oldconfig:
	cp -p config/kernel_config ${KERNEL_DIR}/.config
	make -j4 -C ${KERNEL_DIR} oldconfig

.PHONY: kernel_modules
kernel_modules:
	make -j4 -C ${KERNEL_DIR} modules

.PHONY: kernel_modules_install
kernel_modules_install:
	make -j4 -C ${KERNEL_DIR} modules_install INSTALL_MOD_PATH=${ROOT_DIR}/images

.PHONY: kernel_xconfig
kernel_xconfig:
	make -C ${KERNEL_DIR} xconfig ARCH=arm

.PHONY: kernel_menuconfig
kernel_menuconfig:
	make -C ${KERNEL_DIR} menuconfig ARCH=arm

.PHONY: kernel_save_config
kernel_save_config:
	cp -p ${KERNEL_DIR}/.config config/kernel_config

.PHONY: kernel_mrproper
kernel_mrproper:
	make -j4 -C ${KERNEL_DIR} mrproper
	rm -rf images/*
