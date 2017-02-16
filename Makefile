export DOCKER_IMAGE ?= cloudposse/$(APP)
export DOCKER_TAG ?= dev
export DOCKER_IMAGE_NAME ?= $(DOCKER_IMAGE):$(DOCKER_TAG)
export DOCKER_BUILD_FLAGS = 

SHELL = /bin/bash
export BUILD_HARNESS_PATH ?= $(shell until [ -d "build-harness" ] || [ "`pwd`" == '/' ]; do cd ..; done; pwd)/build-harness
-include $(BUILD_HARNESS_PATH)/Makefile

COPYRIGHT_SOFTWARE_DESCRIPTION := A secure Bastion host implemented as Docker Container running Alpine Linux with Google Authenticator & DUO MFA support

.PHONY : init
## Init build-harness
init:
	@curl --retry 5 --retry-delay 1 https://raw.githubusercontent.com/cloudposse/build-harness/master/bin/install.sh | bash

.PHONY : deps
## Instal deps
deps:
	@exit 0

run: 
	ssh-keygen -R '[localhost]:1234'
	docker run -it -p1234:22 -v ~/.ssh/:/root/.ssh/ --env-file=../.secrets -e MFA_PROVIDER=google-authenticator --entrypoint=/bin/bash $(DOCKER_IMAGE_NAME)
