#!/bin/bash

kernel_image="${1:-kernel.iso}"



sudo ip link set dev virbr0 down 2> /dev/null
sudo ip link del dev virbr0 2> /dev/null
sudo ip link add dev virbr0 type bridge
sudo ip address add 172.44.0.1/24 dev virbr0
sudo ip link set dev virbr0 up

QEMU_ARGS=(
    -cdrom "$kernel_image"
    -initrd fs0.cpio
    -default-network
    -sev-snp
    # -append "netdev.ipv4_addr=172.44.0.2 netdev.ipv4_gw_addr=172.44.0.1 netdev.ipv4_subnet_mask=255.255.255.0 --"
    # -netdev bridge,id=en0,br=virbr0 -device virtio-net-pci,netdev=en0
)

sudo ../../launch-qemu-latest.sh "${QEMU_ARGS[@]}"

