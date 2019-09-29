#!/bin/bash

usage="$0 EXECUTABLE_TYPE [OPTIONS]\n\
EXECUTABLE_TYPE is the OpenSBI or BBL executable type: fw_payload, fw_jump, bbl\n\
\n\
Example: $0 fw_jump\n\
\n\
OPTIONS:\n\
   -od=<dir> | --opensbi-dir=<dir>		The OpenSBI project directory\n\
   -ox=<dir> | --xen-dir=<dir>			The Xen project directory\n\
   -d        | --debug				Enable QEMU gdb\n\
"

die() {
	printf "$@" >&2
	exit 1
}

[[ "$#" -lt 1 ]] &&  die "${usage}"

executable_type=$1
shift

for i in "$@"
do
case $i in
    -od=*|--opensbi-dir=*)
    opensbi_dir="${i#*=}"
    shift
    ;;
    -xd=*|--xen-dir=*)
    xen_dir="${i#*=}"
    shift
    ;;
    -d*|--debug*)
    debug="${i#*=}"
    shift
    ;;
    *)
	die "${usage}"
    ;;
esac
done

# Default to relative paths from pwd to project directories
top=$(pwd)
[[ -z "${opensbi_dir}" ]] && opensbi_dir=${top}/opensbi
[[ -z "${xen_dir}" ]] && xen_dir=${top}/xen
[[ -z "${QEMU}" ]] && QEMU=$(which qemu-system-riscv64)

telnetport=45454
QEMU_FLAGS="-nographic -s -S 						\
		   -machine virt -cpu rv64,x-h=true			\
		   -serial mon:stdio -serial null -m 4G 		\
		   -monitor telnet::${telnetport},server,nowait"

if [[ "x${executable_type}" == "xfw_payload" ]]; then
	kernel=${opensbi_dir}/build/platform/qemu/virt/firmware/fw_payload.elf
elif [[ "x${executable_type}" == "xfw_jump" ]]; then
	xen_bin=${xen_dir}/xen/xen
	QEMU_FLAGS="${QEMU_FLAGS}  -device loader,file=${xen_bin},addr=0x80200000"
	kernel=${top}/opensbi/build/platform/qemu/virt/firmware/fw_jump.elf
elif [[ "x${executable_type}" == "xlinux" ]]; then
	${QEMU} -nographic -machine virt \
	      -kernel ${top}/riscv-pk/build/bbl -append "root=/dev/vda ro console=ttyS0" \
	      -drive file=${top}/busybear-linux/busybear.bin,format=raw,id=hd0 \
	      -device virtio-blk-device,drive=hd0
else
	die "${usage}"
fi

echo "${kernel}" > ${top}/.last_kernel
echo "Launching QEMU, monitor telnet at port: ${telnetport}"
echo "Launching:  qemu-system-riscv64 ${QEMU_FLAGS} -kernel ${kernel}"
${QEMU} ${QEMU_FLAGS} -kernel ${kernel}

# Useful GDB commands
# -------------------
# gdb /home/bobbye/projects/opensbi/build/platform/qemu/virt/firmware/fw_jump.elf
# target remote localhost:1234
# add-symbol-file /home/bobbye/projects/xen/xen/xen-syms 0x80200000
# set debug-file-directory /home/bobbye/projects/opensbi/firmware
