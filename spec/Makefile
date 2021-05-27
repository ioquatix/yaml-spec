DOCKER_TOOL := html-to-markdown
include ../tool/make/init.mk
include $(ROOT)/tool/make/spec-1.2-files.mk


SPEC12 := $(ROOT)/1.2

ALL_IMG_IMAGE := $(ALL_IMAGE:%=img/%)
ALL_MD := $(ALL_HTML:%.html=%.md)

ALL := $(ALL_MD) $(ALL_IMG_IMAGE)

build: $(ALL)

force:
ifneq ($(wildcard $(SPEC12)/spec.html),)
	touch $(SPEC12)/spec.html
endif

force-all: force
ifneq ($(wildcard $(SPEC12)/spec.dbk),)
	sleep 0.$$(printf '%04d' $$((10000 - 10#$$(date +%4N))))
	touch $(SPEC12)/spec.dbk
endif

%.md: $(SPEC12)/%.html
	html-to-markdown $^ > $@

$(SPEC12)/%.html: $(SPEC12)/%.dbk
	make -C $(SPEC12) $(@:$(SPEC12)/%=%) YAML_SPEC_DIR=

img/%.png: $(SPEC12)/%.png img
	cp $< $@

img:
	mkdir $@
