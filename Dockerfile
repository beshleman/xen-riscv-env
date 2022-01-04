FROM archlinux:latest

RUN pacman --noconfirm -Syu

# Packages needed for building the kernel
RUN pacman --noconfirm -Sy \
    xmlto kmod inetutils bc libelf

# Setup QEMU
RUN pacman --noconfirm -Sy \
    qemu-arch-extra
 
RUN pacman --noconfirm -Sy \
    iputils \
    net-tools \
    openssh \
    tmux \
    vim

RUN pacman --noconfirm -Sy \
    riscv64-linux-gnu-gdb

# Packages needed for the build
RUN pacman --noconfirm -Sy \
    base-devel \
    gcc \
    git

RUN pacman --noconfirm -Sy \
    riscv64-linux-gnu-gcc

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


ENV PATH=/opt/riscv/bin/:${PATH}
SHELL [ "/bin/bash -c" ]
