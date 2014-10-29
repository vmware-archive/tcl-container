tcl-container
=============

Create a tinycorelinux container to build apps for it - useful for boot2docker

To create a tinycorelinux docker image, call the script mktcl.sh:
./mktcl.sh

Then build a development container out of using the Dockerfile:

sudo docker build .

This can then be used to build open-vm-tools and libdnet, using the file build.sh:

sudo docker tag 53a89975885d tinycorelinux:ovt-devel
sudo docker run -t -i tinycorelinux:ovt-devel /root/build.sh

