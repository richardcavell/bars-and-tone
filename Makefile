# Makefile
# bars-and-tone by Richard Cavell
# June 2025

ASM		=	asm6809	# by Ciaran Anscomb
SRCFNAME	=	bars_and_tone.asm
DSKNAME 	=	BARSTONE.DSK
FNAME		=	BARSTONE.BIN
SINESRC		=	sine_generator.c
SINEEXEC	=	sine_generator
SINENAME 	=	sine_table.out

.PHONY: all clean disk test
.DEFAULT: all

all: $(SINENAME) $(SINEEXEC) $(FNAME) $(DSKNAME)

$(SINENAME): $(SINEEXEC)
	@echo "Running" $(SINEEXEC) "..."
	./$(SINEEXEC) $(SINENAME)
	@echo "Done"

$(SINEEXEC): $(SINESRC)
	@echo "Compiling" $(SINEEXEC) "..."
	gcc -o $(SINEEXEC) $(SINESRC)
	@echo "Done"

$(FNAME): $(SRCFNAME)
	@echo "Assembling..."
	asm6809 -C -o $@ $<
	@echo "Done"

disk: $(DSKNAME)

$(DSKNAME):
	@echo "Putting disk image together ..."
	decb dskini -3 $(DSKNAME)
	decb copy -2 -b -r $(FNAME) $(DSKNAME),$(FNAME)
	@echo "Done"

# If your rm command doesn't have -v, then remove the @ from the command
# below

clean:
	@rm -v $(SINENAME) $(SINEEXEC) $(FNAME) $(DSKNAME)

test: $(FNAME)
	xroar -machine coco2b -run $(FNAME)
