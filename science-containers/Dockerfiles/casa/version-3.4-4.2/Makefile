# uses python2.6
VERSIONSCASA3 = \
#       34.0.19988-002-64b 

VERSIONS2.6 = \
#	40.0.22208-002-64b \
	40.1.22889-003-64b \
	41.0.24668-001-64b-2

# uses python2.7
VERSIONS = \
	42.0.28322-021-1-64b \
	42.1.29047-001-1-64b \
	42.2.30986-1-64b \
	42.2.30986-pipe-1-64b


DOCKER_REPO_BASE=images.canfar.net/casa-4/casa
DOCKER_REPO_BASE3=images.canfar.net/casa-3/casa

.PHONY: build clean run 

all: build2.6 build3 build

build2.6: 
	@- $(foreach V,$(VERSIONS2.6), \
		./download.sh casapy-$(V); \
		docker build --build-arg CASA_RELEASE=casapy-$(V) --build-arg PYTHON=python2.6 -t ${DOCKER_REPO_BASE}:$(V) .; \
	)

build3: 
	@- $(foreach V,$(VERSIONSCASA3), \
		./download.sh casapy-$(V); \
		docker build --build-arg CASA_RELEASE=casapy-$(V) --build-arg PYTHON=python2.6 -t ${DOCKER_REPO_BASE3}:$(V) .; \
	)
build: 
	@- $(foreach V,$(VERSIONS), \
		./download.sh casapy-$(V); \
		docker build --build-arg CASA_RELEASE=casapy-$(V) --build-arg PYTHON=python2.7 -t ${DOCKER_REPO_BASE}:$(V) .; \
	)

clean2.6:
	@- $(foreach V,$(VERSIONS2.6), \
	  docker rmi ${DOCKER_REPO_BASE}:$(V) ; \
	)
clean3:
	@- $(foreach V,$(VERSIONSCASA3), \
	  docker rmi ${DOCKER_REPO_BASE3}:$(V) ; \
	)

clean:
	@- $(foreach V,$(VERSIONS), \
	  docker rmi ${DOCKER_REPO_BASE}:$(V) ; \
	)


upload2.6: build2.6
	@- $(foreach V,$(VERSIONS2.6), \
	  docker push ${DOCKER_REPO_BASE}:$(V) ; \
	)

upload3: build3
	@- $(foreach V,$(VERSIONSCASA3), \
	  docker push ${DOCKER_REPO_BASE3}:$(V) ; \
	)
upload: build
	@- $(foreach V,$(VERSIONS), \
	  docker push ${DOCKER_REPO_BASE}:$(V) ; \
	)

clean_all: clean2.6 clean3 clean
upload_all: upload2.6 upload3 upload
