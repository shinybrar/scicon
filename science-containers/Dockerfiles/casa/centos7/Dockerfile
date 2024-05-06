FROM centos:7
#This dockerfile makes a centos7 container with library dependencies needed
# for casa versions

RUN yum clean all -y
RUN yum makecache -y
RUN yum update -y
RUN yum install -y freetype libSM libXi libXrender libXrandr \
	libXfixes libXcursor libXinerama fontconfig \
        libxslt xauth xorg-x11-server-Xvfb dbus-x11 \
	tkinter ImageMagick-c++ xterm perl autoconf python-sphinx graphviz xz

RUN yum install -y firefox

RUN yum install -y sssd-client acl

