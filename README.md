tcl-container
=============

Create a [tinycorelinux](http://tinycorelinux.net/) container to build services 
and tools for it - useful for boot2docker / docker-machine.

To create a tinycorelinux docker image, use the script `mktcl.sh`:

```console
$ ./mktcl.sh
```

It's also useful to build a development container based on this using the 
provided Dockerfile.

```console
$ docker build -t tinycorelinux:development .
```

Now you can use this container image to build 
[`open-vm-tools`](https://github.com/vmware/open-vm-tools) and 
[`libdnet`](http://libdnet.sourceforge.net/). The included script `build.sh` 
will help you with this. It is located at `/root/build.sh` inside the 
development container image.

The `build.sh` script will put downloaded tarballs into the directory 
`/tarballs` and it may be a good idea to persist these in a dedicated volume.

```console
$ docker volume create --name ovtdev-cache
$ docker run -dit --name open-vm-tools-devel -v ovtdev-cache:/tarballs tinycorelinux:development
$ docker attach open-vm-tools-devel
container # cd /root && ./build.sh
$ docker commit open-vm-tools-devel tinycorelinux:ovt-devel
```
