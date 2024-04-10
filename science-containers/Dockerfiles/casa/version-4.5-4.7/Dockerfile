FROM images.canfar.net/skaha/centos:6

#Upgraded to use base OS as centos6 as saved on harbor for stability
#Split out from old 4.5-5.8 combined directory as casa5.x versions
#Can have UVMultiFit installed, but casa4.X cannot

# xterm dependency is an extra to get the casa shell in the display
# perl was added for casa later than 5

# setup all required env variables
ARG CASA_RELEASE
ENV CASA_RELEASE=${CASA_RELEASE}
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/casa/bin

# untar casa databundle to container
ADD ${CASA_RELEASE}.tar.gz /opt/

# chown because the untarred casa has wrong owner/group
RUN chown -R root:root /opt/${CASA_RELEASE} && ln -s /opt/${CASA_RELEASE} /opt/casa

# add the admit enhancement (issue #25)
RUN yum install -y tcsh
RUN mkdir /opt/admit
ADD admit /opt/admit
RUN cd /opt/admit && \
    autoconf && ./configure --with-casa-root=/opt/${CASA_RELEASE}

# Allow runtime symlink creation to the casa-data-repository
# Create a dangling symlink to casa-data-repository so that after deployment
# the symlink will link to the actual casa-data-repository in storage.
RUN mkdir -p /arc/projects/casa-data-repository
RUN rm -rf /opt/${CASA_RELEASE}/data && \
    ln -s /arc/projects/casa-data-repository/ /opt/${CASA_RELEASE}/data
RUN chmod 777 /opt/${CASA_RELEASE}
RUN rm -rf /arc


RUN mkdir /skaha
ADD init.sh /skaha/

# generate missing dbus uuid (issue #47)
RUN dbus-uuidgen --ensure

ADD nsswitch.conf /etc/

#Add in analysisUtils package
RUN mkdir /opt/casa/analysisUtils 
RUN yum install -y wget
RUN cd /opt/casa/analysisUtils && wget ftp://ftp.cv.nrao.edu/pub/casaguides/analysis_scripts.tar && tar -xvf analysis_scripts.tar
#(if above doesn't work, can manually download the package and add as below)
#ADD ./analysis_scripts.tar /opt/casa/analysisUtils/
#NB: the analysisUtils path is added to the CASA startup file in the init.sh script
# (needs access to user's $HOME)

RUN cd /opt/${CASA_RELEASE}

CMD [ "/skaha/init.sh" ]
