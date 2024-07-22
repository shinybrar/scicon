FROM ubuntu:20.04

#This Dockerfile creates a local version of the Ubuntu 20.04 OS, along with
# standard software/libraries that CASA versions need to run.  This container
# is stored on harbor for to assist with long term stability

RUN apt update && \
    apt upgrade -y && \
    apt install -y libsm6 libxi6 libxrender1 libxrandr2 \
        libxfixes3 libxcursor1 libxinerama1 fontconfig \
        imagemagick xterm && \
    apt install -y perl autoconf autoconf graphviz xz-utils \
        gfortran libcanberra-gtk-module libsnl0 && \
#NB: for 20.04, need libsnl0 not libsnl-dev
    apt install -y libxslt1.1 xauth xorg xvfb dbus && \
#
    apt install -y libfuse2  && \
#Add in firefox and library dependency
    apt install -y firefox libpci3 && \
    apt install -y sssd acl && \
    apt install -y wget && \
#add in tcsh for admit installation
    apt install -y tcsh
