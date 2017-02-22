PROJECT_NAME=almighty-performance
PACKAGE_NAME := github.com/aslakknutsen/almighty-performance
CUR_DIR=$(shell pwd)
TMP_PATH=$(CUR_DIR)/tmp
INSTALL_PREFIX=$(CUR_DIR)/bin
VENDOR_DIR=vendor
WORKSPACE ?= /tmp

# If running in Jenkins we don't allow for interactively running the container
ifneq ($(BUILD_TAG),)
	DOCKER_RUN_INTERACTIVE_SWITCH :=
else
	DOCKER_RUN_INTERACTIVE_SWITCH := -i
endif

DOCKER_IMAGE_CORE := $(PROJECT_NAME)
DOCKER_IMAGE_DEPLOY := $(PROJECT_NAME)

# The BUILD_TAG environment variable will be set by jenkins
# to reflect jenkins-${JOB_NAME}-${BUILD_NUMBER}
BUILD_TAG ?= $(PROJECT_NAME)-local-build
DOCKER_CONTAINER_NAME := $(BUILD_TAG)

# Where is the GOPATH inside the build container?
GOPATH_IN_CONTAINER=/tmp/go
PACKAGE_PATH=$(GOPATH_IN_CONTAINER)/src/$(PACKAGE_NAME)

.PHONY: docker-build
docker-build:
	docker build -t $(DOCKER_IMAGE_CORE) -f $(CUR_DIR)/Dockerfile $(CUR_DIR)

.PHONY: docker-deploy
docker-deploy:
	docker tag $(DOCKER_IMAGE_CORE) registry.ci.centos.org:5000/aslakknutsen/almighty-performance:latest
	docker push registry.ci.centos.org:5000/aslakknutsen/almighty-performance:latest 
