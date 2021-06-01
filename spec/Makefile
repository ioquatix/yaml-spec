DOCKER_TOOL := html-to-markdown
include ../tool/make/init.mk
include $(ROOT)/tool/make/spec-1.2-files.mk


SPEC12 := $(ROOT)/1.2
LEGEND := $(ROOT)/spec/legend.yaml

ALL_IMG_IMAGE := $(ALL_IMAGE:%=img/%)
ALL_MD := $(ALL_HTML:%.html=%.md)

ALL := $(ALL_MD) $(ALL_IMG_IMAGE)

build: $(ALL)

force:
	touch $(SPEC12)/spec-1.2.html

force-all: force
ifneq ($(wildcard $(SPEC12)/spec.dbk),)
	sleep 0.$$(printf '%04d' $$((10000 - 10#$$(date +%4N))))
	touch $(SPEC12)/spec.dbk
endif

spec.md: $(SPEC12)/spec-1.2.html $(LEGEND)
	html-to-markdown $^ > $@

img/%.png: $(SPEC12)/%.png img
	cp $< $@

img:
	mkdir $@
