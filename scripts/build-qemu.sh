cd qemu
./configure --target-list=riscv64-softmmu --enable-debug
make -j$(nproc)
