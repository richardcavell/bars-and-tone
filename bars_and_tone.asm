* bars_and_tone.asm
* by Richard Cavell (richardcavell@mail.com)
* June 2025
*
*
* This program is intended to be assembled by Ciaran Anscomb's asm6809.
*
* Part of this routine was written by Trey Tomes. You can see it here:
* https://treytomes.wordpress.com/2019/12/31/a-rogue-like-in-6809-assembly-pt-2/

	ORG $0f00		; Will work on any machine including
				; ones with only 4K RAM

TEXTSTART	EQU 1024		; Start of text mode buffer
TEXTEND		EQU (TEXTSTART+512)	; End of text mode buffer
PORT_EA 	EQU $FF23		; Port Enable Audio (bit 3)
PORT_A  	EQU $FF20		; Port Audio (top 6 bits)
SINE_TABLE	EQU "sine_table.asm"	; A generated sine wave
POLCAT		EQU $A000		; A ROM routine

* Clear the screen

cls:
	ldx #TEXTSTART
	ldd #96*256+96		; Two green blocks

cls_loop:
	std ,x++
	cmpx #TEXTEND
	blt cls_loop

* Print the title screen

first_line:
	ldx #FIRSTLINELOC
	ldy #FIRSTLINE

first_line_loop:
	lda ,y+
	beq second_line

	sta ,x+
	bra first_line_loop

second_line:
	ldx #SECONDLINELOC
	ldy #SECONDLINE

second_line_loop:
	lda ,y+
	beq third_line

	sta ,x+
	bra second_line_loop

third_line:
	ldx #THIRDLINELOC
	ldy #THIRDLINE

third_line_loop:
	lda ,y+
	beq fourth_line

	sta ,x+
	bra third_line_loop

fourth_line:
	ldx #FOURTHLINELOC
	ldy #FOURTHLINE

fourth_line_loop:
	lda ,y+
	beq fifth_line

	sta ,x+
	bra fourth_line_loop

fifth_line:
	ldx #FIFTHLINELOC
	ldy #FIFTHLINE

fifth_line_loop:
	lda ,y+
	beq sixth_line

	sta ,x+
	bra fifth_line_loop

sixth_line:
	ldx #SIXTHLINELOC
	ldy #SIXTHLINE

sixth_line_loop:
	lda ,y+
	beq wait_for_spacebar

	sta ,x+
	bra sixth_line_loop

wait_for_spacebar:
	jsr [POLCAT]		; Branch to the address in $A000

	cmpa #' '
	bne wait_for_spacebar

bars:
	ldx #TEXTSTART		; Start of text mode buffer

start_of_line:
	ldd #0b1000111110001111	; Do 2 character positions at once,
				; semi-graphics 4, color #1,
				; all 4 elements on for both positions

	std ,x++		; Store 2 character positions per std
	std ,x++		; So a total of 4

	addd #0b0001000000010000	; Add one to each color code

	std ,x++		; And store 4 more character positions
	std ,x++

	addd #0b0001000000010000	; Color 3
	std ,x++
	std ,x++

	addd #0b0001000000010000	; Color 4
	std ,x++
	std ,x++

	addd #0b0001000000010000	; Color 5
	std ,x++
	std ,x++

	addd #0b0001000000010000	; Color 6
	std ,x++
	std ,x++

	addd #0b0001000000010000	; Color 7
	std ,x++
	std ,x++

	addd #0b0001000000010000	; Color 8
	std ,x++
	std ,x++

	cmpx #TEXTEND		; Have we reached the end?
	blo  start_of_line	; No, do another line

tone:
; This code was modified from code written by Trey Tomes.
	orcc #$50		; Turn off IRQ and FIRQ
	clr  $ff40		; Turn off disk motor

	lda PORT_EA
	ora #0b00001000
	sta PORT_EA ; Turn on audio
; End code written by or modified from code written by Trey Tomes

start_sending:
	ldx #sine_table

send_value:
	lda ,x+
	sta PORT_A		; Poke the relevant value into Port Audio

	cmpx #sine_table_end
	blo  send_value

	bra  start_sending	; This program never exits

FIRSTLINELOC EQU TEXTSTART + 2 * 32 + 4
FIRSTLINE FCV "BARS AND TONE GENERATOR",0
SECONDLINELOC EQU TEXTSTART + 3 * 32 + 7
SECONDLINE FCV "BY RICHARD CAVELL",0
THIRDLINELOC EQU TEXTSTART + 7 * 32 + 6
THIRDLINE FCV "HTTPS://GITHUB.COM/",0
FOURTHLINELOC EQU TEXTSTART + 8 * 32 + 2
FOURTHLINE  FCV "RICHARDCAVELL/BARS-AND-TONE",0
FIFTHLINELOC EQU TEXTSTART + 12 * 32 + 6
FIFTHLINE FCV "PRESS SPACE TO BEGIN",0
SIXTHLINELOC EQU TEXTSTART + 13 * 32 + 3
SIXTHLINE FCV "POWER OFF OR RESET TO END",0

sine_table:
	INCLUDE SINE_TABLE
sine_table_end:
