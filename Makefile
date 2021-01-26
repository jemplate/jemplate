SHELL := bash
ROOT := $(shell pwd)
TESTML := .testml
DOCKER-IMAGE := jemplate-dev

export TESTML_RUN := bash-tap
export PATH := $(ROOT)/bin:$(TESTML)/bin:$(PATH)
export PERL5LIB := $(ROOT)/src/compiler/perl5/lib/perl5

test ?= test/*.tml


default:

test: test-compiler test-cli

test-compiler:
	make -C src/compiler test

test-cli: $(TESTML)
	TESTML_DEBUG=$(debug) prove -v $(test)

docker-shell: docker-build
	docker run --rm --interactive --tty \
	    --volume "$(PWD):/jemplate" \
	    --user "$$(id -u $(USER)):$$(id -g $(USER))" \
	    $(DOCKER-IMAGE) \
		bash

docker-build:
	( \
	    cd docker && \
	    docker build --tag=$(DOCKER-IMAGE) . \
	)

clean:
	make -C src/compiler clean
	find $(ROOT) -type d -name .testml | xargs rm -fr
	find $(ROOT) -type d -name __pycache__ | xargs rm -fr
	find $(ROOT) -type f -name '*.pyc' | xargs rm -fr

$(TESTML):
	git clone https://github.com/testml-lang/testml $@
	(cd $@ && make work)
