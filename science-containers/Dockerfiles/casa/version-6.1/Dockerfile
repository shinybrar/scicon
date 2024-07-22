FROM images.canfar.net/skaha/centos:7
#NB: CASA 6.1.X needs glibc2.29 and does not work with ubuntu20.04 which 
# has glibc2.31. 
#xterm dependency is an extra to get the casa shell in the display
#perl was added for casa later than 5


##additional packages for UVmultifit
#RUN yum install -y gcc gcc-c++ gsl-devel fftw-devel
 
# setup all required env variables
ARG CASA_RELEASE
ENV CASA_RELEASE=${CASA_RELEASE}
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/casa/bin

# unpack and move casa databundle to container
ADD ${CASA_RELEASE}.tar.xz /opt/

# chown because the untarred casa has wrong owner/group
##NB: commands below revert back to the pre-CASA6.4 terminology, as the version of python is now specified everywhere in the full path.
##NB2: exception is pipeline6.5.3, which does not specify -py3.8 and thus has a different naming structure to that below.
## (the %%-py* string removes the -py3.X part of the CASA_RELEASE variable name for the directory structure)
RUN chown -R root:root /opt/${CASA_RELEASE%%-py*} && ln -s /opt/${CASA_RELEASE%%-py*} /opt/casa

## add the admit enhancement (issue #25)
RUN mkdir /opt/admit
ADD admit /opt/admit
RUN cd /opt/admit && \
    autoupdate && autoconf && \
    ./configure --with-casa-root=/opt/${CASA_RELEASE%%-py*}

# Allow runtime symlink creation to the casa-data-repository
# Create a dangling symlink to casa-data-repository so that after deployment
# the symlink will link to the actual casa-data-repository in storage.
RUN mkdir -p /arc/projects/casa-data-repository && \
    rm -rf /opt/${CASA_RELEASE%%-py*}/data && \
    ln -s /arc/projects/casa-data-repository/ /opt/${CASA_RELEASE%%-py*}/data && \
    chmod 777 /opt/${CASA_RELEASE%%-py*} && \
    cd /opt/${CASA_RELEASE%%-py*} && \
    REPLACED_DATA=`find lib -name __data__` && \
    chmod 777 ${REPLACED_DATA}/.. && \
    rm -rf ${REPLACED_DATA} && \
    ln -s /arc/projects/casa-data-repository/ /opt/${CASA_RELEASE%%-py*}/${REPLACED_DATA} && \
    rm -rf /arc

#Add in analysisUtils package
RUN mkdir /opt/casa/analysisUtils && \
    cd /opt/casa/analysisUtils && \
    wget ftp://ftp.cv.nrao.edu/pub/casaguides/analysis_scripts.tar && \
    tar -xvf analysis_scripts.tar
#(if above doesn't work, can manually download the package and add as below)
#ADD ./analysis_scripts.tar /opt/casa/analysisUtils/
#NB: the analysisUtils path is added to the CASA startup file in the init.sh script
# (needs access to user's $HOME)


RUN mkdir /skaha
ADD init.sh /skaha/

# generate missing dbus uuid (issue #47)
RUN dbus-uuidgen --ensure

ADD nsswitch.conf /etc/

WORKDIR /opt
COPY extract-casaviewer.sh .
#below suggested by Seb to help with viewer script & variables, doesn't work
# here for some reason, and generally hasn't been effective
#ENV PYTHONPATH /opt/${CASA_RELEASE%%-py*}/lib/py/lib/python3.8/site-packages
RUN bash extract-casaviewer.sh && rm extract-casaviewer.sh

RUN chmod 777 -R /opt/squashfs-root /opt/squashfs-root/usr /opt/squashfs-root/usr/*

CMD [ "/skaha/init.sh" ]
