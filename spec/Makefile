DOCKER_TOOL := html-to-markdown
include ../tool/make/init.mk
include $(ROOT)/tool/make/spec-1.2-files.mk


SPEC12 := $(ROOT)/1.2

ALL_IMG_IMAGE := $(ALL_IMAGE:%=img/%)
ALL_MD := $(ALL_HTML:%.html=%.md)

ALL := $(ALL_MD) $(ALL_IMG_IMAGE)

build: $(ALL)

force:
	rm -f spec.md

force-all: force
	make -C $(SPEC12) clean

%.md: $(SPEC12)/%.html
	html-to-markdown $^ > $@

$(SPEC12)/%.html:
	make -C $(SPEC12) $(@:$(SPEC12)/%=%) YAML_SPEC_DIR=

img/%.png: $(SPEC12)/%.png img
	cp $< $@

img:
	mkdir $@
