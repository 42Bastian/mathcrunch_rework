; Copyright 2025 James Jones
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the “Software”), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.

		.include "jaguar.inc"
		.include "u235se/u235se.inc"
		.include "g_gpugame_codesize.inc"

GPUCODE_OFFSET	.equ	(GPUGAME_CODESIZE + 7) & ~7	; Phrase-align this file's code

		.globl	_draw_string_off
		.globl	_gpuasm_start
		.globl	_gpuasm_end
		.globl	_gpuasm_size
		.globl	_gpuasm_dst
		.globl	_update_animations
		.globl	_pick_numbers

		.extern	_animations
		.extern	_square_data

		.text
		.dphrase
_gpuasm_start:
		.gpu
		.org	(G_RAM + GPUCODE_OFFSET)

;ST		.regequ	r18 ; June 1995 compiler build
ST		.regequ	r31 ; February 1995 compiler build
TMP		.regequ	r16

_gpuasm_dst:

; These are all hard-coded from the clr6x12.jft font for now.
CHR_WIDTH	.equ	6
CHR_HEIGHT	.equ	12
FNTWIDTH	.equ	WID96				; WID768 / 8 per comment in drawstring
FNTFIRSTCHR	.equ	$20
FNTLASTCHR	.equ	$7f
zeror		.equr	r6

_draw_string_off:
		; Write a NUL-terminated string to a surface
		;  r0 = sprite:      The sprite surface to draw to
		;  r1 = coords:      The packed coordinates (y<<16)|x
		;  r2 = stringaddr:  Pointer to the NUL-terminated string
		;  r3 = frameoffset: Offset from sprite base address for current frame
		;  fontdata:   The 1bpp font surface
		moveq	#0, zeror			; 0 will be stored in various fields

		move	r0, r14

		movei	#A1_BASE, r15

		load	(r14+8), r0			; Get surface address in r0

		movei	#$88ff88ff, r4
		add	r3, r0				; Add frame offset into r0

		store	r0, (r15)			; Store A1_BASE (destination addr)
		store	r4, (r15+(B_PATD-A1_BASE)/4)			; Store white in B_PATD low dword
		store	zeror, (r15+(A1_CLIP-A1_BASE)/4); Store 0 in A1_CLIP (No clipping)
		store	r4, (r15+(B_PATD-A1_BASE+4)/4)			; Store white in B_PATD high dword

		movei	#XADDPIX|YADD0, r12
		load	(r14+9), r4			; Get sprite blitter flags in r4
		or	r12, r4

		; Add (-CHR_WIDTH, 1) to dst x, y pointers after each inner loop iter
		movei	#(1<<16)|((-CHR_WIDTH)&$ffff), r8

		store	r4, (r15+(A1_FLAGS-A1_BASE)/4)	  ; Store A1_FLAGS
		store	zeror, (r15+(A1_PIXEL-A1_BASE)/4) ; Store 0 in A1_FPIXEL
		store	r8, (r15+(A1_STEP-A1_BASE)/4)			; Store (-CHR_WIDTH, 1) in A1_STEP
		store	zeror, (r15+(A1_FSTEP-A1_BASE)/4)			; Store 0 in A1_FSTEP

		movei	#fontdata, r4

		; Use PIXEL8 even though we're reading 1bit pixels. This, combined
		; with the below SRCENX + !SRCEN command, FNTWIDTH set to actual
		; divided by 8, fixed A2_STEP of -1, 1, and blit width of at most 8
		; is a trick to get the blitter to:
		;  1) Read 8 pixels of data at a time (PIXEL8 instead of PIXEL1)
		;  2) Read source data only once per inner loop iteration (SRCENX)
		;  3) Do bit->pixel expansion even with <8bpp dst pixels
		; which allows using the bit comparator even for 1/2/4bpp dst
		; pixels. Note for fonts with a character width >8, this trick would
		; require multiple blits per character, since the inner loop must be
		; clamped to 8 bits/1 byte given source data is only read once. This
		; case is not implemented here.
		movei	#PITCH1|PIXEL8|FNTWIDTH|XADDPIX|YADD0, r0
		movei	#(1<<16)|((-1)&$ffff), r8

		store	r4, (r15+(A2_BASE-A1_BASE)/4)	; Store fontdata in A2_BASE
		store	r0, (r15+(A2_FLAGS-A1_BASE)/4)			; Store A2_FLAGS
		store	r8, (r15+(A2_STEP-A1_BASE)/4)			; Store (-1, 1) in A2_STEP

		movei	#(CHR_HEIGHT<<16)|CHR_WIDTH, r3

		; The blit loop always starts by adding CHR_WIDTH to the dst
		; position. Subtract CHR_WIDTH from the initial position to account
		; for this.
		subq	#CHR_WIDTH, r1

		; r5 = B_CMD value. Notes:
		;  -1bit pixels need DSTEN,
		;  -SRCENX means read a pixel from src on first inner loop iteration
		;  -!SRCEN means no pixels read on other inner loop iterations
		;  -BCOMPEN uses bitmask to decide which pixels to actually write
		movei	#SRCENX|DSTEN|UPDA1|UPDA2|PATDSEL|BCOMPEN, r5;

		movei	#FNTFIRSTCHR, r8	; Load first char idx of font in r8
		movei	#FNTLASTCHR, r9		; Load last char idx of font in r9

		jr	.nextchr		; Jump into loop
		xor	r11, r11		; clear r11

.blitloop:	store	r7, (r15+(A2_PIXEL-A1_BASE)/4)			; Store src pixel loc in A2_PIXEL
		store	r1, (r15+(A1_PIXEL-A1_BASE)/4)			; Store dst pixel loc in A1_PIXEL
		store	r3, (r15+(B_COUNT-A1_BASE)/4)			; Write loop dimensions to B_COUNT
		store	r5, (r15+(B_CMD-A1_BASE)/4)			; Write op to B_CMD

.nextchr:
		loadb	(r2), r7		; Load next character
		cmpq	#0, r7			; At NUL terminator?
		addqt	#CHR_WIDTH, r1		; Add CHR_WIDTH to dst pixel location
		jr	EQ, .waitlast		; if yes, wait for the last blit
		cmp	r9, r7			; Compare to last char
		addqt	#1, r2			; Always advance string pointer
		jr	HI, .nextchr		; If chr out of range, leave blank space
		sub	r8, r7			; Subtract font first chr from character
		jr	MI, .nextchr		; If chr out of range, leave blank space
//->		nop
.waitblit:	btst	#0, r11			; See if bit 0 is set
		jr	NE, .blitloop		; If done, next iteration
		xor	r11, r11		; Clear r11 for next iteration
		jr	.waitblit		; Else, keep waiting

.waitlast:	; Done. Wait for the last blit...
		load	(r15+(B_CMD-A1_BASE)/4), r11	; In both loops: Read back blit status
		btst	#0, r11				; See if bit 0 is set
		jr	EQ, .waitlast
		nop					; Don't signal completion while spinning

.done:		; Return to the caller.
		load	(ST),TMP
		jump	(TMP)
		addqt	#4,ST	;rts

; This function is a manually-commented version of the Linux gcc263 compiler
; output given the following C code:
;
; static void update_animations(void)
; {
;     int done;
;     int tmpX, tmpY;
;     Animation *a, *prevA;
;
;     for (a = animations; a; a = a->next) {
;         tmpX = GET_SPRITE_X(a->sprite);
;         tmpY = GET_SPRITE_Y(a->sprite);
;         done = 1;
;
;         if (tmpX < a->endX) {
;             tmpX += a->speedPerTick;
;             done = 0;
;         } else if (tmpX > a->endX) {
;             tmpX -= a->speedPerTick;
;             done = 0;
;         }
;
;         if (tmpY < a->endY) {
;             tmpY += a->speedPerTick;
;             done = 0;
;         } else if (tmpY > a->endY) {
;             tmpY -= a->speedPerTick;
;             done = 0;
;         }
;
;         if (done) {
;             if (prevA) {
;                 prevA->next = a->next;
;             } else {
;                 animations = a->next;
;             }
;             a->next = NULL;
;             a->sprite = NULL;
;         } else {
;             SET_SPRITE_X(a->sprite, tmpX);
;             SET_SPRITE_Y(a->sprite, tmpY);
;         }
;     }
; }
;
; With the following changes/fixes:
; -Fix conditions for if (tmp[X,Y] < a->end[X,Y]) ... else if (tmp[X,Y] > a->end[X,Y])
; -Initialize prevA (r6)
; -Set prevA (r6) at end of each loop iteration
; -Set next properly when deleting list entry
; -XXX TODO: Clamp to end[X,Y]

_update_animations:
	movei	#_animations,r7		; r7 = &animations
	load	(r7),r14		; r14 = animations
	cmpq	#0,r14			; if (animations == NULL) goto done;
	movei	#done,TMP
	jump	EQ,(TMP)
	moveq	#0,r6			; prevA = 0

foreach_animation:
	load	(r14+1),r15		; r15 = a->sprite
	load	(r15+5),r1		; r1 = tmpX = a->sprite->x
	load	(r15+6),r3		; r3 = tmpY = a->sprite->y

	load	(r14+3),r4		; r4 = a->endX
	moveq	#1,r5			; r5 = done = 1
	cmp	r4,r1			; if (tmpX >= a->endX) goto check_ltx;
	load	(r14+2),r9		;   r9 = a->speedPerTick
	jr	CC,check_ltx
	shrq	#4,r3			; r3 = tmpY = a->sprite->y >> 4;

					; else { /* tmpX < a->endX */
	moveq	#0,r5			;   r5 = done = 0
	jr	T, done_adj_x		;   tmpX += a->speedPerTick
	add	r9,r1			; }

check_ltx:
	cmp	r1,r4			; Originally: if (a->endX > tmpX)  goto done_adj_x_set
	jr	EQ,done_adj_x_set	; Changed to: if (a->endX == tmpX) goto done_adj_x_set
	nop
					; else { /* tmpX > a->endX */
	moveq	#0,r5			;   r5 = done = 0
	sub	r9,r1			;   tmpX -= a->speedPerTick
					; }
done_adj_x_set:

done_adj_x:
	load	(r14+4),r0		; r0 = a->endY
	cmp	r0,r3			; if (tmpY >= a->endY) goto check_lty;
	jr	CC,check_lty
	nop
					; else { /* tmpY < a->endY */
	movei	#not_done,TMP		;   tmpY += a->speedPerTick
	jump	T,(TMP)			;   goto not_done
	add	r9,r3			; }

check_lty:
	jr	EQ,done_adj_y		; Originally: if (a->endY > tmpY)  goto done_adj_y
					; Changed to: if (a->endY == tmpY) goto done_adj_y
	cmpq	#0,r5			; if (done == 0) goto not_done;

					; else { /* tmpY > a->endY */
	sub	r9,r3			;   tmpY -= a->speedPerTick
	xor	r5,r5			;   r5 = done = 0 (set flags)
					; }
done_adj_y:
	jr	eq,not_done		; (done == 0 ?) => goto
	cmpq	#0,r6			; if (prevA == NULL) goto no_prev
	jr	EQ,no_prev
	load	(r14),r8		;   r8 = a->next
					; else {
	jr	clear_next_sprite	;   prevA->next = a->next
	store	r8,(r6)			;   goto clear_next_sprite;
					; }
no_prev:
	store	r8,(r7)			; animations = a->next
clear_next_sprite:
	moveq	#0,r2			; r8 = 0
	store	r2,(r14)		; a->next = NULL
	store	r2,(r14+1)
	jr	try_next
	move	r8,r14			; a = a->next

not_done:
	load	(r14+1),r15
	shlq	#4,r3
	store	r1,(r15+5)		; a->sprite->x = tmpX
	store	r3,(r15+6)		; a->sprite->y = tmpY << 4
	move	r14, r6			; prevA = a
	load	(r14),r14

try_next:
	cmpq	#0,r14			; if (a = a->next) goto foreach_animation;
	movei	#foreach_animation,TMP
	jump	NE,(TMP)
	nop

done:
	load	(ST),TMP		; RTS
	jump	T,(TMP)
	addqt	#4,ST

; get_rand_entry: Return a random number from a 64-entry table
;
; NOTE: This function does not use the C calling convention for its parameters!
;       However, it does use the regular C call/return mechanism. To ensure no
;       C code tries to call this function by mistake, it does not have a
;       leading underscore in its name.
;
; Parameters:
;   Input:
;   - r14: The 64-entry array of unsigned long values to sample from
;
;   Output:
;   - r13: The randomly-chosen value from the array
;
;   Clobbers:
;   - r11, r10
;
; If adding usage of additional registers, ensure all callers (namely
; _pick_numbers) are updated accordingly.
get_rand_entry:
	movei	#rnd,r13
	load	(r13),r11

	move	r11,r10
	rorq	#7,r10
	xor	r11,r10
	move	r10,r11
	shlq	#9,r10
	xor	r10,r11
	store	r11,(r13)
	shlq	#24,r11
	shrq	#22,r11
	jump	(TMP)
	load	(r14+r11),r13


;;; This is the origina comment, the new assembly routine leverages the fact,
;;; that the elements are linear in the memory.
;;;
; Generate the numbers that will populate the game grid. This is a more or less
; completely hand-coded implementation of this C code:
;
;   unsigned int pick_numbers(const unsigned long *val_array,
;                             unsigned int multiple_of)
;   {
;       int i;
;       int j;
;       unsigned int val;
;       unsigned int is_multiple;
;       unsigned int num_multiples_remaining = 0;
;
;       for (i = 5; i >= 0; i--) {
;           for (j = 6; j >= 0; j--) {
;               val = get_rand_entry(val_array);
;
;               square_data[i][j].val = val;
;
;               is_multiple = ((val % multiple_of) == 0);
;               square_data[i][j].is_multiple = is_multiple;
;               num_multiples_remaining += is_multiple;
;
;               square_data[i][j].is_visible = 1;
;           }
;       }
;   }
;
; It's hand-coded rather than lightly modified like the update_animations()
; function above because in this case the compiler's output was broken so badly
; it wasn't worth trying to preserve much of the original code's structure.
;
; NOTE: This function takes advantage of the fact that the only other function
; it calls is get_rand_entry(), which we know has a non-standard calling
; convention and only touches the registers r12-r14. Hence, if that function is
; modified, this function likely needs to be modified as well. Additionally, if
; this function is modified to call any other functions, it needs to be sure to
; preserve the local registers it uses when making such calls.

FOR_XY	.REGEQU	r12

_pick_numbers:
	move	r0,r14			; r14 = val_array
					; r1 = multiple_of
	movei	#G_REMAIN,r5		; r5 = G_REMAIN
	movei	#get_rand_entry,r6	; r6 = &get_rand_entry
	movei	#_square_data,r15	; r15 = &square_data[0][0]
	moveq	#0,r0			; num_multiples_remaining = 0

	moveq	#6*5,r3			; x*y = 6*5 (one loop for x and y)
	move	pc,FOR_XY
.for_xy:
	move	PC,TMP
	jump	(r6)			; call r13 = get_rand_entry(val_array)
	addqt	#6,TMP

	store	r13, (r15)		; square_data[5-y][6-x].val = r13

	div	r1,r13

	moveq	#1,r2			; is_multiple = 1;
	store	r2,(r15+2)		; square_data[5-y][6-x].is_visible = 1

	; Stall progress until the divide is complete. This is needed to ensure
	; G_REMAIN has been updated based on the latest div result.
	or	r13,r13
	load	(r5),r7

	cmpq	#0,r7			; if ((remainder == 0) || (remainder == -multiple_of))
	jr	EQ,.is_multiple
	add	r1,r7
	jr	EQ,.is_multiple
	nop
	moveq	#0, r2			; is_multiple = 0

.is_multiple:
	store	r2, (r15+1)		; square_data[5-y][6-x].is_multiple = is_multiple

	subq	#1,r3			; x -= 1
	addqt	#12, r15		; r15 = next(square_data)
	jump	NE,(FOR_XY)		; if (x != 0) goto .for_x5_0
	add	r2, r0			; num_multiples_remaining += is_multiple

	load	(ST),TMP		; RTS
	jump	T,(TMP)
	addqt	#4,ST

		.long

rnd:	.dc.l $3543532

		.68000
_gpuasm_end:
_gpuasm_size	.equ	*-_gpuasm_start
		.print	"gpuasm Code size is $",/l/x _gpuasm_size,""
_gpu_total_size	.equ	_gpuasm_size+GPUCODE_OFFSET
		.print	""
		.print	"Total GPU Code size is $",/l/x _gpu_total_size,""
		.print	""

		.if	_gpu_total_size>$1000
		.print	"!!! GPU Code size ($",/l/x _gpu_total_size,") is over $1000!"
		.fail
		.endif

		.data
		.phrase

clr6x12fnt:	.incbin "clr6x12.jft"
fontdata	.equ	(clr6x12fnt+8)		; Font data is after 1 phrase header
