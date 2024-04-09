FROM images.canfar.net/skaha/centos:5
#NB: centos 5 repo no longer available directly from Docker

# xterm dependency is an extra to get the casa shell in the display
# perl was added for casa later than 5

#coding below was needed when centos taken from source
# Override old repo info with current urls
#RUN rm /etc/yum.repos.d/CentOS-Base.repo
#ADD CentOS-Base.repo /etc/yum.repos.d/

RUN yum clean all -y
#RUN yum makecache -y
RUN yum update -y

#These are already included in the CANFAR base centos5 container
#RUN yum install -y freetype libSM libXi libXrender libXrandr \
#	libXfixes libXcursor libXinerama fontconfig \
#	libxslt xauth xorg-x11-server-Xvfb dbus-x11 \
#	tkinter ImageMagick-c++ xterm perl

# setup all required env variables
ARG CASA_RELEASE
ENV CASA_RELEASE=${CASA_RELEASE}
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/casa/bin

# untar casa databundle to container
ADD ${CASA_RELEASE}.tar.gz /opt/

# patch in fix for get_user.py
ARG PYTHON
ENV PYTHON=${PYTHON}
RUN rm -f /opt/${CASA_RELEASE}/lib64/${PYTHON}/get_user.py
ADD get_user.py /opt/${CASA_RELEASE}/lib64/${PYTHON}/get_user.py

# chown because the untarred casa has wrong owner/group
RUN chown -R root:root /opt/${CASA_RELEASE} && ln -s /opt/${CASA_RELEASE} /opt/casa

RUN yum install -y sssd-client acl which

# Allow runtime symlink creation to the casa-data-repository
RUN mkdir -p /arc/projects/casa-data-repository
RUN rm -rf /opt/${CASA_RELEASE}/data && \
    ln -s /arc/projects/casa-data-repository/ /opt/${CASA_RELEASE}/data
RUN chmod 777 /opt/${CASA_RELEASE}
RUN rm -rf /arc

RUN mkdir /skaha
ADD startup.sh /skaha/

# generate missing dbus uuid (issue #47)
RUN dbus-uuidgen --ensure

ADD nsswitch.conf /etc/

RUN chmod -R a+rwx /skaha

#Add in analysisUtils package
RUN mkdir /opt/casa/analysisUtils
RUN yum install -y wget
RUN cd /opt/casa/analysisUtils && wget ftp://ftp.cv.nrao.edu/pub/casaguides/analysis_scripts.tar && tar -xvf analysis_scripts.tar
#(if above doesn't work, can manually download the package and add as below)
#ADD ./analysis_scripts.tar /opt/casa/analysisUtils/
#NB: the analysisUtils path is added to the CASA startup file in the init.sh script     
# (needs access to user's $HOME)

#HK updated below
#ENTRYPOINT [ "/skaha/startup.sh" ]
CMD [ "/skaha/init.sh" ]
