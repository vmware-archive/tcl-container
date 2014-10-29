#!/bin/sh
# script to create a container for tinycorelinux

TCL_BASE_URL=http://tinycorelinux.net/5.x/x86/

test -f rootfs.gz || wget $TCL_BASE_URL/release/distribution_files/rootfs.gz

# tcl uses squahfs, but does not have squashfs-tools in root image
# but without squashfs-tools we cannot imstall packages in it
test -f squashfs-tools-4.x.tcz || wget $TCL_BASE_URL/tcz/squashfs-tools-4.x.tcz

mkdir rootfs
cd rootfs
zcat ../rootfs.gz | sudo cpio -f -i -H newc -d --no-absolute-filenames
sudo unsquashfs -d . -f ../squashfs-tools-4.x.tcz
cd ..
sudo tar -C rootfs -c . | sudo docker import - tinycorelinux

