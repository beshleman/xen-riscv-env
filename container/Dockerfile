FROM archlinux/base

# Packages needed for the build
RUN pacman --noconfirm -Syu \
    base-devel \
    gcc \
    git \
    pixman \
    python \
    sh

# RISC-V toolchain
RUN git clone --recursive -j$(nproc) --progress https://github.com/riscv/riscv-gnu-toolchain && \
    cd riscv-gnu-toolchain/ && \
    ./configure --prefix=/opt/riscv && \
    make linux -j$(nproc) && \
    rm -R /riscv-gnu-toolchain

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
    cd /opt && rm -r qemu && \
    qemu-system-riscv64 --version

RUN pacman --noconfirm -Sy \
    iputils \
    net-tools \
    tmux \
    vim

ENV PATH=/opt/riscv/bin/:${PATH}
WORKDIR /home
SHELL [ "/bin/bash -c" ]
