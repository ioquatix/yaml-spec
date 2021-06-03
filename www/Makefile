DOCKER_TOOL := github-pages
include ../tool/make/init.mk
include $(ROOT)/tool/make/spec-1.2-files.mk

PUBLISH_CNAME := spec.yaml.io

SPEC12 := $(ROOT)/1.2
SPEC := $(ROOT)/spec
STAGE := _stage
PAGES := _gh-pages
LINKS := $(ROOT)/spec/links.yaml

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
    spec.scss \
    review.html \
    spec-plain.md \

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
	cp $(PAGES)/spec.html ./

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

$(SPEC)/spec.md: $(SPEC12)/spec-1.2.html
	make -C $(SPEC) spec.md YAML_SPEC_DIR=

$(STAGE)/%: % $(STAGE)
	cp -r $< $@

$(STAGE)/%: jekyll/% $(STAGE)
	cp -r $< $@

$(STAGE)/%.md: %.md $(STAGE)
	cat $< > $@

$(STAGE)/%.md: %.md.yaml $(SPEC)/%.md $(LINKS) $(STAGE)
	render-spec-markdown $^ > $@
	cp $@ ./

$(STAGE)/spec-plain.md: spec-plain.md.yaml $(SPEC)/spec.md $(LINKS) $(STAGE)
	render-spec-markdown $^ > $@

$(STAGE)/%.png: $(SPEC)/%.png
	cp $< $@

$(STAGE)/%.css: %.css $(STAGE)
	cp -r $< $@

$(STAGE): markdown.html
	mkdir $@
	mkdir $@/img
	cp 1.2/* $@/
	cp markdown.html $@/

markdown.html: $(SPEC)/spec.md
	( \
	    echo '<pre>'; \
	    perl -Mstrict -p0 \
		-e 's/&/&amp;/g; s/</&lt;/g; s/>/&gt;/g;' \
		-e 's{^(#.*)}{<code>$$1</code>}gm;' \
		-e 's{^(\*\*(?!Legend).*(\n.*)?\*\*)$$}{<code>$$1</code>}gm' $<; \
	    echo '</pre>' \
	) > $@


$(PAGES):
	-git branch --track gh-pages origin/gh-pages 2>/dev/null
	git worktree add -f $@ gh-pages

define clean
find $1 -mindepth 1 -type f -o -type d | \
    ( grep -Ev '(\.git|ReadMe\.md)' || true) | \
    (set -x; xargs rm -fr x)
endef
