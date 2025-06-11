# Makefile
# bars-and-tone by Richard Cavell

ASM   =	asm6809	# by Ciaran Anscomb
FNAME =	BARSTONE.BIN

$(FNAME): bars-and-tone.asm
	@echo "Assembling..."
	@asm6809 -C -o $@ $<
	@echo "Done"

.PHONY: clean test

clean:
	@rm -v $(FNAME)

test:
	@echo "Not implemented yet"

