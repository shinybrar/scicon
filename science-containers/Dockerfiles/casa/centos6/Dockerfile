FROM centos:6
#this Dockerfile runs through the build of a centos6 container and saves it
# to images.canfar.net, to use as a base for the subsequent builds of older
# casa versions, because the web-based centos6 distributions are becoming
# unstable and unmaintained

# Override old repo info with current urls
RUN rm /etc/yum.repos.d/CentOS-Base.repo
ADD CentOS-Base.repo /etc/yum.repos.d/

RUN yum clean all -y
RUN yum makecache -y
RUN yum update -y
RUN yum install -y freetype libSM libXi libXrender libXrandr \
	libXfixes libXcursor libXinerama fontconfig \
        libxslt xauth xorg-x11-server-Xvfb dbus-x11 \
	tkinter ImageMagick-c++ xterm perl autoconf python-sphinx graphviz

RUN yum install -y sssd-client acl

