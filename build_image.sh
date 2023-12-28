#!/bin/bash

# Source: scripts/build/make-qemu-x86_64-initrd.sh
sudo echo ""

export UK_SEV_ROOT="$(realpath ../../)"
export UK_LIBS="${UK_SEV_ROOT}/libs"
export UK_ROOT="${UK_SEV_ROOT}/unikraft"


OUT_ISO=kernel.iso
CMD_LINE=app-nginx.cmdl
BINARY=build/nginx_qemu-x86_64

# Build cmd line file
echo "nginx netdev.ipv4_addr=172.44.0.2 netdev.ipv4_gw_addr=172.44.0.1 netdev.ipv4_subnet_mask=255.255.255.0 --" > $CMD_LINE

# Build initrd cpio file
cd fs0
find -depth -print | tac | bsdcpio -o --format newc > ../fs0.cpio
cd ..

set -eux

make distclean
UK_DEFCONFIG=$(pwd)/.config.nginx-qemu-x86_64-initrd-sev-efi make defconfig
make -j $(nproc)

rm -rf $OUT_ISO
sudo $UK_SEV_ROOT/unikraft/support/scripts/mkukimg -f iso -i fs0.cpio -k $BINARY -b ukefi -a X64 -c $CMD_LINE -o $OUT_ISO
