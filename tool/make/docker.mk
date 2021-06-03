DOCKER_DIR ?= .
CMD ?= bash

docker-build: $(DOCKER_DEPS)
	docker build \
	    -t $(DOCKER_IMAGE) \
	    $(DOCKERFILE) \
	    $(DOCKER_DIR)

docker-shell: docker-build
	$(call docker-run,$(CMD))

docker-push: docker-build
	docker push $(DOCKER_IMAGE)

include $(ROOT)/tool/make/docker-run.mk
