* bars_and_tone.asm
* by Richard Cavell (richardcavell@mail.com)
* Version 1.0
* June 2025
*
* This program is intended to be assembled by Ciaran Anscomb's asm6809.
*
* Part of this routine was written by Trey Tomes. You can see it here:
* https://treytomes.wordpress.com/2019/12/31/a-rogue-like-in-6809-assembly-pt-2/
* Part of this routine was written by other authors. You can see it here:
* https://github.com/cocotowretro/VideoCompanionCode/blob/main/AsmSound/Notes0.1/src/Notes.asm


	ORG $3000		; Will work on any machine that has 16K+ RAM
				; Will not work with a 4K machine

TEXTSTART	EQU 1024		; Start of text mode buffer
TEXTEND		EQU (TEXTSTART+512)	; End of text mode buffer
AUDIO_PORT_ON	EQU $FF23		; Port Enable Audio (bit 3)
PIA2_CRA	EQU $FF21
DDRA		EQU $FF20
AUDIO_PORT  	EQU $FF20		; (top 6 bits)
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

	ldy #title_screen_text

print_line:
	ldx ,y++		; Load location to copy into

line_loop:
	lda ,y+
	beq next_line

	sta ,x+
	bra line_loop

next_line:
	cmpy #title_screen_text_end
	blt print_line

* Wait for spacebar

poll_keyboard:
	jsr [POLCAT]		; Branch to the address in $A000

	cmpa #' '
	bne poll_keyboard

* Now paint the bars

	ldx #TEXTSTART		; Start of text mode buffer

draw_line:
	ldd #0b1000111110001111	; Do 2 character positions at once,
				; semi-graphics 4, color #1,
				; all 4 elements on for both positions

	ldy #8			; Do this routine 8 times

draw_bar:
	std ,x++		; Store 2 character positions per std
	std ,x++		; So a total of 4

	addd #0b0001000000010000	; Add one to each color code

	leay -1, y
	bne draw_bar

	cmpx #TEXTEND		; Have we reached the end?
	blo  draw_line		; No, do another line

tone:
* This code was modified from code written by Trey Tomes.
	orcc #$50		; Turn off IRQ and FIRQ
	clr  $ff40		; Turn off disk motor

	lda AUDIO_PORT_ON
	ora #0b00001000
	sta AUDIO_PORT_ON ; Turn on audio
* End code written by or modified from code written by Trey Tomes

* This code was written by other people.

	ldb PIA2_CRA
	andb #0b11111011
	stb PIA2_CRA

	lda #0b11111100
	sta DDRA

	orb #0b00000100
	stb PIA2_CRA

* End of code written by other people

start_sending:
	ldx #sine_table

send_value:
	lda ,x+
	sta AUDIO_PORT		; Poke the relevant value into Port Audio

	cmpx #sine_table_end
	blo  send_value

	bra  start_sending	; This program never exits

title_screen_text:

	FDB TEXTSTART + 2 * 32 + 4
	FCV "BARS AND TONE GENERATOR",0

	FDB TEXTSTART + 3 * 32 + 7
	FCV "BY RICHARD CAVELL",0

	FDB TEXTSTART + 5 * 32 + 6
	FCV "HTTPS://GITHUB.COM/",0
	FDB TEXTSTART + 6 * 32 + 2
	FCV "RICHARDCAVELL/BARS-AND-TONE",0

	FDB TEXTSTART + 9 * 32 + 6
	FCV "THE TONE IS MIDDLE C",0

	FDB TEXTSTART + 12 * 32 + 6
	FCV "PRESS SPACE TO BEGIN",0

	FDB TEXTSTART + 13 * 32 + 3
	FCV "POWER OFF OR RESET TO END",0

title_screen_text_end:

sine_table:
	INCLUDE SINE_TABLE
sine_table_end:
