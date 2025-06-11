# Makefile
# bars-and-tone by Richard Cavell

ASM	=	asm6809	# by Ciaran Anscomb
DSKNAME =	BARSTONE.DSK
FNAME	=	BARSTONE.BIN

.PHONY: all clean disk test
.DEFAULT: all

all: $(FNAME) $(DSKNAME)

$(FNAME): bars-and-tone.asm
	@echo "Assembling..."
	asm6809 -C -o $@ $<
	@echo "Done"

# If your rm command doesn't have -v, then remove the @ from the command
# below

clean:
	@rm -v $(FNAME) $(DSKNAME)

disk: $(DSKNAME)

$(DSKNAME):
	decb dskini -3 $(DSKNAME)
	decb copy -2 -b -r $(FNAME) $(DSKNAME),$(FNAME)

test:
	xroar -machine coco2b -run $(FNAME)
