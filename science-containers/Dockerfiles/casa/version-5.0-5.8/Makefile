VERSIONS = \
#	5.0.0-218.el6 #\
#	5.1.0-74.el6 #\
#	5.1.1-5.el6 #\
#	5.1.2-4.el6 #\
#	5.3.0-143.el6 #\
#	5.4.0-70.el6 #\ 
#	5.4.1-32.el6  #\
#	5.4.2-8.el6  #\
#	5.5.0-149.el6 #\
#	5.6.0-60.el6 #\ 
#	5.7.0-134.el6 #\
#	5.7.2-4.el6 #\
#	5.8.0-109.el6 


VERSIONS_PIPELINE = \
#	5.6.1-8.el6
#	5.6.2-6.el6 #NB: not used in ALMA operations, no longer on CANFAR
#	5.6.3-19.el6 #NB: not used in ALMA operations, no longer on CANFAR


DOCKER_REPO_BASE=images.canfar.net/casa-5/casa

.PHONY: build clean run 

all: build build-pipeline

build: 
	@- $(foreach V,$(VERSIONS), \
                ./download.sh casa-release-$(V) current ; \
                docker build --build-arg CASA_RELEASE=casa-release-$(V) -t ${DOCKER_REPO_BASE}:$(V) .; \
	)

build-pipeline: 
	@- $(foreach V,$(VERSIONS_PIPELINE), \
                ./download.sh casa-pipeline-release-$(V) pipeline ; \
                docker build --build-arg CASA_RELEASE=casa-pipeline-release-$(V) -t ${DOCKER_REPO_BASE}:$(V) .; \
	)


clean:
	@- $(foreach V,$(VERSIONS), \
                docker rmi ${DOCKER_REPO_BASE}:$(V) ; \
	)

clean-pipeline:
	@- $(foreach V,$(VERSIONS_PIPELINE), \
                docker rmi ${DOCKER_REPO_BASE}:$(V) ; \
	)


clean-all: clean clean-pipeline


upload: build
	@- $(foreach V,$(VERSIONS), \
                docker push ${DOCKER_REPO_BASE}:$(V) ; \
	)

upload-pipeline: build-pipeline
	@- $(foreach V,$(VERSIONS_PIPELINE), \
                docker push ${DOCKER_REPO_BASE}:$(V) ; \
	)


upload-all: upload upload-pipeline
