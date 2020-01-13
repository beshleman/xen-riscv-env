FROM archlinux/base

RUN pacman --noconfirm -Syu git base-devel python pixman gcc

# RISC-V toolchain
RUN git clone --recursive https://github.com/riscv/riscv-gnu-toolchain && \
    cd riscv-gnu-toolchain/ && \
    ./configure --prefix=/opt/riscv && \
    make linux -j8 && \
    rm -R /riscv-gnu-toolchain/

# Setup QEMU
RUN cd /opt/ && \
	git clone --single-branch --branch mainline/alistair/riscv-hyp-ext-v0.5.next https://github.com/alistair23/qemu.git && \
	cd qemu && \
	mkdir build && \
	cd build && \
	../configure --target-list=riscv64-softmmu \
			--disable-docs \
			--disable-guest-agent \
			--disable-guest-agent-msi \
			--disable-pie \
			--disable-modules \
			--disable-sparse \
			--disable-gnutls \
			--disable-nettle \
			--disable-gcrypt \
			--disable-auth-pam \
			--disable-sdl \
			--disable-sdl-image \
			--disable-gtk \
			--disable-vte \
			--disable-curses \
			--disable-iconv \
			--disable-vnc \
			--disable-vnc-sasl \
			--disable-vnc-jpeg \
			--disable-vnc-png \
			--disable-cocoa \
			--disable-virtfs \
			--disable-mpath \
			--disable-xen \
			--disable-xen-pci-passthrough \
			--disable-brlapi \
			--disable-curl \
			--disable-membarrier \
			--disable-bluez \
			--disable-kvm \
			--disable-hax \
			--disable-hvf \
			--disable-whpx \
			--disable-rdma \
			--disable-pvrdma \
			--disable-vde \
			--disable-netmap \
			--disable-linux-aio \
			--disable-cap-ng \
			--disable-attr \
			--disable-vhost-net \
			--disable-vhost-vsock && \
	make -j$(nproc) && make install && \
	qemu-system-riscv64 --version

# ifconfig and ping
RUN pacman --noconfirm -Sy iputils net-tools

# tmux
RUN pacman --noconfirm -Sy tmux

WORKDIR /home/
