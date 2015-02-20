#!/bin/sh
# script that downloads and builds open-vm-tools and libdnet 
# supposed to be run in a tinycorelinux container

LIBDNET=libdnet-1.11
LIBDNET_URL=http://sourceforge.net/projects/libdnet/files/libdnet/${LIBDNET}/${LIBDNET}.tar.gz

OVT=open-vm-tools-9.4.6-1770165
OVT_URL=http://sourceforge.net/projects/open-vm-tools/files/open-vm-tools/stable-9.4.x/${OVT}.tar.gz

if [ ! -d /tarballs ]; then
	echo "/tarballs directory not found"
	exit 1
fi

cd /root
wget ${LIBDNET_URL}
wget ${OVT_URL}

mkdir /tmp/stage

cd /root
tar zxf ${LIBDNET}.tar.gz 
cd ${LIBDNET}
./configure && make && make install && make DESTDIR=/tmp/stage/libdnet install

(cd /tmp/stage/libdnet && tar zcf /tarballs/libdnet.tgz .)

cd /root
tar zxf ${OVT}.tar.gz 
cd ${OVT}/

for f in /root/patches/ovt/*.patch ; do
   patch -p0 < $f
done

# we need to set --host because boot2docker is 32 bit, and this will not be
# detected correctly in a container running in a 64bit host
autoreconf -i && \
./configure --without-kernel-modules --without-pam --without-x --without-icu && \
  make LIBS="-ltirpc" CFLAGS='-Wno-deprecated-declarations' && \
  make DESTDIR=/tmp/stage/open-vm-tools install

(cd /tmp/stage/open-vm-tools && tar zcf /tarballs/open-vm-tools.tgz .)

