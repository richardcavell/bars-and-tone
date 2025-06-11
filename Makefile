# Makefile
# bars-and-tone by Richard Cavell
# June 2025

ASM		=	asm6809	# by Ciaran Anscomb
SRCFNAME	=	bars_and_tone.asm
DSKNAME 	=	BARSTONE.DSK
FNAME		=	BARSTONE.BIN
SINESRC		=	sine_generator.c
SINEEXEC	=	sine_generator
SINENAME 	=	sine_table.asm

# Compilation flags
CC        =  gcc
CFLAGS    = -std=c89 -Wpedantic
CFLAGS   += -Wall -Wextra -Werror -fmax-errors=1
CFLAGS   += -Walloca -Wbad-function-cast -Wcast-align -Wcast-qual -Wconversion
CFLAGS   += -Wdisabled-optimization -Wdouble-promotion -Wduplicated-cond
CFLAGS   += -Werror=format-security -Werror=implicit-function-declaration
CFLAGS   += -Wfloat-equal -Wformat=2 -Wformat-overflow -Wformat-truncation
CFLAGS   += -Wlogical-op -Wmissing-prototypes -Wmissing-declarations
CFLAGS   += -Wno-missing-field-initializers -Wnull-dereference
CFLAGS   += -Woverlength-strings -Wpointer-arith -Wredundant-decls -Wshadow
CFLAGS   += -Wsign-conversion -Wstack-protector -Wstrict-aliasing
CFLAGS   += -Wstrict-overflow -Wswitch-default -Wswitch-enum
CFLAGS   += -Wundef -Wunreachable-code -Wunsafe-loop-optimizations
CFLAGS   += -fstack-protector-strong
CFLAGS   += -g -O2
LDFLAGS   = -Wl,-z,defs -Wl,-O1 -Wl,--gc-sections -Wl,-z,relro

.PHONY: all clean disk test
.DEFAULT: all

all: $(SINENAME) $(SINEEXEC) $(FNAME) $(DSKNAME)

$(SINENAME): $(SINEEXEC)
	@echo "Running" $(SINEEXEC) "..."
	./$(SINEEXEC) $(SINENAME)
	@echo "Done"

$(SINEEXEC): $(SINESRC)
	@echo "Compiling" $(SINEEXEC) "..."
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(SINEEXEC) $(SINESRC) -lm
	@echo "Done"

$(FNAME): $(SRCFNAME) $(SINENAME)
	@echo "Assembling..."
	asm6809 -C -o $@ $<
	@echo "Done"

disk: $(DSKNAME)

$(DSKNAME): $(FNAME)
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
