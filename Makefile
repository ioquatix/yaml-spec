SHELL := bash

default:

docker-build-all docker-push-all:
	make -C tool/docker $@

serve publish:
	make -C www $@

clean:
	make -C 1.2 $@
	make -C www $@
