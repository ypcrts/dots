.PHONY: all
all: bspwm.out dom0.out season.out

%.out: %.h
	$(CC) -E $< | sed '/^\s*[#!]/d; /^\s*$$/d' >$@

.PHONY: clean
cleanable := $(wildcard *.out)
clean: 
	rm -vf  $(cleanable)
