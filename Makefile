MMC=mmc
SUDO=sudo
MCFLAGS=--use-grade-subdirs -O3
CHMOD=chmod
CHMODFLAGS=644
# --debug --stack-segments

.PHONY: all clean install realclean clean-intern libgeneric_math test

test: test_generic_math
	@for test_case in $^ ; do \
		./$$test_case ; \
	done

libgeneric_math:
	$(MMC) $(MCFLAGS) -m $@

test_generic_math: libgeneric_math
	$(MMC) $(MCFLAGS) -m $@

all: test

install: libgeneric_math
	@for lib in $^ ; do \
		$(SUDO) $(MMC) $(MCFLAGS) -m $$lib.install ; \
		$(SUDO) $(CHMOD) $(CHMODFLAGS) *.jar ;       \
	done

clean-intern:
	rm -fR *.err
	rm -fR *.a
	rm -fR *.so
	rm -fR *.dylib
	rm -fR *.dll
	rm -fR *.beams

clean: clean-intern
	$(MMC) $(MCFLAGS) -m libgeneric_math.clean
	$(MMC) $(MCFLAGS) -m test_generic_math.clean

realclean: clean-intern
	$(MMC) $(MCFLAGS) -m libgeneric_math.realclean
	$(MMC) $(MCFLAGS) -m test_generic_math.realclean
	rm -fR *.init
