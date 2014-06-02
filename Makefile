MMC=mmc
MCFLAGS=--use-grade-subdirs -O3
# --debug --stack-segments

.PHONY: all clean install sinstall realclean clean-intern libgeneric_math test

test: test_generic_math
	./$^

libgeneric_math: generic_math.m
	$(MMC) $(MCFLAGS) -m $@

test_generic_math: libgeneric_math
	$(MMC) $(MCFLAGS) -m $@

all: test

install: libgeneric_math
	$(MMC) $(MCFLAGS) -m $<.install

sinstall: libgeneric_math
	sudo $(MMC) $(MCFLAGS) -m $<.install

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
