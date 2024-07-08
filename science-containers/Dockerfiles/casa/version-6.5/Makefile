#NB: before using, uncomment the particular version to be built
#NB#2: the extract_casaviewer.sh script also needs to have the correct
# casa version set at the top

#pipeline NB: the directory structure is different than the regular versions:
# the -py3.8 portion is not included when the file is untarred.  
#***For this directory only, when building the pipeline version below, you
# need to additionally uncomment out a line near the top of the Dockerfile
# (noted clearly there)
VERSIONS_PIPELINE = \
#	casa-6.5.4-9-pipeline-2023.1.0.124-py3.8
#	casa-6.5.3-28-pipeline-2023.0.0.36-py3.8 

VERSIONS = \
	casa-6.4.4-31-py3.8
#	casa-6.5.0-15-py3.8
#	casa-6.5.5-21-py3.8
#	casa-6.5.2-26-py3.8
#	casa-6.5.3-28-py3.8
#	casa-6.5.1-23-py3.8
#	casa-6.5.6-22-py3.8 #Incorporated in version-6.6 as the download is different

DOCKER_REPO_BASE=images.canfar.net/casa-6/casa

.PHONY: build clean run 

all: build-pipeline build

build-pipeline: 
	@- $(foreach V,$(VERSIONS_PIPELINE), \
                ./download.sh $(V) pipeline ; \
                docker build --build-arg CASA_RELEASE=$(V) -t ${DOCKER_REPO_BASE}:$(V) .; \
	)

build: 
	@- $(foreach V,$(VERSIONS), \
                ./download.sh $(V) current ; \
                docker build --build-arg CASA_RELEASE=$(V) -t ${DOCKER_REPO_BASE}:$(V) .; \
	)

clean-pipeline:
	@- $(foreach V,$(VERSIONS_PIPELINE), \
                docker rmi ${DOCKER_REPO_BASE}:$(V) ; \
	)

clean:
	@- $(foreach V,$(VERSIONS), \
                docker rmi ${DOCKER_REPO_BASE}:$(V) ; \
	)

clean-all: clean-pipeline clean 

upload-pipeline: build-pipeline
	@- $(foreach V,$(VERSIONS_PIPELINE), \
                docker push ${DOCKER_REPO_BASE}:$(V) ; \
	)

upload: build
	@- $(foreach V,$(VERSIONS), \
                docker push ${DOCKER_REPO_BASE}:$(V) ; \
	)

upload-all: upload-pipeline upload 
