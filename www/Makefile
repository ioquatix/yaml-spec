DOCKER_TOOL := github-pages
include ../tool/make/init.mk
include $(ROOT)/tool/make/spec-1.2-files.mk

SPEC := $(ROOT)/spec
STAGE := _stage
PAGES := _gh-pages

DOCKER_OPTS := \
    --publish 4000:4000 \
    --user $(UID):$(GID) \
    --volume $(HISTORY_FILE):/home/jekyll/.bash_history \

CMD ?= bash

FILES := $(shell \
    find . -type f -name '*.md*' | \
    grep -v ReadMe | \
    grep -v /_ \
)
FILES := $(FILES:./%=%)
FILES := $(FILES:%.yaml=%)

FILES := \
    $(FILES) \
    $(ALL_IMAGE:%=img/%) \
    Gemfile \
    _config.yml \
    _layouts \
    \
    spec.css \

FILES := $(FILES:%=$(STAGE)/%)


list-files:
	@printf "%s\n" $(FILES)

build: $(FILES) $(PAGES)

serve: build
	$(eval override export YAML_SPEC_DIR := www/$(STAGE))
	$(call docker-run,run jekyll serve --host 0.0.0.0,$(DOCKER_OPTS))

publish: build
	( \
	    cd $(STAGE) && \
	    git add -A . && \
	    git commit -m 'Publish' && \
	    git push \
	)

shell: build
	$(eval override export YAML_SPEC_DIR := www/$(STAGE))
	$(call docker-run,run $(CMD),$(DOCKER_OPTS))

# Remove generated files to force rebuild:
force: clean-pages clean-stage

# Also remove generated spec/*.md to regenerate those too:
Force FORCE: force force-spec

clean:
	rm -fr $(STAGE) $(PAGES)

clean-pages: $(PAGES)
	$(call clean,$(PAGES))

clean-stage:
	rm -fr $(STAGE)

force-spec:
	make -C $(SPEC) force

$(SPEC)/spec.md:
	make -C $(SPEC) spec.md YAML_SPEC_DIR=

$(STAGE)/%: % $(STAGE)
	cp -pr $< $@

$(STAGE)/%: jekyll/% $(STAGE)
	cp -pr $< $@

$(STAGE)/%.md: %.md $(STAGE)
	cat $< > $@

$(STAGE)/%.md: %.md.yaml $(SPEC)/%.md $(STAGE)
	render-spec-markdown $^ > $@

$(STAGE)/%.png: $(SPEC)/%.png
	cp -p $< $@

$(STAGE)/%.css: %.css $(STAGE)
	cp -pr $< $@

$(STAGE):
	mkdir $@
	mkdir $@/img

$(PAGES):
	-git branch --track gh-pages origin/gh-pages 2>/dev/null
	git worktree add -f $@ gh-pages

define clean
find $1 -mindepth 1 -type f -o -type d | \
    ( grep -Ev '(\.git|ReadMe\.md)' || true) | \
    (set -x; xargs rm -fr x)
endef
