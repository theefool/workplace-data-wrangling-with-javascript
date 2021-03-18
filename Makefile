DOCKER_DIR := $(CURDIR)/docker
DOCKERFILE ?= $(DOCKER_DIR)/Dockerfile
DOCKER_BUILD_DONE := $(DOCKER_DIR)/.done
DOCKER_IMAGE_NAME := data-wrangling-with-javascript
DOCKER_CONTAINER_NAME := $(DOCKER_IMAGE_NAME)-inst
DOCKER_DETACH_KEY := "ctrl-q,q"
DOCKER_USER := user
DOCKER_RUNNING_CONTAINER := $(shell docker ps | grep $(DOCKER_CONTAINER_NAME))

.PHONY: run build

run: build
ifeq ($(strip $(DOCKER_RUNNING_CONTAINER)),)
	\docker run \
		--rm \
		-it \
		--name $(DOCKER_CONTAINER_NAME) \
		-v $(CURDIR):/work \
		-u $(DOCKER_USER) \
		-p 30000:3000 \
		--detach-keys $(DOCKER_DETACH_KEY) \
		$(DOCKER_IMAGE_NAME)
else
	\docker attach \
		--detach-keys $(DOCKER_DETACH_KEY) \
		$(DOCKER_CONTAINER_NAME)
endif

build: $(DOCKER_BUILD_DONE)
$(DOCKER_BUILD_DONE): $(DOCKERFILE)
	\docker build \
		--tag $(DOCKER_IMAGE_NAME) \
		-f $< \
		$(CURDIR)
	\touch $@

clean:
	$(RM) $(DOCKER_BUILD_DONE)

remove_container:
	\docker rm `docker ps -a | grep $(DOCKER_IMAGE_NAME) | awk '{print $$1}'`

remove_image: clean
	\docker rmi `docker images -a | grep $(DOCKER_IMAGE_NAME) | awk '{print $$3}'`
