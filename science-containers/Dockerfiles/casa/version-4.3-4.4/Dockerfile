FROM images.canfar.net/skaha/centos:6
#NB: this is using a locally saved centos6 container with CASA-required
# software pre-installed to aid in long-term stability.  Centos6 already
# has not been maintained for many years

# xterm dependency is an extra to get the casa shell in the display
# perl was added for casa later than 5

RUN yum update -y

# setup all required env variables
ARG CASA_RELEASE
ENV CASA_RELEASE=${CASA_RELEASE}
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/casa/bin

# untar casa databundle to container
ADD ${CASA_RELEASE}.tar.gz /opt/

# patch in fix for get_user.py
RUN rm -f /opt/${CASA_RELEASE}/lib/python2.7/get_user.py
ADD get_user.py /opt/${CASA_RELEASE}/lib/python2.7/get_user.py

# chown because the untarred casa has wrong owner/group
RUN chown -R root:root /opt/${CASA_RELEASE} && ln -s /opt/${CASA_RELEASE} /opt/casa

# create the guest account
#RUN groupadd -g 1001 guest
#RUN useradd -m -g guest -u 1001 guest && \
#    mkdir -p /home/guest/.ssl && \
#    chown -R guest:guest /home/guest/.ssl
#ENV HOME /home/guest
#ENV USER guest

# copy empty casa configs to avoid upgrade
#ADD casa /home/guest/.casa

#WORKDIR /home/guest

# updated to new leapsecond solution
# Allow runtime symlink creation to the casa-data-repository
# Create a dangling symlink to casa-data-repository so that after deployment
# the symlink will link to the actual casa-data-repository in storage.
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
