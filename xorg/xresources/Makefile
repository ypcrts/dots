.PHONY: all
all: bspwm.out dom0.out

%.out: %.h
	$(CC) -E $< | sed '/^\s*[#!]/d; /^\s*$$/d' >$@

.PHONY: clean
clean:
	rm -vf bspwm.out dom0.out
