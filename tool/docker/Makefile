ALL := $(shell echo */Dockerfile*)
ALL := $(ALL:%/Dockerfile=%)
ALL := $(ALL:%/Dockerfile.yaml=%)

ALL_BUILD := $(ALL:%=%-BUILD)
ALL_PUSH := $(ALL:%=%-PUSH)

default:

docker-build-all: $(ALL_BUILD)

docker-push-all: $(ALL_PUSH)

%-BUILD:
	make -C $(@:%-BUILD=%) docker-build

%-PUSH:
	make -C $(@:%-PUSH=%) docker-push
