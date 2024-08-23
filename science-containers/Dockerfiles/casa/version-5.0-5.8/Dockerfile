FROM images.canfar.net/skaha/centos:6.10
#NB: 6.10 version is needed (rather than generic 6) to get UVMultiFit package
# dependencies to install properly via yum

#final sets of package installations: As of Aug 22/24, cannot re-build
# centos6.10 base container from source

#Admit & analysisUtils packages, respectively:
RUN yum install -y tcsh wget && \
#additional packages for UVmultifit
    yum install -y gcc gcc-c++ gsl-devel fftw-devel git.x86_64

# setup all required env variables
ARG CASA_RELEASE
ENV CASA_RELEASE=${CASA_RELEASE}
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/casa/bin

# untar casa databundle to container
ADD ${CASA_RELEASE}.tar.gz /opt/

# chown because the untarred casa has wrong owner/group
RUN chown -R root:root /opt/${CASA_RELEASE} && ln -s /opt/${CASA_RELEASE} /opt/casa


# add the admit enhancement (issue #25)
RUN mkdir /opt/admit
ADD admit /opt/admit
RUN cd /opt/admit && \
    autoconf && ./configure --with-casa-root=/opt/${CASA_RELEASE}

# Allow runtime symlink creation to the casa-data-repository
# Create a dangling symlink to casa-data-repository so that after deployment
# the symlink will link to the actual casa-data-repository in storage.
RUN mkdir -p /arc/projects/casa-data-repository && \
    rm -rf /opt/${CASA_RELEASE}/data && \
    ln -s /arc/projects/casa-data-repository/ /opt/${CASA_RELEASE}/data && \
    chmod 777 /opt/${CASA_RELEASE} && \
    rm -rf /arc && \
#
    mkdir /skaha
ADD init.sh /skaha/

# generate missing dbus uuid (issue #47)
RUN dbus-uuidgen --ensure

ADD nsswitch.conf /etc/

#install UVMultiFit from github.  Recommended location for install as below
#user imports into casa after initiating a session by typing 
# 'from NordicARC import uvmultifit as uvm'
RUN mkdir /opt/casa/NordicARC && \
#(NB: this link is for the 'master' branch which does the python2 version)
    cd /opt/casa/NordicARC && \
    git clone https://github.com/onsala-space-observatory/UVMultiFit.git && \
#now update the CASA path within the Makefile, in a somewhat clunky way
    cd /opt/casa/NordicARC/UVMultiFit && \
    echo "CASADIR="/opt/${CASA_RELEASE} >> casadir.txt && \
    cat casadir.txt Makefile >> Makefile2 && \
    cd /opt/casa/NordicARC/UVMultiFit && \
    mv Makefile2 Makefile && rm -f casadir.txt && \
#run the installation script
    cd /opt/casa/NordicARC/UVMultiFit && make install && \
#-----------------
#One final note relevant for users: the recommended install tests expect
# the tests to be run in the program directory, where users will not
# have write access in our containers.  One easy solution is to copy the
# relevant directories from /UVMultiFit into a user's directory and then 
# run the tests there.
#
#have the UVMultiFit import instructions echoed to terminal start-up
    echo 'cat /etc/motd' >> /etc/profile.d/motd.sh && \
    echo 'To load the UVMultiFit package, initiate casa then type "from NordicARC import uvmultifit as uvm"' >> /etc/motd && \
#
#Add in analysisUtils package
    mkdir /opt/casa/analysisUtils  && \
    cd /opt/casa/analysisUtils && \ 
    wget ftp://ftp.cv.nrao.edu/pub/casaguides/analysis_scripts.tar && \
    tar -xvf analysis_scripts.tar 
#(if above doesn't work, can manually download the package and add as below)
#ADD ./analysis_scripts.tar /opt/casa/analysisUtils/
#NB: the analysisUtils path is added to the CASA startup file in the init.sh script
# (needs access to user's $HOME)


RUN cd /opt/${CASA_RELEASE}

CMD [ "/skaha/init.sh" ]
