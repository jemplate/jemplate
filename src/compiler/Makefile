SHELL := bash
ROOT := $(shell pwd)
TESTML := ../../.testml

export TESTML_RUN := perl
export PERL_PEGEX_AUTO_COMPILE := 1
export PERL5LIB := perl5/lib/perl5

export PATH := $(ROOT)/$(TESTML)/bin:$(PATH)

.PHONY: test
test: perl5 $(TESTML)
	JEMPLATE_COMPILER_DEBUG=$(debug) prove -v test/*.tml

clean:
	rm -fr perl5
	find . -type d -name .testml | xargs rm -fr
	find ../python -type d -name __pycache__ | xargs rm -fr
	find ../python -type f -name '*.pyc' | xargs rm -fr

grammar: perl5
	perl -Ilib -MJemplate::Compiler::Grammar=compile

perl5:
	git branch --track $@ origin/$@ 2>/dev/null || true
	git worktree add -f $@ $@

$(TESTML):
	make -C ../.. .testml
