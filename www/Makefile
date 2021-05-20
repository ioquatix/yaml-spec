DOCKER_TOOL := github-pages
include ../tool/make/init.mk
include $(ROOT)/tool/make/spec-1.2-files.mk

PUBLISH_CNAME := spec.yaml.io

SPEC := $(ROOT)/spec
STAGE := _stage
PAGES := _gh-pages
LINKS := links.yaml

DOCKER_BUILD_OPTS := \
    --user $(UID):$(GID) \

DOCKER_SERVE_OPTS := \
    $(DOCKER_BUILD_OPTS) \
    --publish 4000:4000 \

DOCKER_SHELL_OPTS := \
    $(DOCKER_SERVE_OPTS) \
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
    spec.css \

FILES := $(FILES:%=$(STAGE)/%)

JEKYLL_BUILD := jekyll build
JEKYLL_SERVE := jekyll serve --host 0.0.0.0


list-files:
	@printf "%s\n" $(FILES)

stage: $(FILES) $(PAGES)

build: stage
	$(eval override export YAML_SPEC_DIR := www/$(STAGE))
	$(call docker-run,run $(JEKYLL_BUILD),$(DOCKER_BUILD_OPTS))
	echo $(PUBLISH_CNAME) > $(PAGES)/CNAME

serve: stage
	$(eval override export YAML_SPEC_DIR := www/$(STAGE))
	$(call docker-run,run $(JEKYLL_SERVE),$(DOCKER_SERVE_OPTS))

shell: stage
	$(eval override export YAML_SPEC_DIR := www/$(STAGE))
	$(call docker-run,run $(CMD),$(DOCKER_SHELL_OPTS))

publish: build
	( \
	    cd $(PAGES) && \
	    git add -A . && \
	    git commit -m 'Publish' && \
	    git push \
	)

# Remove generated files to force rebuild:
force:
	$(call clean,$(PAGES))
	rm -fr $(STAGE)

# Also remove generated spec/*.md to regenerate those too:
force-all: force
	make -C $(SPEC) force

clean:
	rm -fr $(STAGE) $(PAGES)

$(SPEC)/spec.md:
	make -C $(SPEC) spec.md YAML_SPEC_DIR=

$(STAGE)/%: % $(STAGE)
	cp -r $< $@

$(STAGE)/%: jekyll/% $(STAGE)
	cp -r $< $@

$(STAGE)/%.md: %.md $(STAGE)
	cat $< > $@

$(STAGE)/%.md: %.md.yaml $(SPEC)/%.md $(LINKS) $(STAGE)
	render-spec-markdown $^ > $@

$(STAGE)/%.png: $(SPEC)/%.png
	cp $< $@

$(STAGE)/%.css: %.css $(STAGE)
	cp -r $< $@

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
