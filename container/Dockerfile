FROM archlinux/base

RUN pacman --noconfirm -Syu git base-devel python pixman gcc

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

# Setup riscv tools
RUN pacman --noconfirm -Sy riscv64-linux-gnu-gcc riscv64-linux-gnu-gdb riscv64-linux-gnu-binutils

# ifconfig and ping
RUN pacman --noconfirm -Sy iputils net-tools

# tmux
RUN pacman --noconfirm -Sy tmux

RUN mkdir -p /srv/git/
RUN mkdir -p /srv/git/scripts/

COPY build.sh /srv/git/scripts/build.sh
RUN chmod +x /srv/git/scripts/build.sh

COPY run.sh /srv/git/scripts/run.sh
RUN chmod +x /srv/git/scripts/run.sh

COPY gdb.sh /srv/git/scripts/gdb.sh
RUN chmod +x /srv/git/scripts/gdb.sh

COPY Makefile /srv/git/Makefile

WORKDIR /srv/git
