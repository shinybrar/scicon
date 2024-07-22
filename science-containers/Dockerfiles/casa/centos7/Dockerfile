FROM centos:7
#This dockerfile makes a centos7 container with library dependencies needed
# for casa versions

# Override old repo info with current urls
RUN rm /etc/yum.repos.d/CentOS-Base.repo
ADD CentOS-Base.repo /etc/yum.repos.d/

RUN yum clean all -y && \
    yum makecache -y && \
    yum update -y && \
    yum install -y freetype libSM libXi libXrender libXrandr \
	libXfixes libXcursor libXinerama fontconfig \
        libxslt xauth xorg-x11-server-Xvfb dbus-x11 \
	tkinter ImageMagick-c++ xterm perl autoconf python-sphinx graphviz xz && \
    yum install -y firefox && \
    yum install -y sssd-client acl && \
#for admit:
    yum install -y tcsh && \ 
#for analysisUtils:
    yum install -y wget 

