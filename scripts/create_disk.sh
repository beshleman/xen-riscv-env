#!/bin/bash

kernel_size=$(printf "0x%02x" $(stat --format %s ./linux/arch/riscv/boot/Image.gz))

mkdir -p ./disk/boot
dtc -q -I dts -O dtb -o ./disk/boot/riscv64-qemu-virt.dtb ./dts/riscv64-qemu-virt.dts
cp xen/xen/xen-syms disk/boot/xen
cp xen/xen/xen disk/boot/xen
cp linux/arch/riscv/boot/Image.gz disk/boot/Image.gz

mkimage -A riscv -O linux -T kernel -C none \
    -a 0x80400000 -e 0x80400000 -n "Linux Kernel Image" \
    -d xen/xen/xen disk/boot/uImage

# rootfs is not needed yet
# cp -f busybox/rootfs.img ./disk/images/riscv/virt64/rootfs.img

cat > ./disk/boot.txt <<EOF
scsi scan
scsi device 0
ext2load scsi 0:0 0x80600000 /boot/uImage
ext2load scsi 0:0 0x80800000 /boot/riscv64-qemu-virt.dtb
ext2load scsi 0:0 0x80802000 /boot/Image.gz

fdt addr 0x80600000
fdt resize
fdt set /chosen \#address-cells <1>
fdt set /chosen \#size-cells <1>

fdt mknod /chosen module@0
fdt set /chosen/module@0 compatible "xen,linux-zimage" "xen,multiboot-module"
fdt set /chosen/module@0 reg <0x80802000 ${kernel_size}>
fdt set /chosen/module@0 bootargs "console=hvc earlycon"

bootm 0x80600000 -  0x80800000
EOF

mkimage -A riscv -T script -O linux -d ./disk/boot.txt ./disk/boot.scr
genext2fs -B 1024 -b 32768 -d ./disk ./disk.img
