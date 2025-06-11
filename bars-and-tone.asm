* barstone.asm
* by Richard Cavell
* richardcavell@mail.com
*
* This program is intended to be assembled by Ciaran Anscomb's asm6809.

	ORG $0f00		; Will work on any machine including
				; ones with only 4K RAM

TEXTRAM	EQU 1024
TEXTEND	EQU (TEXTRAM+512)

start:
	ldx #TEXTRAM		; Start of text mode RAM

start_of_line:

	ldd #0b1001111110011111	; Do 2 character positions at once,
				; semi-graphics 4, color #1,
				; all 4 elements on for both positions

poke_4_character_positions:

	std ,x++		; Store 2 character positions per std
	std ,x++		; So a total of 4

				; Add one to the color codes
	addd #0b00001000000010000

				; Do 8 of these
	bvc poke_4_character_positions

				; If we fall through, there has been an
				; overflow, so we are on the next line

	cmpx #TEXTEND		; Have we reached the end?
	blo start_of_line	; No, do another line

finished:
	bra finished
