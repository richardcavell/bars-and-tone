* barstone.asm
* by Richard Cavell
* June 2025
*
* richardcavell@mail.com
*
* This program is intended to be assembled by Ciaran Anscomb's asm6809.
*
* Some parts of this routine were written by Trey Tomes.
* https://treytomes.wordpress.com/2019/12/31/a-rogue-like-in-6809-assembly-pt-2/

	ORG $0f00		; Will work on any machine including
				; ones with only 4K RAM

TEXTRAM		EQU 1024		; Start of text mode RAM
TEXTEND		EQU (TEXTRAM+511)	; End of text mode RAM
PORT_EA 	EQU $FF23		; Port Enable Audio (bit 3)
PORT_A  	EQU $FF20		; Port Audio (top 6 bits)
SINE_TABLE	EQU "sine_table.out"	; A generated sine wave

start:
	ldx #TEXTRAM		; Start of text mode RAM

start_of_line:

	ldd #0b1001111110011111	; Do 2 character positions at once,
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

	ldd #0b1000111110001111		; Color 8 (represented by 0)
	std ,x++
	std ,x++

	cmpx #TEXTEND		; Have we reached the end?
	blo  start_of_line	; No, do another line

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

	bra  start_sending

sine_table:
	INCLUDE SINE_TABLE
sine_table_end:
