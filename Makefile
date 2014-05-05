ifeq ($(OS),Windows_NT)
    MMC=mercury_compile
else
    MMC=mmc
endif
MCFLAGS=--use-grade-subdirs
# --debug --stack-segments

.PHONY: all clean install sinstall realclean libgeneric_math test

test: test_generic_math
	./$<	

libgeneric_math: generic_math.m
	$(MMC) $(MCFLAGS) -m $@

test_generic_math: libgeneric_math
	$(MMC) $(MCFLAGS) -m $@

all: test

install: libucd
	$(MMC) $(MCFLAGS) -m libgeneric_math.install

sinstall: libucd
	sudo $(MMC) $(MCFLAGS) -m libgeneric_math.install

clean:
	$(MMC) $(MCFLAGS) -m libgeneric_math.clean
	$(MMC) $(MCFLAGS) -m test_generic_math.clean
	rm -fR *.mh
	rm -fR *.err
	rm -fR *.a
	rm -fR *.so
	rm -fR *.dylib
	rm -fR *.dll

realclean: clean
