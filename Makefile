PERL5MODS := \
    boolean \
    IO::All \
    Pegex \
    Tie::IxHash \
    YAML::PP \
    XXX \

all:
	cpanm -n -L. $(PERL5MODS)
	rm -fr bin
	find lib -type f | grep -v '\.pm$$' | xargs rm -f
	rm -fr \
	    lib/perl5/Module/ \
	    lib/perl5/x86_64-linux/ \
	    lib/perl5/auto/
	find lib -type d -empty | xargs rm -fr

clean:
	rm -fr lib
