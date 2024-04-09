FROM centos:5
#this Dockerfile runs through the build of a centos5 container and saves it
# on images.canfar.net, to use as a base for the subsequent builds of 
# older casa versions, because the web-based centos5 distributions are
# becoming unstable and unmaintained


# Override old repo info with current urls
# NB: this revised process is completely eliminating two of the original repos
# which are CentOS-Media.repo, for configuring CD installation, and 
# CentOS-Vault.repo, which provides urls for all previous versions of 
# CentOS 5 (current version here is 5.11)
# Default baseurl no longer works with yum, but luckily at least two
# of the other mirror sites do 
# imagemagick-c++ won't yum install on http://archive.kernel.org/centos-vault 
# everything incl imagemagick works on http://mirror.nsc.liu.se/centos-store/
# (didn't do a full test of the only other mirror site, http://linuxsoft.cern.ch/centos-vault)


RUN rm /etc/yum.repos.d/*
ADD CentOS-Base.repo /etc/yum.repos.d/
ADD CentOS-Debuginfo.repo /etc/yum.repos.d/
ADD CentOS-Sources.repo /etc/yum.repos.d/
ADD CentOS-fasttrack.repo /etc/yum.repos.d/
ADD libselinux.repo /etc/yum.repos.d/

RUN yum clean all -y
#commented out - likely unnecessary?
#RUN yum makecache -y
RUN yum update -y

RUN yum install -y freetype libSM libXi libXrender libXrandr \
	libXfixes libXcursor libXinerama fontconfig \
	libxslt xauth xorg-x11-server-Xvfb dbus-x11 \
	tkinter xterm perl
RUN yum install -y ImageMagick-c++

RUN yum install -y sssd-client acl which

