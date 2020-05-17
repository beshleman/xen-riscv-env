FROM registry.gitlab.com/bobbyeshleman/xen/archlinux:riscv

USER root

# Packages needed for building the kernel
RUN pacman --noconfirm -Syu \
    xmlto kmod inetutils bc libelf

# Setup QEMU
# RUN cd /opt/ && \
#     git clone --single-branch --branch mainline/alistair/riscv-hyp-ext-v0.5.next https://github.com/alistair23/qemu.git && \
#     cd qemu && \
#     mkdir build && \
#     cd build && \
#     ../configure --target-list=riscv64-softmmu \
#         --disable-docs \
#         --disable-guest-agent \
#         --disable-guest-agent-msi \
#         --disable-pie \
#         --disable-modules \
#         --disable-sparse \
#         --disable-gnutls \
#         --disable-nettle \
#         --disable-gcrypt \
#         --disable-auth-pam \
#         --disable-sdl \
#         --disable-sdl-image \
#         --disable-gtk \
#         --disable-vte \
#         --disable-curses \
#         --disable-iconv \
#         --disable-vnc \
#         --disable-vnc-sasl \
#         --disable-vnc-jpeg \
#         --disable-vnc-png \
#         --disable-cocoa \
#         --disable-virtfs \
#         --disable-mpath \
#         --disable-xen \
#         --disable-xen-pci-passthrough \
#         --disable-brlapi \
#         --disable-curl \
#         --disable-membarrier \
#         --disable-kvm \
#         --disable-hax \
#         --disable-hvf \
#         --disable-whpx \
#         --disable-rdma \
#         --disable-pvrdma \
#         --disable-vde \
#         --disable-netmap \
#         --disable-linux-aio \
#         --disable-cap-ng \
#         --disable-attr \
#         --disable-vhost-net \
#         --disable-vhost-vsock && \
#     make -j$(nproc) && make install && \
#     cd /opt && rm -r qemu && \
#     qemu-system-riscv64 --version
 
RUN pacman --noconfirm -Sy \
    iputils \
    net-tools \
    openssh \
    tmux \
    vim

RUN echo $'set background=dark \n\
set nocompatible        " use vim extensions \n\
" Bells \n\
set visualbell t_vb=    " turn off error beep/flash \n\
set novisualbell        " turn off visual bell \n\
" Editing info \n\
set number              "[same as nu] show line numbers \n\
set ruler               "[same as ru] show cursor position \n\
set showmode            "[same as smd] show when in insert mode \n\
" Search \n\
set hlsearch            " highlight searches \n\
"set incsearch           " do incremental searching \n\
" Auxilary files \n\
set nobackup            " do not keep a backup file (ending in ~) \n\
set noswapfile          " do not write a swap file \n\
" Smart editing \n\
set showmatch           "[same as sm] highlight matching (), {}, etc. \n\
"set nowrap              " do not wrap lines \n\
" Tabs and Indenting \n\
set autoindent          "[same as ai] always set autoindenting on \n\
set shiftwidth=4        "[same as sw] number of spaces to (auto)indent \n\
set tabstop=4           "[same as ts] number of spaces per tab \n\
set expandtab           "[same as et] use spaces instead of a tab \n\
set softtabstop=4       "[same as sts] number of spaces to use instead of a tab \n\
set smarttab            "[same as sta] <BS> deletes shiftwidth spaces from the start of a line \n\
set mouse -=a \n\
" Syntax highlighting \n\
syntax enable \n\
autocmd FileType make setlocal noexpandtab \n\
set tags=./tags,tags; \n\
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:< \n\
noremap <F5> :set list!<CR> \n\
noremap <F6> :set number!<CR> \n\
noremap <F7> :set paste!<CR> "' >> /usr/share/vim/vim82/defaults.vim

RUN sed -i '/^root ALL=(ALL) ALL$/a %sudo ALL=(ALL) NOPASSWD: ALL' /etc/sudoers; \
    echo 'Set disable_coredump false' >> /etc/sudo.conf 


USER user

ENV PATH=/opt/riscv/bin/:${PATH}
WORKDIR /home
SHELL [ "/bin/bash -c" ]
