#!/bin/sh
# script to create a container for tinycorelinux

TCL_BASE_URL=http://tinycorelinux.net/6.x/x86_64

test -f rootfs.gz || wget $TCL_BASE_URL/release/distribution_files/rootfs64.gz

# tcl uses squahfs, but does not have squashfs-tools in root image
# but without squashfs-tools we cannot imstall packages in it
test -f squashfs-tools.tcz || wget $TCL_BASE_URL/tcz/squashfs-tools.tcz

mkdir rootfs
cd rootfs
zcat ../rootfs64.gz | sudo cpio -f -i -H newc -d --no-absolute-filenames
sudo unsquashfs -d . -f ../squashfs-tools.tcz
cd ..
sudo tar -C rootfs -c . | sudo docker import - tinycorelinux

