VERSIONS = \
	4.5.0-el6 #\
#	4.5.1-el6 \
	4.5.2-el6 \
	4.5.3-el6 \
	4.6.0-el6 \
	4.7.0-el6 \
	4.7.1-el6 \
	4.7.2-el6

DOCKER_REPO_BASE=images.canfar.net/casa-4/casa

.PHONY: build clean run 

all: build
build: 
	@- $(foreach V,$(VERSIONS), \
		./download.sh casa-release-$(V) current ; \
		docker build --build-arg CASA_RELEASE=casa-release-$(V) -t ${DOCKER_REPO_BASE}:$(V) .; \
	)

clean:
	@- $(foreach V,$(VERSIONS), \
                docker rmi ${DOCKER_REPO_BASE}:$(V) ; \
	)

clean-all: clean 

upload: build
	@- $(foreach V,$(VERSIONS), \
                docker push ${DOCKER_REPO_BASE}:$(V) ; \
	)

upload-all: upload 
