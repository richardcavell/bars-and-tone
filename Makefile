# Makefile
# bars-and-tone by Richard Cavell
# June 2025

ASM		=	asm6809	# by Ciaran Anscomb
SRCFNAME	=	bars_and_tone.asm
CDSKNAME 	=	COCO.DSK
DDSKNAME	=	DRAGON.DSK
CFNAME		=	COCO.BIN
DFNAME		=	DRAGON.BIN
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

.PHONY: all clean disks test-coco test-dragon
.DEFAULT: all

all: $(SINENAME) $(SINEEXEC) $(CFNAME) $(DDNAME) $(CDSKNAME) $(DDSKNAME)

$(SINENAME): $(SINEEXEC)
	@echo "Running" $(SINEEXEC) "..."
	./$(SINEEXEC) $(SINENAME)
	@echo "Done"

$(SINEEXEC): $(SINESRC)
	@echo "Compiling" $(SINEEXEC) "..."
	$(CC) $(CFLAGS) $(LDFLAGS) -o $(SINEEXEC) $(SINESRC) -lm
	@echo "Done"

$(CFNAME): $(SRCFNAME) $(SINENAME)
	@echo "Assembling Coco version..."
	asm6809 -C -o $@ $<
	@echo "Done"

$(DFNAME): $(SRCFNAME) $(SINENAME)
	@echo "Assembling Dragon version..."
	asm6809 -D -o $@ $<
	@echo "Done"


disks: $(CDSKNAME) $(DDSKNAME)

$(CDSKNAME): $(CFNAME)
	@echo "Putting Color Computer disk image together ..."
	decb dskini -3 $(CDSKNAME)
	decb copy -2 -b -r $(FNAME) $(CDSKNAME),$(FNAME)
	@echo "Done"

$(DDSKNAME): $(DFNAME)
	@echo "Putting Dragon computer disk image together..."
	@echo "Done"

# If your rm command doesn't have -v, then remove the @ from the command
# below

clean:
	@rm -v $(SINENAME) $(SINEEXEC) $(CFNAME) $(DFNAME)
	@rm -v $(CDSKNAME) $(DDSKNAME)

test-coco: $(FNAME) $(SRCFNAME) $(SINENAME)
	xroar -machine coco2b -run $(CFNAME)

test-dragon: $(FNAME) $(SRCFNAME) $(SINENAME)
	xroar -machine dragon32 -run $(DFNAME)
