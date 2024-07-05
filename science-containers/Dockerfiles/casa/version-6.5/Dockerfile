FROM images.canfar.net/skaha/ubuntu:22.04

#NB: the one CASA pipeline version within this range has a different naming
# structure within the unpacked directories.  All of my attempts to deal with
# this difference in a scriptable manner have failed (see commented out below)
#Thus instead, please uncomment out the special CASA_RELEASE2 definition when
# building the CASA pipeline version
#idea below: if pipeline is in name, remove the -py* part, otherwise keep the same
#RUN if [[ ${CASA_RELEASE}=*pipeline* ]]; then CASA_RELEASE2=${CASA_RELEASE%%-py*}; else CASA_RELEASE2=${CASA_RELEASE}; fi

# setup all required env variables
ARG CASA_RELEASE
ENV CASA_RELEASE=${CASA_RELEASE}
ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/casa/bin

ENV CASA_RELEASE2=${CASA_RELEASE}
#uncomment out the line below *only* when building the pipeline version
#ENV CASA_RELEASE2=casa-6.5.3-28-pipeline-2023.0.0.36
#ENV CASA_RELEASE2=casa-6.5.4-9-pipeline-2023.1.0.124

# unpack and move casa databundle to container
ADD ${CASA_RELEASE}.tar.xz /opt/

# chown because the untarred casa has wrong owner/group
RUN chown -R root:root /opt/${CASA_RELEASE2} && \
    ln -s /opt/${CASA_RELEASE2} /opt/casa


## add the admit enhancement (issue #25)
RUN mkdir /opt/admit
ADD admit /opt/admit
RUN cd /opt/admit && \
    autoupdate && autoconf && ./configure --with-casa-root=/opt/${CASA_RELEASE2}

# Allow runtime symlink creation to the casa-data-repository
# Create a dangling symlink to casa-data-repository so that after deployment
# the symlink will link to the actual casa-data-repository in storage.
RUN mkdir -p /arc/projects/casa-data-repository && \
    rm -rf /opt/${CASA_RELEASE2}/data && \
    ln -s /arc/projects/casa-data-repository/ /opt/${CASA_RELEASE2}/data && \
    chmod 777 /opt/${CASA_RELEASE2} && \
    cd /opt/${CASA_RELEASE2} && \
    REPLACED_DATA=`find lib -name __data__` && \
    chmod 777 ${REPLACED_DATA}/.. && \
    rm -rf ${REPLACED_DATA} && \
    ln -s /arc/projects/casa-data-repository/ /opt/${CASA_RELEASE2}/${REPLACED_DATA} && \
    rm -rf /arc

##(below stuff commented out, was old code version)
##RUN rm -rf /opt/${CASA_RELEASE%%-py*}/data
###update for CASA6+, new directory for the leapsecond data
###(in theory, might need to run something like below, but this causes other
### install errors, presumably b/c of other files also in the lib directory)
###RUN rm -rf /opt/${CASA_RELEASE%%-py*}/lib
##RUN chmod 777 /opt/${CASA_RELEASE%%-py*}
#
#Add in analysisUtils package
RUN mkdir /opt/casa/analysisUtils && \
    cd /opt/casa/analysisUtils && \
    wget ftp://ftp.cv.nrao.edu/pub/casaguides/analysis_scripts.tar && \ 
    tar -xvf analysis_scripts.tar
#(if above doesn't work, can manually download the package and add as below)
#ADD ./analysis_scripts.tar /opt/casa/analysisUtils/
#NB: the analysisUtils path is added to the CASA startup file in the init.sh script
# (needs access to user's $HOME)


##NEW for CASA6.*: explicitly add in astropy
##Instructions here: https://casadocs.readthedocs.io/en/latest/notebooks/frequently-asked-questions.html
RUN /opt/${CASA_RELEASE2}/bin/python3 -m pip install --upgrade pip && \
    /opt/${CASA_RELEASE2}/bin/pip3 install astropy && \
#also add astroquery (astroquery.readthedocs.io/en/latest/)
    /opt/${CASA_RELEASE2}/bin/python3 -m pip install --pre astroquery[all]

RUN mkdir /skaha
ADD init.sh /skaha/

# generate missing dbus uuid (issue #47)
RUN dbus-uuidgen --ensure

ADD nsswitch.conf /etc/

WORKDIR /opt
COPY extract-casaviewer.sh .
ENV PYTHONPATH /opt/${CASA_RELEASE2}/lib/py/lib/python3.8/site-packages
RUN bash extract-casaviewer.sh && rm extract-casaviewer.sh

RUN chmod 777 -R /opt/squashfs-root /opt/squashfs-root/usr /opt/squashfs-root/usr/*

CMD [ "/skaha/init.sh" ]
