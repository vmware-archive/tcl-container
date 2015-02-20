FROM tinycorelinux

COPY deps.list /root/

ENV TCL_REPO_BASE   http://tinycorelinux.net/6.x/x86_64

# Install the TCZ dependencies
RUN cd /tmp && for dep in $(cat /root/deps.list); do \
    echo "Download $TCL_REPO_BASE/tcz/$dep" &&\
        wget $TCL_REPO_BASE/tcz/$dep && \
        unsquashfs -f -d / /tmp/$dep && \
        rm -f /tmp/$dep ;\
    done

RUN ldconfig

COPY patches /root/patches/
COPY build.sh /root/

