;GCC for Atari Jaguar GPU/DSP (Feb 21 1995) (C)1994-95 Brainstorm
	MACRO	_RTS
	load	(ST),TMP
	jump	T,(TMP)
	addqt	#4,ST	;rts
	ENDM
_gpugame_start::
	.GPU
	.ORG	$F03000
ST	.REGEQU	r31
TMP	.REGEQU	r16
GT	.CCDEF	$15
gcc2_compiled_for_madmac:
	;(.TEXT)
	.EVEN
_gpu_start::
	movei	#$4000,ST
	movei	#_cpuCmd,r0	;movsi	#_cpuCmd->r0
	moveq	#0,r1	;movsi	#0->r1
	store	r1,(r0)	;movsi	r1->(r0)
	movei	#_cpuData0,r0	;movsi	#_cpuData0->r0
	store	r1,(r0)	;movsi	r1->(r0)
	movei	#_gpu_main,r0	;movsi	#_gpu_main->r0
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r0)
	store	TMP,(ST)	;call	r0
	jr	T,*
	nop	;FOREVER
	.EVEN
_calc_frame_offset::
	move	r0,r3	;movsi	r0->r3
	moveq	#0,r2	;movsi	#0->r2
	subqt	#1,r1	;iaddqtsi3	#-1+r1->r1
	subqt	#1,r2	;iaddqtsi3	#-1+r2->r2
	cmp	r2,r1	;cmpsi	r2,r1
	jr	EQ,L4	;jeq	L4
	moveq	#0,r0	;movsi	#0->r0
L5:
	subqt	#1,r1	;isubqtsi3	r1-#1->r1
	cmp	r2,r1	;cmpsi	r2,r1
	jr	NE,L5	;jne	L5
	add	r3,r0	;iaddsi3	r3+r0->r0
L4:
	_RTS
	.EVEN
_blit_rect::
	subqt	#24,ST
	move	ST,r14
	store	r18,(ST)
	store	r19,(r14+1)
	store	r20,(r14+2)
	store	r21,(r14+3)
	store	r22,(r14+4)
	store	r23,(r14+5)
	move	r0,r18	;movsi	r0->r18
	moveta	r1,R0	;movsi	r1->R0
	move	r2,r22	;movsi	r2->r22
	move	r3,r21	;movsi	r3->r21
	move	r18,r14	;movsi	r18->r14
	move	r4,r20	;movsi	r4->r20
	load	(r14+9),r19	;movsi	(r14+9)->r19
	cmpq	#0,r19	;tstsi	r19
	movei	#L8,TMP
	jump	EQ,(TMP)	;jeq	L8
	move	r5,r23	;movsi	r5->r23
	moveq	#3,r1	;movsi	#3->r1
	move	r20,r0	;movsi	r20->r0
	and	r1,r0	;andsi3	r1&r0->r0
	jr	NE,L11	;jne	L11
	move	r21,r0	;movsi	r21->r0
	and	r1,r0	;andsi3	r1&r0->r0
	jr	EQ,L12
	nop		;jeq	L12
L11:
	bset	#16,r19	;iorsi3	2^#16|r19->r19
L12:
;#APP
	              movei   #$F02238, TMP
.wloop79:     load    (TMP), r0
              btst    #0, r0
              jr      EQ, .wloop79
              nop

;#NO_APP
	move	r18,r14	;movsi	r18->r14
	movei	#_calc_frame_offset,r2	;movsi	#_calc_frame_offset->r2
	load	(r14+7),r0	;movsi	(r14+7)->r0
	movefa	R0,r1	;movsi	R0->r1
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r2)
	store	TMP,(ST)	;call	r2->r0
	move	r18,r14	;movsi	r18->r14
	movei	#15737344,r2	;movsi	#15737344->r2
	load	(r14+8),r1	;movsi	(r14+8)->r1
	movei	#15737348,r3	;movsi	#15737348->r3
	add	r1,r0	;iaddsi3	r1+r0->r0
	movei	#15737356,r4	;movsi	#15737356->r4
	store	r0,(r2)	;movsi	r0->(r2)
	movei	#65535,r1	;movsi	#65535->r1
	move	r20,r0	;movsi	r20->r0
	movei	#15737360,r2	;movsi	#15737360->r2
	store	r19,(r3)	;movsi	r19->(r3)
	neg	r0	;negsi2	r0->r0
	and	r1,r0	;andsi3	r1&r0->r0
	store	r21,(r4)	;movsi	r21->(r4)
	bset	#16,r0	;iorsi3	2^#16|r0->r0
	store	r0,(r2)	;movsi	r0->(r2)
	move	r23,r0	;movsi	r23->r0
	movei	#15737404,r1	;movsi	#15737404->r1
	shlq	#16,r0	;iashlsi3	r0<<#16->r0
	or	r20,r0	;iorsi3	r20|r0->r0
	store	r0,(r1)	;movsi	r0->(r1)
	movei	#15737448,r0	;movsi	#15737448->r0
	store	r22,(r0)	;movsi	r22->(r0)
	movei	#15737452,r0	;movsi	#15737452->r0
	store	r22,(r0)	;movsi	r22->(r0)
	movei	#15737400,r0	;movsi	#15737400->r0
	movei	#66048,r14	;movsi	#66048->r14
	store	r14,(r0)	;movsi	r14->(r0)
	movei	#_blitCount,r1	;movsi	#_blitCount->r1
	load	(r1),r0	;movsi	(r1)->r0
	addqt	#1,r0	;iaddqtsi3	#1+r0->r0
	store	r0,(r1)	;movsi	r0->(r1)
	load	(r1),r0	;movsi	(r1)->r0
L8:
	move	ST,r14
	load	(ST),r18
	load	(r14+1),r19
	load	(r14+2),r20
	load	(r14+3),r21
	load	(r14+4),r22
	load	(r14+5),r23
	addqt	#24,ST
	_RTS
	.EVEN
_blit_color::
	movei	#_blit_rect,r6	;movsi	#_blit_rect->r6
	moveq	#0,r3	;movsi	#0->r3
	movei	#320,r4	;movsi	#320->r4
	movei	#240,r5	;movsi	#240->r5
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r6)
	store	TMP,(ST)	;call	r6
	_RTS
	;(.DATA)
	.LONG
_gctrl_12::
	.DC.L	15737108
	;(.TEXT)
	.EVEN
_run68kCmd::
	movei	#_cpuCmd,r2	;movsi	#_cpuCmd->r2
	store	r0,(r2)	;movsi	r0->(r2)
	movei	#_gctrl_12,r3	;movsi	#_gctrl_12->r3
	load	(r3),r1	;movsi	(r3)->r1
	moveq	#3,r4	;movsi	#3->r4
	store	r4,(r1)	;movsi	r4->(r1)
	cmpq	#5,r0	;cmpsi	#5,r0
	jr	NE,L15	;jne	L15
	moveq	#0,r4	;movsi	#0->r4
	load	(r3),r0	;movsi	(r3)->r0
	store	r4,(r0)	;movsi	r4->(r0)
;#APP
	     nop
     nop

;#NO_APP
	jr	T,L16
	nop		;jt	L16
	.EVEN
L15:
	load	(r2),r0	;movsi	(r2)->r0
	cmpq	#0,r0	;tstsi	r0
	jr	EQ,L16	;jeq	L16
	move	r2,r1	;movsi	r2->r1
L17:
	load	(r1),r0	;movsi	(r1)->r0
	cmpq	#0,r0	;tstsi	r0
	jr	NE,L17
	nop		;jne	L17
L16:
	_RTS
	.EVEN
_ChangeMusicGPU::
	movei	#_cpuData0,r1	;movsi	#_cpuData0->r1
	store	r0,(r1)	;movsi	r0->(r1)
	movei	#_run68kCmd,r2	;movsi	#_run68kCmd->r2
	moveq	#2,r0	;movsi	#2->r0
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r2)
	store	TMP,(ST)	;call	r2
	_RTS
	.EVEN
_SetSpriteList::
	movei	#_cpuData0,r1	;movsi	#_cpuData0->r1
	store	r0,(r1)	;movsi	r0->(r1)
	movei	#_run68kCmd,r2	;movsi	#_run68kCmd->r2
	moveq	#3,r0	;movsi	#3->r0
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r2)
	store	TMP,(ST)	;call	r2
	_RTS
	.EVEN
_int_to_str_gpu::
	movei	#_cpuData0,r2	;movsi	#_cpuData0->r2
	store	r0,(r2)	;movsi	r0->(r2)
	movei	#_cpuData1,r0	;movsi	#_cpuData1->r0
	store	r1,(r0)	;movsi	r1->(r0)
	movei	#_run68kCmd,r2	;movsi	#_run68kCmd->r2
	moveq	#4,r0	;movsi	#4->r0
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r2)
	store	TMP,(ST)	;call	r2
	_RTS
	.EVEN
_make_sprite::
	move	r1,r7	;movsi	r1->r7
	move	r0,r6	;movsi	r0->r6
	move	r4,r1	;movsi	r4->r1
	moveq	#16,r0	;movsi	#16->r0
	cmp	r0,r2	;cmpsi	r0,r2
	jr	NE,L25	;jne	L25
	shlq	#3,r1	;iashlsi3	r1<<#3->r1
	movei	#L26,TMP
	jump	T,(TMP)	;jt	L26
	bset	#13,r1	;iorsi3	2^#13|r1->r1
	.EVEN
L25:
	moveq	#31,r0	;movsi	#31->r0
	addqt	#1,r0	;iaddqtsi3	#1+r0->r0
	cmp	r0,r2	;cmpsi	r0,r2
	jr	NE,L27	;jne	L27
	moveq	#31,r0	;movsi	#31->r0
	movei	#10240,r0	;movsi	#10240->r0
	movei	#L26,TMP
	jump	T,(TMP)	;jt	L26
	or	r0,r1	;iorsi3	r0|r1->r1
	.EVEN
L27:
	addqt	#9,r0	;iaddqtsi3	#9+r0->r0
	cmp	r0,r2	;cmpsi	r0,r2
	jr	NE,L29	;jne	L29
	moveq	#31,r0	;movsi	#31->r0
	movei	#10752,r0	;movsi	#10752->r0
	movei	#L26,TMP
	jump	T,(TMP)	;jt	L26
	or	r0,r1	;iorsi3	r0|r1->r1
	.EVEN
L29:
	addqt	#17,r0	;iaddqtsi3	#17+r0->r0
	cmp	r0,r2	;cmpsi	r0,r2
	jr	NE,L31
	nop		;jne	L31
	movei	#11264,r0	;movsi	#11264->r0
	movei	#L26,TMP
	jump	T,(TMP)	;jt	L26
	or	r0,r1	;iorsi3	r0|r1->r1
	.EVEN
L31:
	movei	#64,r0	;movsi	#64->r0
	cmp	r0,r2	;cmpsi	r0,r2
	jr	NE,L33
	nop		;jne	L33
	movei	#12288,r0	;movsi	#12288->r0
	movei	#L26,TMP
	jump	T,(TMP)	;jt	L26
	or	r0,r1	;iorsi3	r0|r1->r1
	.EVEN
L33:
	movei	#96,r0	;movsi	#96->r0
	cmp	r0,r2	;cmpsi	r0,r2
	jr	NE,L35
	nop		;jne	L35
	movei	#13312,r0	;movsi	#13312->r0
	movei	#L26,TMP
	jump	T,(TMP)	;jt	L26
	or	r0,r1	;iorsi3	r0|r1->r1
	.EVEN
L35:
	movei	#128,r0	;movsi	#128->r0
	cmp	r0,r2	;cmpsi	r0,r2
	jr	NE,L37
	nop		;jne	L37
	movei	#14336,r0	;movsi	#14336->r0
	movei	#L26,TMP
	jump	T,(TMP)	;jt	L26
	or	r0,r1	;iorsi3	r0|r1->r1
	.EVEN
L37:
	movei	#192,r0	;movsi	#192->r0
	cmp	r0,r2	;cmpsi	r0,r2
	jr	NE,L39
	nop		;jne	L39
	movei	#15360,r0	;movsi	#15360->r0
	movei	#L26,TMP
	jump	T,(TMP)	;jt	L26
	or	r0,r1	;iorsi3	r0|r1->r1
	.EVEN
L39:
	movei	#256,r0	;movsi	#256->r0
	cmp	r0,r2	;cmpsi	r0,r2
	jr	NE,L41
	nop		;jne	L41
	movei	#L26,TMP
	jump	T,(TMP)	;jt	L26
	bset	#14,r1	;iorsi3	2^#14|r1->r1
	.EVEN
L41:
	movei	#320,r0	;movsi	#320->r0
	cmp	r0,r2	;cmpsi	r0,r2
	jr	NE,L43
	nop		;jne	L43
	movei	#16896,r0	;movsi	#16896->r0
	movei	#L26,TMP
	jump	T,(TMP)	;jt	L26
	or	r0,r1	;iorsi3	r0|r1->r1
	.EVEN
L43:
	movei	#512,r0	;movsi	#512->r0
	cmp	r0,r2	;cmpsi	r0,r2
	jr	NE,L45
	nop		;jne	L45
	movei	#18432,r0	;movsi	#18432->r0
	jr	T,L26	;jt	L26
	or	r0,r1	;iorsi3	r0|r1->r1
	.EVEN
L45:
	moveq	#0,r1	;movsi	#0->r1
L26:
	move	r6,r14	;movsi	r6->r14
	neg	r4	;negsi2	r4->r4
	store	r1,(r14+9)	;movsi	r1->(r14+9)
	move	r3,r0	;movsi	r3->r0
	store	r7,(r14+8)	;movsi	r7->(r14+8)
	moveq	#0,r8	;movsi	#0->r8
	shlq	#14,r0	;iashlsi3	r0<<#14->r0
	store	r0,(r14+1)	;movsi	r0->(r14+1)
	move	r2,r1	;movsi	r2->r1
	store	r8,(r6)	;movsi	r8->(r6)
	move	r7,r0	;movsi	r7->r0
	sha	r4,r1	;iashlsi3	r1<<r4->r1
	shlq	#8,r0	;iashlsi3	r0<<#8->r0
	neg	r4	;negsi2	r4->r4
	shrq	#3,r1	;lshrsi3	r1>>#3->r1
	mult	r3,r1	;umulhisi3	r3*r1->r1
	store	r0,(r14+2)	;movsi	r0->(r14+2)
	movei	#32,r8	;movsi	#32->r8
	moveq	#6,r0	;movsi	#6->r0
	store	r1,(r14+7)	;movsi	r1->(r14+7)
	sub	r4,r0	;isubsi3	r0-r4->r0
	moveq	#1,r1	;movsi	#1->r1
	sh	r0,r2	;lshrsi3	r2>>r0->r2
	move	r5,r0	;movsi	r5->r0
	and	r1,r0	;andsi3	r1&r0->r0
	store	r8,(r14+5)	;movsi	r8->(r14+5)
	move	r2,r1	;movsi	r2->r1
	shlq	#15,r0	;iashlsi3	r0<<#15->r0
	shrq	#4,r1	;lshrsi3	r1>>#4->r1
	or	r0,r1	;iorsi3	r0|r1->r1
	movei	#512,r8	;movsi	#512->r8
	store	r1,(r14+4)	;movsi	r1->(r14+4)
	move	r4,r0	;movsi	r4->r0
	move	r2,r1	;movsi	r2->r1
	shlq	#12,r0	;iashlsi3	r0<<#12->r0
	bset	#15,r0	;iorsi3	2^#15|r0->r0
	shlq	#18,r1	;iashlsi3	r1<<#18->r1
	or	r1,r0	;iorsi3	r1|r0->r0
	move	r2,r1	;movsi	r2->r1
	store	r8,(r14+6)	;movsi	r8->(r14+6)
	shlq	#28,r1	;iashlsi3	r1<<#28->r1
	or	r1,r0	;iorsi3	r1|r0->r0
	store	r0,(r14+3)	;movsi	r0->(r14+3)
	_RTS
	.EVEN
_set_sprite_frame::
	subqt	#4,ST
	store	r18,(ST)
	move	r0,r18	;movsi	r0->r18
	move	r18,r14	;movsi	r18->r14
	load	(r14+7),r0	;movsi	(r14+7)->r0
	movei	#_calc_frame_offset,r2	;movsi	#_calc_frame_offset->r2
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r2)
	store	TMP,(ST)	;call	r2->r0
	move	r18,r14	;movsi	r18->r14
	load	(r14+8),r1	;movsi	(r14+8)->r1
	add	r1,r0	;iaddsi3	r1+r0->r0
	shlq	#8,r0	;iashlsi3	r0<<#8->r0
	store	r0,(r14+2)	;movsi	r0->(r14+2)
	load	(ST),r18
	addqt	#4,ST
	_RTS
	.EVEN
_init_screen::
	subqt	#32,ST
	subqt	#20,ST
	move	ST,r14
	store	r17,(ST)
	store	r18,(r14+1)
	store	r19,(r14+2)
	store	r20,(r14+3)
	store	r21,(r14+4)
	store	r22,(r14+5)
	store	r23,(r14+6)
	store	r24,(r14+7)
	store	r25,(r14+8)
	store	r26,(r14+9)
	store	r27,(r14+10)
	store	r28,(r14+11)
	store	r29,(r14+12)
	move	r0,r21	;movsi	r0->r21
	move	r1,r22	;movsi	r1->r22
	moveq	#0,r19	;movsi	#0->r19
	moveq	#31,r18	;movsi	#31->r18
	movei	#_blit_rect,r23	;movsi	#_blit_rect->r23
	moveq	#6,r20	;movsi	#6->r20
	movei	#_blit_color,r3	;movsi	#_blit_color->r3
	addqt	#9,r18	;iaddqtsi3	#9+r18->r18
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r3)
	store	TMP,(ST)	;call	r3
	move	r19,r3	;movsi	r19->r3
L74:
	move	r21,r0	;movsi	r21->r0
	move	r22,r1	;movsi	r22->r1
	movei	#1625907433,r2	;movsi	#1625907433->r2
	movei	#241,r4	;movsi	#241->r4
	shlq	#16,r3	;iashlsi3	r3<<#16->r3
	shrq	#11,r3	;lshrsi3	r3>>#11->r3
	addqt	#32,r3	;iaddqtsi3	#32+r3->r3
	addqt	#8,r3	;iaddqtsi3	#8+r3->r3
	moveq	#1,r5	;movsi	#1->r5
	shlq	#16,r3	;iashlsi3	r3<<#16->r3
	or	r18,r3	;iorsi3	r18|r3->r3
	addqt	#1,r19	;iaddqtsi3	#1+r19->r19
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r23)
	store	TMP,(ST)	;call	r23
	cmp	r19,r20	;rcmpsi	r19,r20
	movei	#L74,TMP
	jump	GT,(TMP)	;jgt	L74
	move	r19,r3	;movsi	r19->r3
	moveq	#0,r20	;movsi	#0->r20
	moveq	#31,r18	;movsi	#31->r18
	movei	#2621440,r24	;movsi	#2621440->r24
	movei	#_blit_rect,r23	;movsi	#_blit_rect->r23
	moveq	#7,r19	;movsi	#7->r19
	addqt	#9,r18	;iaddqtsi3	#9+r18->r18
	move	r21,r0	;movsi	r21->r0
L75:
	move	r22,r1	;movsi	r22->r1
	movei	#1625907433,r2	;movsi	#1625907433->r2
	moveq	#1,r4	;movsi	#1->r4
	move	r20,r3	;movhi	r20,r3
	movei	#160,r5	;movsi	#160->r5
	mult	r18,r3	;umulhisi3	r18*r3->r3
	addqt	#32,r3	;iaddqtsi3	#32+r3->r3
	addqt	#8,r3	;iaddqtsi3	#8+r3->r3
	or	r24,r3	;iorsi3	r24|r3->r3
	addqt	#1,r20	;iaddqtsi3	#1+r20->r20
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r23)
	store	TMP,(ST)	;call	r23
	cmp	r20,r19	;rcmpsi	r20,r19
	movei	#L75,TMP
	jump	GT,(TMP)	;jgt	L75
	move	r21,r0	;movsi	r21->r0
	moveq	#31,r20	;movsi	#31->r20
	move	r22,r1	;movsi	r22->r1
	movei	#13434960,r3	;movsi	#13434960->r3
	moveq	#2,r5	;movsi	#2->r5
	movei	#469703679,r18	;movsi	#469703679->r18
	movei	#_blit_rect,r19	;movsi	#_blit_rect->r19
	addqt	#29,r20	;iaddqtsi3	#29+r20->r20
	move	r18,r2	;movsi	r18->r2
	move	r20,r4	;movsi	r20->r4
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r19)
	store	TMP,(ST)	;call	r19
	move	r21,r0	;movsi	r21->r0
	move	r22,r1	;movsi	r22->r1
	move	r18,r2	;movsi	r18->r2
	movei	#14418000,r3	;movsi	#14418000->r3
	move	r20,r4	;movsi	r20->r4
	moveq	#2,r5	;movsi	#2->r5
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r19)
	store	TMP,(ST)	;call	r19
	move	r21,r0	;movsi	r21->r0
	move	r22,r1	;movsi	r22->r1
	move	r18,r2	;movsi	r18->r2
	movei	#13566032,r3	;movsi	#13566032->r3
	moveq	#2,r4	;movsi	#2->r4
	moveq	#13,r5	;movsi	#13->r5
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r19)
	store	TMP,(ST)	;call	r19
	move	r21,r0	;movsi	r21->r0
	move	r22,r1	;movsi	r22->r1
	move	r18,r2	;movsi	r18->r2
	movei	#13566090,r3	;movsi	#13566090->r3
	moveq	#2,r4	;movsi	#2->r4
	moveq	#13,r5	;movsi	#13->r5
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r19)
	store	TMP,(ST)	;call	r19
	move	r21,r0	;movsi	r21->r0
	move	r22,r1	;movsi	r22->r1
	movei	#-136906794,r20	;movsi	#-136906794->r20
	movei	#983110,r3	;movsi	#983110->r3
	movei	#180,r18	;movsi	#180->r18
	moveq	#2,r5	;movsi	#2->r5
	move	r20,r2	;movsi	r20->r2
	move	r18,r4	;movsi	r18->r4
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r19)
	store	TMP,(ST)	;call	r19
	move	r21,r0	;movsi	r21->r0
	move	r22,r1	;movsi	r22->r1
	move	r20,r2	;movsi	r20->r2
	movei	#2293830,r3	;movsi	#2293830->r3
	move	r18,r4	;movsi	r18->r4
	moveq	#2,r5	;movsi	#2->r5
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r19)
	store	TMP,(ST)	;call	r19
;#APP
	              movei   #$F02238, TMP
.wloop572:     load    (TMP), r0
              btst    #0, r0
              jr      EQ, .wloop572
              nop

;#NO_APP
	move	r21,r14	;movsi	r21->r14
	move	r22,r1	;movsi	r22->r1
	load	(r14+7),r0	;movsi	(r14+7)->r0
	movei	#_calc_frame_offset,r18	;movsi	#_calc_frame_offset->r18
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r18)
	store	TMP,(ST)	;call	r18->r0
	movei	#983065,r1	;movsi	#983065->r1
	movei	#_level_str,r2	;movsi	#_level_str->r2
	moveta	r0,R0	;movsi	r0->R0
	movei	#_draw_string_off,r19	;movsi	#_draw_string_off->r19
	move	r21,r0	;movsi	r21->r0
	movefa	R0,r3	;movsi	R0->r3
	moveq	#4,r20	;movsi	#4->r20
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r19)
	store	TMP,(ST)	;call	r19
	move	r21,r14	;movsi	r21->r14
	move	r22,r1	;movsi	r22->r1
	load	(r14+7),r0	;movsi	(r14+7)->r0
	movei	#_square_data,r17	;movsi	#_square_data->r17
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r18)
	store	TMP,(ST)	;call	r18->r0
	movei	#1638440,r1	;movsi	#1638440->r1
	moveta	r0,R0	;movsi	r0->R0
	movei	#_levelnum_str,r2	;movsi	#_levelnum_str->r2
	move	r21,r0	;movsi	r21->r0
	movefa	R0,r3	;movsi	R0->r3
	movei	#_tmp_str,r27	;movsi	#_tmp_str->r27
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r19)
	store	TMP,(ST)	;call	r19
	move	r21,r14	;movsi	r21->r14
	move	r22,r1	;movsi	r22->r1
	load	(r14+7),r0	;movsi	(r14+7)->r0
	moveq	#31,r26	;movsi	#31->r26
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r18)
	store	TMP,(ST)	;call	r18->r0
	movei	#13631513,r1	;movsi	#13631513->r1
	moveta	r0,R0	;movsi	r0->R0
	movei	#_score_str,r2	;movsi	#_score_str->r2
	move	r21,r0	;movsi	r21->r0
	movefa	R0,r3	;movsi	R0->r3
	movei	#_int_to_str_gpu,r29	;movsi	#_int_to_str_gpu->r29
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r19)
	store	TMP,(ST)	;call	r19
	move	r21,r14	;movsi	r21->r14
	move	r22,r1	;movsi	r22->r1
	load	(r14+7),r0	;movsi	(r14+7)->r0
	addqt	#9,r26	;iaddqtsi3	#9+r26->r26
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r18)
	store	TMP,(ST)	;call	r18->r0
	movei	#1310835,r1	;movsi	#1310835->r1
	movei	#_levelname_str,r2	;movsi	#_levelname_str->r2
	moveta	r0,R0	;movsi	r0->R0
	move	r18,r28	;movsi	r18->r28
	move	r21,r0	;movsi	r21->r0
	movefa	R0,r3	;movsi	R0->r3
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r19)
	store	TMP,(ST)	;call	r19
	moveq	#5,r19	;movsi	#5->r19
L77:
	move	r20,r0	;movsi	r20->r0
	movei	#_draw_string_off,r25	;movsi	#_draw_string_off->r25
	move	r20,r1	;movsi	r20->r1
	shlq	#16,r0	;iashlsi3	r0<<#16->r0
	shrq	#11,r0	;lshrsi3	r0>>#11->r0
	addqt	#32,r0	;iaddqtsi3	#32+r0->r0
	shlq	#3,r1	;iashlsi3	r1<<#3->r1
	add	r20,r1	;iaddsi3	r20+r1->r1
	addqt	#21,r0	;iaddqtsi3	#21+r0->r0
	move	r1,r24	;movsi	r1->r24
	move	r0,r23	;movsi	r0->r23
	shlq	#3,r24	;iashlsi3	r24<<#3->r24
	shlq	#16,r23	;iashlsi3	r23<<#16->r23
	move	r19,r0	;movsi	r19->r0
L76:
	shlq	#1,r0	;iashlsi3	r0<<#1->r0
	add	r19,r0	;iaddsi3	r19+r0->r0
	shlq	#2,r0	;iashlsi3	r0<<#2->r0
	add	r24,r0	;iaddsi3	r24+r0->r0
	move	r0,r14	;movsi	r0->r14
	load	(r14+r17),r1	;movsi	(r14+r17)->r1
	move	r27,r0	;movsi	r27->r0
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r29)
	store	TMP,(ST)	;call	r29
	move	r22,r1	;movsi	r22->r1
	move	r19,r2	;movhi	r19,r2
	move	r21,r14	;movsi	r21->r14
	move	r23,r18	;movsi	r23->r18
	mult	r26,r2	;umulhisi3	r26*r2->r2
	addqt	#32,r2	;iaddqtsi3	#32+r2->r2
	addqt	#23,r2	;iaddqtsi3	#23+r2->r2
	load	(r14+7),r0	;movsi	(r14+7)->r0
	or	r2,r18	;iorsi3	r2|r18->r18
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r28)
	store	TMP,(ST)	;call	r28->r0
	move	r18,r1	;movsi	r18->r1
	moveta	r0,R0	;movsi	r0->R0
	move	r27,r2	;movsi	r27->r2
	move	r21,r0	;movsi	r21->r0
	movefa	R0,r3	;movsi	R0->r3
	subqt	#1,r19	;isubqtsi3	r19-#1->r19
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r25)
	store	TMP,(ST)	;call	r25
	cmpq	#0,r19	;tstsi	r19
	movei	#L76,TMP
	jump	PL,(TMP)	;jge	L76
	move	r19,r0	;movsi	r19->r0
	subqt	#1,r20	;isubqtsi3	r20-#1->r20
	cmpq	#0,r20	;tstsi	r20
	movei	#L77,TMP
	jump	PL,(TMP)	;jge	L77
	moveq	#5,r19	;movsi	#5->r19
	move	ST,r14
	load	(ST),r17
	load	(r14+1),r18
	load	(r14+2),r19
	load	(r14+3),r20
	load	(r14+4),r21
	load	(r14+5),r22
	load	(r14+6),r23
	load	(r14+7),r24
	load	(r14+8),r25
	load	(r14+9),r26
	load	(r14+10),r27
	load	(r14+11),r28
	load	(r14+12),r29
	addqt	#32,ST
	addqt	#20,ST
	_RTS
	.EVEN
_myclamp::
	move	r0,r3	;movsi	r0->r3
	load	(r3),r0	;movsi	(r3)->r0
	cmp	r1,r0	;cmpsi	r1,r0
	jr	PL,L81
	nop		;jge	L81
	store	r1,(r3)	;movsi	r1->(r3)
	load	(r3),r0	;movsi	(r3)->r0
L81:
	cmp	r0,r2	;rcmpsi	r0,r2
	jr	GT,L80
	nop		;jgt	L80
	store	r2,(r3)	;movsi	r2->(r3)
L80:
	_RTS
	.EVEN
_gpu_main::
	movei	#92,TMP
	sub	TMP,ST
	move	ST,r14
	store	r17,(ST)
	store	r18,(r14+1)
	store	r19,(r14+2)
	store	r20,(r14+3)
	store	r21,(r14+4)
	store	r22,(r14+5)
	store	r23,(r14+6)
	store	r24,(r14+7)
	store	r25,(r14+8)
	store	r26,(r14+9)
	store	r27,(r14+10)
	store	r28,(r14+11)
	store	r29,(r14+12)
	moveq	#0,r23	;movsi	#0->r23
	moveq	#0,r26	;movsi	#0->r26
	movei	#_win_str,r8	;movsi	#_win_str->r8
	movei	#80,r14	;movsi	#80->r14
	movei	#_screenbmp,r1	;movsi	#_screenbmp->r1
	movei	#320,r2	;movsi	#320->r2
	movei	#240,r3	;movsi	#240->r3
	moveq	#4,r4	;movsi	#4->r4
	moveq	#0,r5	;movsi	#0->r5
	movei	#92,r0	;movsi	#92->r0
	movei	#92,r6	;movsi	#92->r6
	add	ST,r14	;iaddsi3	ST+r14->r14
	add	ST,r0	;iaddsi3	ST+r0->r0
	add	ST,r6	;iaddsi3	ST+r6->r6
	store	r8,(r14)	;movsi	r8->(r14)
	subqt	#4,r0	;isubqtsi3	r0-#4->r0
	moveq	#0,r14	;movsi	#0->r14
	subqt	#8,r6	;isubqtsi3	r6-#8->r6
	store	r14,(r0)	;movsi	r14->(r0)
	moveq	#0,r8	;movsi	#0->r8
	movei	#_spriteData,r24	;movsi	#_spriteData->r24
	store	r8,(r6)	;movsi	r8->(r6)
	movei	#_make_sprite,r20	;movsi	#_make_sprite->r20
	movei	#_animations,r6	;movsi	#_animations->r6
	move	r24,r0	;movsi	r24->r0
	store	r14,(r6)	;movsi	r14->(r6)
	moveq	#1,r22	;movsi	#1->r22
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r20)
	store	TMP,(ST)	;call	r20
	movei	#_spriteData+40,r0	;movsi	#_spriteData+40->r0
	movei	#_jagcrunchbmp,r1	;movsi	#_jagcrunchbmp->r1
	moveq	#31,r2	;movsi	#31->r2
	moveq	#31,r3	;movsi	#31->r3
	moveq	#4,r4	;movsi	#4->r4
	moveq	#1,r5	;movsi	#1->r5
	movei	#_screen_off_x,r18	;movsi	#_screen_off_x->r18
	movei	#_screen_off_y,r19	;movsi	#_screen_off_y->r19
	move	r24,r14	;movsi	r24->r14
	loadw	(r18),r6	;movhi	(r18),r6
	addqt	#9,r2	;iaddqtsi3	#9+r2->r2
	loadw	(r19),r7	;movhi	(r19),r7
	addqt	#1,r3	;iaddqtsi3	#1+r3->r3
	shlq	#16,r6	;iashlsi3	r6<<#16->r6
	sharq	#16,r6	;ashrsi3	r6>>#16->r6
	store	r6,(r14+5)	;movsi	r6->(r14+5)
	shlq	#16,r7	;iashlsi3	r7<<#16->r7
	sharq	#12,r7	;ashrsi3	r7>>#12->r7
	store	r7,(r14+6)	;movsi	r7->(r14+6)
	movei	#_mult_vals,r27	;movsi	#_mult_vals->r27
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r20)
	store	TMP,(ST)	;call	r20
	loadw	(r18),r0	;movhi	(r18),r0
	movei	#_multiple_of,r20	;movsi	#_multiple_of->r20
	loadw	(r19),r1	;movhi	(r19),r1
	movei	#_spriteData+40,r14	;movsi	#_spriteData+40->r14
	shlq	#16,r0	;iashlsi3	r0<<#16->r0
	sharq	#16,r0	;ashrsi3	r0>>#16->r0
	shlq	#16,r1	;iashlsi3	r1<<#16->r1
	addqt	#32,r0	;iaddqtsi3	#32+r0->r0
	sharq	#16,r1	;ashrsi3	r1>>#16->r1
	addqt	#32,r1	;iaddqtsi3	#32+r1->r1
	addqt	#8,r0	;iaddqtsi3	#8+r0->r0
	addqt	#8,r1	;iaddqtsi3	#8+r1->r1
	store	r0,(r14+5)	;movsi	r0->(r14+5)
	movei	#_pick_numbers,r18	;movsi	#_pick_numbers->r18
	shlq	#4,r1	;iashlsi3	r1<<#4->r1
	store	r1,(r14+6)	;movsi	r1->(r14+6)
	move	r24,r0	;movsi	r24->r0
	movei	#_SetSpriteList,r1	;movsi	#_SetSpriteList->r1
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r1)
	store	TMP,(ST)	;call	r1
L83:
	load	(r27),r0	;movsi	(r27)->r0
	load	(r20),r1	;movsi	(r20)->r1
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r18)
	store	TMP,(ST)	;call	r18->r0
	move	r0,r25	;movsi	r0->r25
	cmpq	#0,r25	;tstsi	r25
	jr	EQ,L83	;jeq	L83
	move	r24,r0	;movsi	r24->r0
	moveq	#1,r1	;movsi	#1->r1
	moveq	#0,r2	;movsi	#0->r2
	movei	#_init_screen,r3	;movsi	#_init_screen->r3
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r3)
	store	TMP,(ST)	;call	r3
	move	r24,r0	;movsi	r24->r0
	moveq	#1,r1	;movsi	#1->r1
	movei	#_set_sprite_frame,r2	;movsi	#_set_sprite_frame->r2
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r2)
	store	TMP,(ST)	;call	r2
	movei	#_ticks,r1	;movsi	#_ticks->r1
	load	(r1),r2	;movsi	(r1)->r2
L87:
	load	(r1),r0	;movsi	(r1)->r0
	cmp	r2,r0	;cmpsi	r2,r0
	jr	EQ,L87	;jeq	L87
	move	r24,r0	;movsi	r24->r0
	moveq	#0,r1	;movsi	#0->r1
	moveq	#0,r2	;movsi	#0->r2
	movei	#_init_screen,r3	;movsi	#_init_screen->r3
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r3)
	store	TMP,(ST)	;call	r3
	move	r24,r0	;movsi	r24->r0
	moveq	#0,r1	;movsi	#0->r1
	movei	#_set_sprite_frame,r2	;movsi	#_set_sprite_frame->r2
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r2)
	store	TMP,(ST)	;call	r2
	movei	#_ticks,r1	;movsi	#_ticks->r1
	load	(r1),r2	;movsi	(r1)->r2
L91:
	load	(r1),r0	;movsi	(r1)->r0
	cmp	r2,r0	;cmpsi	r2,r0
	jr	EQ,L91
	nop		;jeq	L91
	movei	#_spriteData+40,r8	;movsi	#_spriteData+40->r8
	cmpq	#0,r25	;tstsi	r25
	movei	#L96,TMP
	jump	EQ,(TMP)	;jeq	L96
	store	r8,(r24)	;movsi	r8->(r24)
	moveq	#31,r8	;movsi	#31->r8
	movei	#72,r14	;movsi	#72->r14
	movei	#92,r17	;movsi	#92->r17
	moveq	#31,r29	;movsi	#31->r29
	movei	#92,r28	;movsi	#92->r28
	moveq	#31,r27	;movsi	#31->r27
	movei	#92,r20	;movsi	#92->r20
	movei	#92,r19	;movsi	#92->r19
	add	ST,r14	;iaddsi3	ST+r14->r14
	add	ST,r17	;iaddsi3	ST+r17->r17
	add	ST,r28	;iaddsi3	ST+r28->r28
	addqt	#9,r29	;iaddqtsi3	#9+r29->r29
	addqt	#8,r27	;iaddqtsi3	#8+r27->r27
	add	ST,r20	;iaddsi3	ST+r20->r20
	store	r8,(r14)	;movsi	r8->(r14)
	add	ST,r19	;iaddsi3	ST+r19->r19
	movei	#72,r14	;movsi	#72->r14
	add	ST,r14	;iaddsi3	ST+r14->r14
	load	(r14),r8	;movsi	(r14)->r8
	subqt	#4,r20	;isubqtsi3	r20-#4->r20
	movei	#72,r14	;movsi	#72->r14
	addqt	#25,r8	;iaddqtsi3	#25+r8->r8
	add	ST,r14	;iaddsi3	ST+r14->r14
	subqt	#6,r17	;isubqtsi3	r17-#6->r17
	store	r8,(r14)	;movsi	r8->(r14)
	subqt	#8,r19	;isubqtsi3	r19-#8->r19
	move	r20,r8	;movsi	r20->r8
	movei	#64,r14	;movsi	#64->r14
	addqt	#2,r8	;iaddqtsi3	#2+r8->r8
	add	ST,r14	;iaddsi3	ST+r14->r14
	store	r8,(r14)	;movsi	r8->(r14)
	subqt	#2,r28	;isubqtsi3	r28-#2->r28
	move	r19,r8	;movsi	r19->r8
	addqt	#2,r8	;iaddqtsi3	#2+r8->r8
	moveq	#31,r14	;movsi	#31->r14
	addqt	#25,r14	;iaddqtsi3	#25+r14->r14
	add	ST,r14	;iaddsi3	ST+r14->r14
	store	r8,(r14)	;movsi	r8->(r14)
L97:
	movei	#_ticks,r1	;movsi	#_ticks->r1
	load	(r1),r2	;movsi	(r1)->r2
L98:
	load	(r1),r0	;movsi	(r1)->r0
	cmp	r2,r0	;cmpsi	r2,r0
	jr	EQ,L98
	nop		;jeq	L98
	abs	r22	;abssi2	r22->r22
	movei	#_update_animations,r0	;movsi	#_update_animations->r0
	subqt	#1,r22	;isubqtsi3	r22-#1->r22
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r0)
	store	TMP,(ST)	;call	r0
	move	r24,r0	;movsi	r24->r0
	moveq	#0,r2	;movsi	#0->r2
	movei	#13566034,r3	;movsi	#13566034->r3
	movei	#72,r14	;movsi	#72->r14
	moveq	#13,r5	;movsi	#13->r5
	movei	#_blit_rect,r8	;movsi	#_blit_rect->r8
	add	ST,r14	;iaddsi3	ST+r14->r14
	shrq	#31,r22	;lshrsi3	r22>>#31->r22
	load	(r14),r4	;movsi	(r14)->r4
	move	r22,r1	;movsi	r22->r1
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r8)
	store	TMP,(ST)	;call	r8
;#APP
	              movei   #$F02238, TMP
.wloop938:     load    (TMP), r0
              btst    #0, r0
              jr      EQ, .wloop938
              nop

;#NO_APP
	move	r24,r14	;movsi	r24->r14
	move	r22,r1	;movsi	r22->r1
	load	(r14+7),r0	;movsi	(r14+7)->r0
	movei	#_calc_frame_offset,r2	;movsi	#_calc_frame_offset->r2
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r2)
	store	TMP,(ST)	;call	r2->r0
	movei	#13631573,r1	;movsi	#13631573->r1
	movei	#_scoreval_str,r2	;movsi	#_scoreval_str->r2
	moveta	r0,R0	;movsi	r0->R0
	movei	#_draw_string_off,r8	;movsi	#_draw_string_off->r8
	move	r24,r0	;movsi	r24->r0
	movefa	R0,r3	;movsi	R0->r3
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r8)
	store	TMP,(ST)	;call	r8
	move	r24,r0	;movsi	r24->r0
	move	r22,r1	;movsi	r22->r1
	movei	#_set_sprite_frame,r2	;movsi	#_set_sprite_frame->r2
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r2)
	store	TMP,(ST)	;call	r2
	movei	#_spinCount,r1	;movsi	#_spinCount->r1
	load	(r1),r0	;movsi	(r1)->r0
	addqt	#1,r0	;iaddqtsi3	#1+r0->r0
	store	r0,(r1)	;movsi	r0->(r1)
	movei	#_u235se_pad1,r0	;movsi	#_u235se_pad1->r0
	load	(r0),r0	;movsi	(r0)->r0
	load	(r0),r21	;movsi	(r0)->r21
	move	r23,r0	;movsi	r23->r0
	xor	r21,r0	;xorsi3	r21^r0->r0
	and	r21,r0	;andsi3	r21&r0->r0
	btst	#21,r0
	movei	#L103,TMP
	jump	EQ,(TMP)
	nop		;jeq	L103
	load	(r19),r0	;movsi	(r19)->r0
	move	r0,r1	;movsi	r0->r1
	load	(r20),r2	;movsi	(r20)->r2
	shlq	#3,r1	;iashlsi3	r1<<#3->r1
	add	r0,r1	;iaddsi3	r0+r1->r1
	move	r2,r0	;movsi	r2->r0
	shlq	#1,r0	;iashlsi3	r0<<#1->r0
	add	r2,r0	;iaddsi3	r2+r0->r0
	movei	#_square_data,r2	;movsi	#_square_data->r2
	shlq	#2,r0	;iashlsi3	r0<<#2->r0
	add	r2,r0	;iaddsi3	r2+r0->r0
	shlq	#3,r1	;iashlsi3	r1<<#3->r1
	add	r0,r1	;iaddsi3	r0+r1->r1
	move	r1,r14	;movsi	r1->r14
	load	(r14+2),r0	;movsi	(r14+2)->r0
	cmpq	#0,r0	;tstsi	r0
	movei	#L103,TMP
	jump	EQ,(TMP)	;jeq	L103
	load	(r14+1),r2	;movsi	(r14+1)->r2
	moveq	#0,r8	;movsi	#0->r8
	cmpq	#0,r2	;tstsi	r2
	movei	#L105,TMP
	jump	NE,(TMP)	;jne	L105
	store	r8,(r14+2)	;movsi	r8->(r14+2)
	movei	#80,r14	;movsi	#80->r14
	movei	#_lose_str,r8	;movsi	#_lose_str->r8
	add	ST,r14	;iaddsi3	ST+r14->r14
	movei	#_mus_main,r0	;movsi	#_mus_main->r0
	store	r8,(r14)	;movsi	r8->(r14)
	movei	#_ChangeMusicGPU,r1	;movsi	#_ChangeMusicGPU->r1
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r1)
	store	TMP,(ST)	;call	r1
	moveq	#0,r14	;movsi	#0->r14
	movei	#L96,TMP
	jump	T,(TMP)	;jt	L96
	store	r14,(r24)	;movsi	r14->(r24)
	.EVEN
L105:
	moveq	#6,r0	;movsi	#6->r0
	movei	#_run68kCmd,r8	;movsi	#_run68kCmd->r8
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r8)
	store	TMP,(ST)	;call	r8
	movei	#_score,r1	;movsi	#_score->r1
	load	(r1),r0	;movsi	(r1)->r0
	addqt	#5,r0	;iaddqtsi3	#5+r0->r0
	store	r0,(r1)	;movsi	r0->(r1)
	movei	#_int_to_str_gpu,r2	;movsi	#_int_to_str_gpu->r2
	load	(r1),r1	;movsi	(r1)->r1
	movei	#_scoreval_str,r0	;movsi	#_scoreval_str->r0
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r2)
	store	TMP,(ST)	;call	r2
	move	r24,r0	;movsi	r24->r0
	moveq	#0,r1	;movsi	#0->r1
	moveq	#0,r2	;movsi	#0->r2
	loadw	(r17),r3	;zextendhisi2	(r17)->r3
	move	r27,r4	;movsi	r27->r4
	moveq	#31,r5	;movsi	#31->r5
	loadw	(r28),r6	;movhi	(r28),r6
	movei	#_blit_rect,r14	;movsi	#_blit_rect->r14
	mult	r29,r6	;umulhisi3	r29*r6->r6
	shlq	#5,r3	;iashlsi3	r3<<#5->r3
	addqt	#32,r3	;iaddqtsi3	#32+r3->r3
	addqt	#32,r6	;iaddqtsi3	#32+r6->r6
	addqt	#9,r3	;iaddqtsi3	#9+r3->r3
	addqt	#9,r6	;iaddqtsi3	#9+r6->r6
	shlq	#16,r3	;iashlsi3	r3<<#16->r3
	or	r6,r3	;iorsi3	r6|r3->r3
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r14)
	store	TMP,(ST)	;call	r14
	move	r24,r0	;movsi	r24->r0
	moveq	#1,r1	;movsi	#1->r1
	moveq	#0,r2	;movsi	#0->r2
	loadw	(r17),r3	;zextendhisi2	(r17)->r3
	move	r27,r4	;movsi	r27->r4
	moveq	#31,r5	;movsi	#31->r5
	loadw	(r28),r6	;movhi	(r28),r6
	movei	#_blit_rect,r8	;movsi	#_blit_rect->r8
	mult	r29,r6	;umulhisi3	r29*r6->r6
	shlq	#5,r3	;iashlsi3	r3<<#5->r3
	addqt	#32,r3	;iaddqtsi3	#32+r3->r3
	addqt	#32,r6	;iaddqtsi3	#32+r6->r6
	addqt	#9,r3	;iaddqtsi3	#9+r3->r3
	addqt	#9,r6	;iaddqtsi3	#9+r6->r6
	shlq	#16,r3	;iashlsi3	r3<<#16->r3
	or	r6,r3	;iorsi3	r6|r3->r3
	subqt	#1,r25	;isubqtsi3	r25-#1->r25
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r8)
	store	TMP,(ST)	;call	r8
	cmpq	#0,r25	;tstsi	r25
	jr	NE,L103
	nop		;jne	L103
	moveq	#0,r14	;movsi	#0->r14
	store	r14,(r24)	;movsi	r14->(r24)
L103:
	movei	#_animations,r0	;movsi	#_animations->r0
	load	(r0),r0	;movsi	(r0)->r0
	btst	#0,r21
	movei	#L107,TMP
	jump	EQ,(TMP)	;jeq	L107
	moveq	#0,r18	;movsi	#0->r18
	cmpq	#0,r0	;tstsi	r0
	movei	#L109,TMP
	jump	NE,(TMP)
	nop		;jne	L109
	load	(r19),r0	;movsi	(r19)->r0
	movei	#L131,TMP
	jump	T,(TMP)	;jt	L131
	subqt	#1,r0	;isubqtsi3	r0-#1->r0
	.EVEN
L107:
	btst	#1,r21
	movei	#L110,TMP
	jump	EQ,(TMP)	;jeq	L110
	cmpq	#0,r0	;tstsi	r0
	movei	#L132,TMP
	jump	NE,(TMP)	;jne	L132
	move	r20,r0	;movsi	r20->r0
	load	(r19),r0	;movsi	(r19)->r0
	addqt	#1,r0	;iaddqtsi3	#1+r0->r0
L131:
	movei	#_animationData,r18	;movsi	#_animationData->r18
	movei	#L109,TMP
	jump	T,(TMP)	;jt	L109
	store	r0,(r19)	;movsi	r0->(r19)
	.EVEN
L110:
	btst	#2,r21
	movei	#L113,TMP
	jump	EQ,(TMP)	;jeq	L113
	cmpq	#0,r0	;tstsi	r0
	movei	#L132,TMP
	jump	NE,(TMP)	;jne	L132
	move	r20,r0	;movsi	r20->r0
	load	(r20),r0	;movsi	(r20)->r0
	subqt	#1,r0	;isubqtsi3	r0-#1->r0
	movei	#_animationData,r18	;movsi	#_animationData->r18
	movei	#L109,TMP
	jump	T,(TMP)	;jt	L109
	store	r0,(r20)	;movsi	r0->(r20)
	.EVEN
L113:
	btst	#3,r21
	jr	EQ,L109	;jeq	L109
	cmpq	#0,r0	;tstsi	r0
	jr	NE,L132	;jne	L132
	move	r20,r0	;movsi	r20->r0
	load	(r20),r0	;movsi	(r20)->r0
	addqt	#1,r0	;iaddqtsi3	#1+r0->r0
	movei	#_animationData,r18	;movsi	#_animationData->r18
	store	r0,(r20)	;movsi	r0->(r20)
L109:
	move	r20,r0	;movsi	r20->r0
L132:
	moveq	#0,r1	;movsi	#0->r1
	moveq	#5,r2	;movsi	#5->r2
	movei	#_myclamp,r8	;movsi	#_myclamp->r8
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r8)
	store	TMP,(ST)	;call	r8
	move	r19,r0	;movsi	r19->r0
	moveq	#0,r1	;movsi	#0->r1
	moveq	#4,r2	;movsi	#4->r2
	movei	#_myclamp,r14	;movsi	#_myclamp->r14
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r14)
	store	TMP,(ST)	;call	r14
	cmpq	#0,r18	;tstsi	r18
	movei	#L118,TMP
	jump	EQ,(TMP)	;jeq	L118
	addqt	#1,r26	;iaddqtsi3	#1+r26->r26
	movei	#_spriteData+40,r8	;movsi	#_spriteData+40->r8
	move	r18,r14	;movsi	r18->r14
	store	r8,(r14+1)	;movsi	r8->(r14+1)
	movei	#64,r8	;movsi	#64->r8
	add	ST,r8	;iaddsi3	ST+r8->r8
	moveq	#31,r0	;movsi	#31->r0
	load	(r8),r14	;movsi	(r8)->r14
	addqt	#9,r0	;iaddqtsi3	#9+r0->r0
	loadw	(r14),r1	;movhi	(r14),r1
	moveq	#31,r8	;movsi	#31->r8
	mult	r0,r1	;umulhisi3	r0*r1->r1
	move	r18,r14	;movsi	r18->r14
	movei	#_screen_off_x,r0	;movsi	#_screen_off_x->r0
	addqt	#32,r1	;iaddqtsi3	#32+r1->r1
	loadw	(r0),r0	;movhi	(r0),r0
	addqt	#8,r1	;iaddqtsi3	#8+r1->r1
	shlq	#16,r0	;iashlsi3	r0<<#16->r0
	sharq	#16,r0	;ashrsi3	r0>>#16->r0
	add	r1,r0	;iaddsi3	r1+r0->r0
	addqt	#25,r8	;iaddqtsi3	#25+r8->r8
	store	r0,(r14+3)	;movsi	r0->(r14+3)
	add	ST,r8	;iaddsi3	ST+r8->r8
	load	(r8),r14	;movsi	(r8)->r14
	loadw	(r14),r1	;zextendhisi2	(r14)->r1
	movei	#_screen_off_y,r0	;movsi	#_screen_off_y->r0
	loadw	(r0),r0	;movhi	(r0),r0
	shlq	#5,r1	;iashlsi3	r1<<#5->r1
	addqt	#32,r1	;iaddqtsi3	#32+r1->r1
	move	r18,r14	;movsi	r18->r14
	shlq	#16,r0	;iashlsi3	r0<<#16->r0
	addqt	#8,r1	;iaddqtsi3	#8+r1->r1
	sharq	#16,r0	;ashrsi3	r0>>#16->r0
	add	r1,r0	;iaddsi3	r1+r0->r0
	store	r0,(r14+4)	;movsi	r0->(r14+4)
	moveq	#4,r8	;movsi	#4->r8
	store	r8,(r14+2)	;movsi	r8->(r14+2)
	movei	#_animations,r0	;movsi	#_animations->r0
	load	(r0),r14	;movsi	(r0)->r14
	store	r14,(r18)	;movsi	r14->(r18)
	store	r18,(r0)	;movsi	r18->(r0)
L118:
	moveq	#29,r0	;movsi	#29->r0
	cmp	r26,r0	;rcmpsi	r26,r0
	movei	#L95,TMP
	jump	HI,(TMP)	;jgtu	L95
	move	r21,r23	;movsi	r21->r23
	moveq	#1,r0	;movsi	#1->r0
	movei	#_run68kCmd,r8	;movsi	#_run68kCmd->r8
	moveq	#0,r26	;movsi	#0->r26
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r8)
	store	TMP,(ST)	;call	r8
L95:
	cmpq	#0,r25	;tstsi	r25
	movei	#L97,TMP
	jump	NE,(TMP)
	nop		;jne	L97
L96:
	move	r24,r0	;movsi	r24->r0
	move	r22,r1	;movsi	r22->r1
	moveq	#0,r2	;movsi	#0->r2
	movei	#_blit_color,r3	;movsi	#_blit_color->r3
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r3)
	store	TMP,(ST)	;call	r3
;#APP
	              movei   #$F02238, TMP
.wloop1226:     load    (TMP), r0
              btst    #0, r0
              jr      EQ, .wloop1226
              nop

;#NO_APP
	move	r24,r14	;movsi	r24->r14
	move	r22,r1	;movsi	r22->r1
	load	(r14+7),r0	;movsi	(r14+7)->r0
	movei	#_calc_frame_offset,r19	;movsi	#_calc_frame_offset->r19
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r19)
	store	TMP,(ST)	;call	r19->r0
	movei	#7209000,r1	;movsi	#7209000->r1
	movei	#80,r8	;movsi	#80->r8
	moveta	r0,R0	;movsi	r0->R0
	movei	#_draw_string_off,r18	;movsi	#_draw_string_off->r18
	add	ST,r8	;iaddsi3	ST+r8->r8
	move	r24,r0	;movsi	r24->r0
	load	(r8),r2	;movsi	(r8)->r2
	movefa	R0,r3	;movsi	R0->r3
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r18)
	store	TMP,(ST)	;call	r18
	movei	#_level_num,r0	;movsi	#_level_num->r0
	load	(r0),r0	;movsi	(r0)->r0
	cmpq	#7,r0	;cmpsi	#7,r0
	movei	#L122,TMP
	jump	HI,(TMP)	;jgtu	L122
	move	r21,r23	;movsi	r21->r23
	move	r24,r14	;movsi	r24->r14
	load	(r14+7),r0	;movsi	(r14+7)->r0
	move	r22,r1	;movsi	r22->r1
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r19)
	store	TMP,(ST)	;call	r19->r0
	movei	#8519720,r1	;movsi	#8519720->r1
	moveta	r0,R0	;movsi	r0->R0
	movei	#_press_c_str,r2	;movsi	#_press_c_str->r2
	move	r24,r0	;movsi	r24->r0
	movefa	R0,r3	;movsi	R0->r3
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r18)
	store	TMP,(ST)	;call	r18
L122:
	movei	#_u235se_pad1,r0	;movsi	#_u235se_pad1->r0
	load	(r0),r2	;movsi	(r0)->r2
	movei	#33554432,r1	;movsi	#33554432->r1
	load	(r2),r21	;movsi	(r2)->r21
	move	r23,r0	;movsi	r23->r0
	xor	r21,r0	;xorsi3	r21^r0->r0
	and	r21,r0	;andsi3	r21&r0->r0
	btst	#25,r0
	jr	NE,L125	;jne	L125
	move	r21,r23	;movsi	r21->r23
L133:
	load	(r2),r21	;movsi	(r2)->r21
	move	r23,r0	;movsi	r23->r0
	xor	r21,r0	;xorsi3	r21^r0->r0
	and	r21,r0	;andsi3	r21&r0->r0
	and	r1,r0	;andsi3	r1&r0->r0
	jr	EQ,L133	;jeq	L133
	move	r21,r23	;movsi	r21->r23
L125:
	cmpq	#0,r25	;tstsi	r25
	jr	EQ,L130	;jeq	L130
	moveq	#0,r8	;movsi	#0->r8
	movei	#_level_num,r0	;movsi	#_level_num->r0
	store	r8,(r0)	;movsi	r8->(r0)
L130:
	moveq	#5,r0	;movsi	#5->r0
	movei	#_run68kCmd,r1	;movsi	#_run68kCmd->r1
	move	PC,TMP
	subqt	#4,ST
	addqt	#10,TMP
	jump	T,(r1)
	store	TMP,(ST)	;call	r1
	move	ST,r14
	load	(ST),r17
	load	(r14+1),r18
	load	(r14+2),r19
	load	(r14+3),r20
	load	(r14+4),r21
	load	(r14+5),r22
	load	(r14+6),r23
	load	(r14+7),r24
	load	(r14+8),r25
	load	(r14+9),r26
	load	(r14+10),r27
	load	(r14+11),r28
	load	(r14+12),r29
	movei	#92,TMP
	add	TMP,ST
	_RTS
	.long
_cpuCmd::	.DCB.B	8,0
	.long
_cpuData0::	.DCB.B	8,0
	.long
_cpuData1::	.DCB.B	8,0
	.LONG
	.68000
_gpugame_end::
_gpugame_size	.EQU	*-_gpugame_start
	.GLOBL	_gpugame_size
	.IF	_gpugame_size>$1000
	.PRINT	"Code size (",/l/x _gpugame_size,") is over $1000"
	.FAIL
	.ENDIF
