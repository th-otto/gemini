; Pure-C object:
; magic          = 0x4efa
; headerSize     = 0x001c
; imageBytes     = 0x00007c28
; symInfoBytes   = 0x0000150c
; nameBytes      = 0x000009f8
; versionInfo    = 0x00000000
; debugInfo      = 0x00000000
; reserved1      = 0x00000000
; reserved2      = 0x00000000

~_231:
  move.l     a2,-(a7)
  movea.l    a0,a2
  jsr        strlen
  subq.l     #1,d0
  cmpi.b     #$5C,0(a2,d0.l)
  beq.s      ~_231_1
  lea.l      ~_234,a1
  movea.l    a2,a0
  jsr        strcat
~_231_1:
  movea.l    (a7)+,a2
  rts

~_232:
  move.l     a2,-(a7)
  movea.l    a0,a2
  jsr        strlen
  cmpi.b     #$5C,-1(a2,d0.w)
  bne.s      ~_232_1
  clr.b      -1(a2,d0.w)
~_232_1:
  movea.l    (a7)+,a2
  rts

ClipFindFile:
  movem.l    d3-d4/a2-a4,-(a7)
  lea.l      -12(a7),a7
  movea.l    a0,a4
  movea.l    a1,a2
  movea.l    a1,a0
  jsr        scrp_read
  move.b     (a2),d0
  bne        ClipFindFile_1
  lea.l      ~_234+$00000002,a0
  jsr        getenv
  movea.l    a0,a3
  move.l     a3,d0
  beq.s      ClipFindFile_2
  movea.l    a3,a1
  movea.l    a2,a0
  jsr        strcpy
  bra.s      ClipFindFile_3
ClipFindFile_2:
  lea.l      ~_233,a0
  lea.l      (a7),a1
  moveq.l    #11,d0
ClipFindFile_4:
  move.b     (a0)+,(a1)+
  dbf        d0,ClipFindFile_4
  suba.l     a0,a0
  jsr        Super
  move.l     d0,d3
  move.w     ($00000446).w,d4
  and.w      #$00FF,d4
  movea.l    d3,a0
  jsr        Super
  moveq.l    #65,d0
  add.b      d4,d0
  move.b     d0,(a7)
  lea.l      (a7),a1
  movea.l    a2,a0
  jsr        strcpy
ClipFindFile_3:
  movea.l    a2,a0
  jsr        scrp_write
  suba.l     a0,a0
  moveq.l    #2,d0
  jsr        graf_mouse
  movea.l    a2,a0
  jsr        ~_232(pc)
  movea.l    a2,a0
  jsr        Dcreate
  move.w     d0,d4
  movea.l    a2,a0
  jsr        ~_231(pc)
  suba.l     a0,a0
  clr.w      d0
  jsr        graf_mouse
  tst.w      d4
  bge.s      ClipFindFile_1
  cmp.w      #$FFDC,d4
  beq.s      ClipFindFile_1
  lea.l      ~_234+$00000001,a0
  jsr        scrp_write
  clr.w      d0
  bra.s      ClipFindFile_5
ClipFindFile_1:
  movea.l    a2,a0
  jsr        ~_231(pc)
  lea.l      ~_234+$0000000A,a1
  movea.l    a2,a0
  jsr        strcat
  movea.l    a4,a1
  movea.l    a2,a0
  jsr        strcat
  moveq.l    #1,d0
ClipFindFile_5:
  lea.l      12(a7),a7
  movem.l    (a7)+,d3-d4/a2-a4
  rts

ClipClear:
  movem.l    d3/a3-a6,-(a7)
  lea.l      -172(a7),a7
  movea.l    a0,a6
  lea.l      (a7),a1
  lea.l      ~_234+$00000011,a0
  jsr        ClipFindFile(pc)
  tst.w      d0
  beq.s      ClipClear_1
  jsr        Fgetdta
  movea.l    a0,a3
  lea.l      128(a7),a4
  movea.l    a4,a0
  jsr        Fsetdta
  lea.l      (a7),a0
  jsr        strlen
  lea.l      -1(a7,d0.w),a5
  clr.w      d0
  lea.l      (a7),a0
  jsr        Fsfirst
  move.w     d0,d3
  bra.s      ClipClear_2
ClipClear_5:
  lea.l      36(a4),a1
  movea.l    a5,a0
  jsr        strcpy
  move.l     a6,d0
  beq.s      ClipClear_3
  movea.l    a6,a1
  lea.l      36(a4),a0
  moveq.l    #3,d0
  jsr        strncmp
  tst.w      d0
  beq.s      ClipClear_4
ClipClear_3:
  lea.l      (a7),a0
  jsr        Fdelete
ClipClear_4:
  jsr        Fsnext
  move.w     d0,d3
ClipClear_2:
  tst.w      d3
  beq.s      ClipClear_5
  movea.l    a3,a0
  jsr        Fsetdta
  moveq.l    #1,d0
  bra.s      ClipClear_6
ClipClear_1:
  clr.w      d0
ClipClear_6:
  lea.l      172(a7),a7
  movem.l    (a7)+,d3/a3-a6
  rts

~_235:
  move.l     a2,-(a7)
  move.l     a3,-(a7)
  lea.l      -12(a7),a7
  movea.l    24(a7),a2
  pea.l      8(a7)
  lea.l      14(a7),a1
  move.w     4(a2),d0
  movea.l    (a2),a0
  jsr        ObjcOffset
  addq.w     #4,a7
  lea.l      DialWk,a3
  moveq.l    #1,d1
  move.w     (a3),d0
  jsr        vsf_color
  moveq.l    #2,d1
  move.w     (a3),d0
  jsr        vsf_interior
  moveq.l    #4,d1
  move.w     (a3),d0
  jsr        vsf_style
  moveq.l    #2,d0
  move.w     d0,-(a7)
  lea.l      2(a7),a0
  move.w     14(a2),d2
  move.w     16(a2),d1
  asr.w      #1,d1
  add.w      10(a7),d1
  subq.w     #1,d1
  move.w     12(a7),d0
  jsr        RectAES2VDI
  addq.w     #2,a7
  lea.l      (a7),a0
  move.w     (a3),d0
  jsr        vr_recfl
  moveq.l    #8,d1
  move.w     (a3),d0
  jsr        vsf_style
  clr.w      d0
  lea.l      12(a7),a7
  movea.l    (a7)+,a3
  movea.l    (a7)+,a2
  rts

MenuSet2ThinLine:
  move.l     a2,-(a7)
  movea.l    a0,a2
  ext.l      d0
  move.l     d0,d1
  add.l      d1,d1
  add.l      d0,d1
  lsl.l      #3,d1
  move.w     #$0018,6(a2,d1.l)
  move.l     #~_238,12(a2,d1.l)
  movea.l    (a7)+,a2
  rts

~_236:
  movem.l    d3-d5/a2,-(a7)
  movea.l    a0,a2
  move.w     d0,d3
  move.w     d1,d5
  ext.l      d0
  move.l     d0,d2
  add.l      d2,d2
  add.l      d0,d2
  lsl.l      #3,d2
  move.w     2(a2,d2.l),d4
~_236_3:
  tst.w      d5
  beq.s      ~_236_1
  move.w     HandXSize,d0
  move.w     d4,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  sub.w      d0,20(a2,d1.l)
~_236_1:
  move.w     d4,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  movea.l    12(a2,d0.l),a0
  cmpi.b     #$2D,(a0)
  bne.s      ~_236_2
  movea.l    a2,a0
  move.w     d4,d0
  jsr        MenuSet2ThinLine(pc)
~_236_2:
  move.w     d4,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     0(a2,d0.l),d4
  cmp.w      d4,d3
  bne.s      ~_236_3
  tst.w      d5
  beq.s      ~_236_4
  move.w     HandXSize,d0
  move.w     d4,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  sub.w      d0,20(a2,d1.l)
~_236_4:
  movem.l    (a7)+,d3-d5/a2
  rts

MenuTune:
  movem.l    d3-d5/a2,-(a7)
  movea.l    a0,a2
  move.w     d0,d5
  move.w     2(a2),d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  move.w     0(a2,d1.l),d3
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     2(a2,d0.l),d4
MenuTune_1:
  move.w     d5,d1
  move.w     d4,d0
  movea.l    a2,a0
  jsr        ~_236(pc)
  move.w     d4,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     0(a2,d0.l),d4
  cmp.w      d4,d3
  bne.s      MenuTune_1
  movem.l    (a7)+,d3-d5/a2
  rts

WindUpdate:
  move.l     a2,-(a7)
  lea.l      ~_240,a2
  move.w     d0,d1
  tst.w      d1
  beq.s      WindUpdate_1
  subq.w     #1,d1
  beq.s      WindUpdate_2
  subq.w     #1,d1
  beq.s      WindUpdate_3
  subq.w     #1,d1
  beq.s      WindUpdate_4
  bra.s      WindUpdate_5
WindUpdate_2:
  move.w     (a2),d0
  bne.s      WindUpdate_6
  moveq.l    #1,d0
  jsr        wind_update
WindUpdate_6:
  addq.w     #1,(a2)
  bra.s      WindUpdate_5
WindUpdate_1:
  cmpi.w     #$0001,(a2)
  bne.s      WindUpdate_7
  clr.w      d0
  jsr        wind_update
WindUpdate_7:
  move.w     (a2),d0
  beq.s      WindUpdate_5
  subq.w     #1,(a2)
  bra.s      WindUpdate_5
WindUpdate_4:
  move.w     2(a2),d0
  bne.s      WindUpdate_8
  moveq.l    #3,d0
  jsr        wind_update
WindUpdate_8:
  addq.w     #1,2(a2)
  bra.s      WindUpdate_5
WindUpdate_3:
  cmpi.w     #$0001,2(a2)
  bne.s      WindUpdate_9
  moveq.l    #2,d0
  jsr        wind_update
WindUpdate_9:
  move.w     2(a2),d0
  beq.s      WindUpdate_5
  subq.w     #1,2(a2)
WindUpdate_5:
  movea.l    (a7)+,a2
  rts

WindRestoreControl:
  move.w     ~_240,d0
  beq.s      WindRestoreControl_1
  moveq.l    #1,d0
  jsr        wind_update
WindRestoreControl_1:
  move.w     ~_241,d0
  beq.s      WindRestoreControl_2
  moveq.l    #2,d0
  jsr        wind_update
WindRestoreControl_2:
  rts

~_242:
  move.l     a2,-(a7)
  move.l     a3,-(a7)
  movea.l    a0,a2
  move.w     ~_250,d0
  lea.l      0(a2,d0.w),a3
  moveq.l    #124,d0
  jsr        strchr
  move.l     a0,d0
  beq.s      ~_242_1
  sub.l      a2,d0
  cmp.w      ~_250,d0
  bge.s      ~_242_1
  bra.s      ~_242_2
~_242_1:
  move.w     ~_250,d0
  ext.l      d0
  move.l     d0,-(a7)
  movea.l    a2,a0
  jsr        strlen
  cmp.l      (a7)+,d0
  bcc.s      ~_242_3
  bra.s      ~_242_4
~_242_7:
  cmpi.b     #$20,(a3)
  beq.s      ~_242_5
  cmpi.b     #$2D,(a3)
  bne.s      ~_242_6
~_242_5:
  movea.l    a3,a0
  bra.s      ~_242_2
~_242_6:
  subq.w     #1,a3
~_242_3:
  cmpa.l     a3,a2
  bne.s      ~_242_7
~_242_4:
  suba.l     a0,a0
~_242_2:
  movea.l    (a7)+,a3
  movea.l    (a7)+,a2
  rts

DialAlert:
  movem.l    d3-d7/a2-a6,-(a7)
  lea.l      -150(a7),a7
  movea.l    a0,a2
  move.l     a1,70(a7)
  move.w     d0,d7
  movea.l    194(a7),a4
  clr.w      d3
  move.w     d3,6(a7)
  moveq.l    #1,d5
  lea.l      AlertTree,a5
  lea.l      ~_247,a6
  movea.l    a4,a0
  jsr        strlen
  moveq.l    #100,d1
  cmp.l      d0,d1
  bcs        DialAlert_1
  movea.l    70(a7),a0
  jsr        strlen
  cmp.l      #$000002BC,d0
  bhi        DialAlert_1
  move.l     #$00000320,d0
  movea.l    dialmalloc,a0
  jsr        (a0)
  movea.l    a0,a3
  move.l     a3,d0
  beq        DialAlert_1
  lea.l      700(a3),a1
  move.l     a1,(a7)
  moveq.l    #1,d0
  jsr        WindUpdate
  moveq.l    #3,d0
  jsr        WindUpdate
  movea.l    70(a7),a1
  movea.l    a3,a0
  jsr        strcpy
  movea.l    a4,a1
  movea.l    (a7),a0
  jsr        strcpy
  lea.l      76(a7),a4
  pea.l      (a4)
  pea.l      78(a7)
  movea.l    a4,a1
  movea.l    a4,a0
  jsr        HandScreenSize
  addq.w     #8,a7
  move.w     74(a7),d0
  ext.l      d0
  divs.w     HandXSize,d0
  move.w     d0,106(a6)
  subq.w     #6,106(a6)
  cmpi.w     #$003C,106(a6)
  ble.s      DialAlert_2
  move.w     #$003C,106(a6)
DialAlert_2:
  move.w     #$001C,30(a5)
  move.l     #~_245,36(a5)
  clr.w      44(a5)
  clr.w      46(a5)
  move.w     #$0002,68(a5)
  move.w     #$0001,70(a5)
  move.l     #$00FE1101,60(a5)
  clr.w      d4
  move.w     d4,110(a6)
  move.l     a2,d0
  beq.s      DialAlert_3
  moveq.l    #1,d1
  cmp.l      d0,d1
  bne.s      DialAlert_4
  move.w     #$002A,30(a5)
  move.l     #~_248,36(a5)
  movea.l    96(a6),a0
  movea.l    (a0),a2
  bra.s      DialAlert_5
DialAlert_4:
  move.w     #$0017,30(a5)
  move.l     a2,36(a5)
DialAlert_5:
  move.w     4(a2),d0
  lsl.w      #3,d0
  move.w     d0,110(a6)
  move.w     6(a2),d4
DialAlert_3:
  moveq.l    #1,d0
  move.w     d0,42(a5)
  move.w     d0,40(a5)
  move.w     106(a6),d1
  move.w     110(a6),d2
  ext.l      d2
  divs.w     HandXSize,d2
  sub.w      d2,d1
  move.w     d1,108(a6)
  move.w     106(a6),20(a5)
  move.w     #$000C,22(a5)
  clr.w      16(a5)
  moveq.l    #3,d6
  lea.l      ~_245+$00000001,a1
  movea.l    (a7),a0
  jsr        strtok
  movea.l    a0,a2
  bra.s      DialAlert_6
DialAlert_11:
  move.w     d6,d5
  move.w     d5,4(a5)
  moveq.l    #24,d0
  muls.w     d6,d0
  move.w     d6,-24(a5,d0.w)
  clr.w      0(a5,d0.w)
  move.w     #$0001,22(a5,d0.w)
  moveq.l    #3,d1
  add.w      d7,d1
  cmp.w      d1,d6
  bne.s      DialAlert_7
  moveq.l    #2,d2
  bra.s      DialAlert_8
DialAlert_7:
  clr.w      d2
DialAlert_8:
  or.w       #$0005,d2
  moveq.l    #24,d0
  muls.w     d6,d0
  move.w     d2,8(a5,d0.w)
  move.l     a2,12(a5,d0.w)
  clr.w      10(a5,d0.w)
  move.w     d3,d1
  ext.l      d1
  move.l     d1,-(a7)
  movea.l    a2,a0
  jsr        strlen
  cmp.l      (a7)+,d0
  bls.s      DialAlert_9
  movea.l    a2,a0
  jsr        strlen
  move.l     d0,d3
DialAlert_9:
  lea.l      ~_245+$00000001,a1
  suba.l     a0,a0
  jsr        strtok
  movea.l    a0,a2
  addq.w     #1,d6
DialAlert_6:
  move.l     a2,d0
  beq.s      DialAlert_10
  cmp.w      #$0008,d6
  blt.s      DialAlert_11
DialAlert_10:
  cmp.w      #$0005,d3
  bge.s      DialAlert_12
  moveq.l    #5,d3
DialAlert_12:
  moveq.l    #24,d0
  muls.w     d6,d0
  ori.w      #$0020,-16(a5,d0.w)
  move.l     a3,(a6)
  movea.l    70(a7),a2
  clr.w      d6
  bra        DialAlert_13
DialAlert_17:
  movea.l    a2,a0
  jsr        ~_242(pc)
  movea.l    a0,a4
  move.l     a4,d0
  bne.s      DialAlert_14
  move.w     108(a6),d1
  ext.l      d1
  move.l     d1,-(a7)
  movea.l    a2,a0
  jsr        strlen
  cmp.l      (a7)+,d0
  bcc.s      DialAlert_15
  movea.l    a2,a1
  move.w     d6,d0
  lsl.w      #2,d0
  movea.l    0(a6,d0.w),a0
  jsr        strcpy
  move.w     d6,d0
  lsl.w      #2,d0
  clr.l      4(a6,d0.w)
  moveq.l    #24,d6
  bra        DialAlert_13
DialAlert_15:
  moveq.l    #-1,d0
  add.w      108(a6),d0
  ext.l      d0
  movea.l    a2,a1
  move.w     d6,d1
  lsl.w      #2,d1
  movea.l    0(a6,d1.w),a0
  jsr        strncpy
  move.w     108(a6),d0
  move.w     d6,d1
  lsl.w      #2,d1
  movea.l    0(a6,d1.w),a0
  clr.b      -1(a0,d0.w)
  addq.w     #1,d6
  move.w     108(a6),d0
  move.w     d6,d1
  lsl.w      #2,d1
  movea.l    -4(a6,d1.w),a0
  adda.w     d0,a0
  move.l     a0,0(a6,d1.w)
  move.w     108(a6),d0
  lea.l      -1(a2,d0.w),a1
  movea.l    a1,a2
  bra.s      DialAlert_13
DialAlert_14:
  move.l     a4,d7
  sub.l      a2,d7
  move.w     d7,d0
  ext.l      d0
  movea.l    a2,a1
  move.w     d6,d1
  lsl.w      #2,d1
  movea.l    0(a6,d1.w),a0
  jsr        strncpy
  cmpi.b     #$2D,(a4)
  bne.s      DialAlert_16
  move.w     d6,d0
  lsl.w      #2,d0
  movea.l    0(a6,d0.w),a0
  move.b     #$2D,0(a0,d7.w)
  addq.w     #1,d7
DialAlert_16:
  move.w     d6,d0
  lsl.w      #2,d0
  movea.l    0(a6,d0.w),a0
  clr.b      0(a0,d7.w)
  lea.l      1(a4),a2
  addq.w     #1,d6
  move.w     d6,d0
  lsl.w      #2,d0
  movea.l    -4(a6,d0.w),a0
  lea.l      2(a0,d7.w),a1
  move.l     a1,0(a6,d0.w)
DialAlert_13:
  cmp.w      #$0017,d6
  blt        DialAlert_17
  clr.w      d6
  bra.s      DialAlert_18
DialAlert_22:
  move.w     d6,d0
  lsl.w      #2,d0
  move.l     0(a6,d0.w),d1
  bne.s      DialAlert_19
  move.w     d6,4(a7)
  bra.s      DialAlert_20
DialAlert_19:
  move.w     d6,d0
  lsl.w      #2,d0
  movea.l    0(a6,d0.w),a0
  jsr        strlen
  move.l     d0,d7
  cmp.w      6(a7),d7
  ble.s      DialAlert_21
  move.w     d7,6(a7)
DialAlert_21:
  addq.w     #1,d6
DialAlert_18:
  cmp.w      #$0017,d6
  ble.s      DialAlert_22
DialAlert_20:
  moveq.l    #5,d0
  add.w      4(a7),d0
  move.w     d0,22(a5)
  moveq.l    #-2,d1
  add.w      d0,d1
  muls.w     HandYSize,d1
  cmp.w      d1,d4
  ble.s      DialAlert_23
  move.w     d4,d2
  ext.l      d2
  divs.w     HandYSize,d2
  addq.w     #2,d2
  move.w     d2,22(a5)
DialAlert_23:
  move.w     106(a6),d0
  sub.w      108(a6),d0
  add.w      6(a7),d0
  addq.w     #4,d0
  move.w     d0,20(a5)
  moveq.l    #3,d1
  add.w      d3,d1
  moveq.l    #-2,d2
  add.w      d5,d2
  muls.w     d2,d1
  addq.w     #6,d1
  cmp.w      d1,d0
  bge.s      DialAlert_24
  move.w     d1,20(a5)
DialAlert_24:
  moveq.l    #1,d0
  and.w      20(a5),d0
  beq.s      DialAlert_25
  addq.w     #1,20(a5)
DialAlert_25:
  moveq.l    #3,d6
  bra.s      DialAlert_26
DialAlert_27:
  moveq.l    #1,d0
  add.w      d3,d0
  moveq.l    #24,d1
  muls.w     d6,d1
  move.w     d0,20(a5,d1.w)
  move.w     d5,d2
  sub.w      d6,d2
  addq.w     #1,d2
  moveq.l    #3,d4
  add.w      d3,d4
  muls.w     d4,d2
  move.w     20(a5),d7
  sub.w      d2,d7
  move.w     d7,16(a5,d1.w)
  moveq.l    #-2,d0
  add.w      22(a5),d0
  move.w     d0,18(a5,d1.w)
  addq.w     #1,d6
DialAlert_26:
  cmp.w      d6,d5
  bge.s      DialAlert_27
  move.w     20(a5),d0
  sub.w      68(a5),d0
  add.w      16(a5),d0
  move.w     d0,64(a5)
  clr.w      d6
  bra.s      DialAlert_28
DialAlert_29:
  move.w     d6,d0
  movea.l    a5,a0
  jsr        rsrc_obfix
  addq.w     #1,d6
DialAlert_28:
  cmp.w      #$0008,d6
  blt.s      DialAlert_29
  movea.l    a5,a0
  jsr        ObjcTreeInit
  movea.l    a5,a0
  jsr        DialCenter
  move.w     22(a5),-(a7)
  move.w     20(a5),d2
  move.w     18(a5),d1
  move.w     16(a5),d0
  jsr        RectOnScreen
  addq.w     #2,a7
  tst.w      d0
  bne.s      DialAlert_30
  movea.l    a3,a0
  movea.l    dialfree,a1
  jsr        (a1)
  moveq.l    #2,d0
  jsr        WindUpdate
  clr.w      d0
  jsr        WindUpdate
DialAlert_1:
  moveq.l    #-1,d0
  bra        DialAlert_31
DialAlert_30:
  lea.l      8(a7),a4
  movea.l    a4,a1
  movea.l    a5,a0
  jsr        DialStart
  tst.w      d0
  bne.s      DialAlert_32
  clr.w      -2(a5)
DialAlert_32:
  movea.l    a4,a0
  jsr        DialDraw
  suba.l     a0,a0
  move.w     #$0100,d0
  jsr        GrafMouse
  lea.l      74(a7),a2
  movea.l    a2,a1
  movea.l    a2,a0
  clr.w      d2
  clr.w      d1
  move.w     DialWk,d0
  jsr        vst_alignment
  move.w     16(a5),d7
  add.w      110(a6),d7
  move.w     HandXSize,d0
  add.w      d0,d0
  add.w      d0,d7
  move.w     HandYSize,d4
  add.w      d4,d4
  add.w      18(a5),d4
  clr.w      d6
  bra        DialAlert_33
DialAlert_38:
  move.w     d6,d0
  lsl.w      #2,d0
  movea.l    0(a6,d0.w),a0
  move.b     (a0),d1
  ext.w      d1
  subq.w     #1,d1
  beq.s      DialAlert_34
  subq.w     #1,d1
  beq.s      DialAlert_35
  bra        DialAlert_36
DialAlert_34:
  move.w     d6,d0
  lsl.w      #2,d0
  movea.l    0(a6,d0.w),a0
  addq.w     #1,a0
  move.w     d6,d2
  muls.w     HandYSize,d2
  add.w      d4,d2
  move.l     a0,-(a7)
  move.w     d2,-(a7)
  movea.l    0(a6,d0.w),a0
  jsr        strlen
  moveq.l    #1,d1
  add.w      12(a7),d1
  sub.w      d0,d1
  muls.w     HandXSize,d1
  asr.w      #1,d1
  add.w      d7,d1
  move.w     DialWk,d0
  move.w     (a7)+,d2
  movea.l    (a7)+,a0
  jsr        v_gtext
  bra.s      DialAlert_37
DialAlert_35:
  move.w     d6,d0
  lsl.w      #2,d0
  movea.l    0(a6,d0.w),a0
  addq.w     #1,a0
  move.w     d6,d2
  muls.w     HandYSize,d2
  add.w      d4,d2
  move.l     a0,-(a7)
  move.w     d2,-(a7)
  movea.l    0(a6,d0.w),a0
  jsr        strlen
  moveq.l    #1,d1
  add.w      12(a7),d1
  sub.w      d0,d1
  muls.w     HandXSize,d1
  add.w      d7,d1
  move.w     DialWk,d0
  move.w     (a7)+,d2
  movea.l    (a7)+,a0
  jsr        v_gtext
  bra.s      DialAlert_37
DialAlert_36:
  move.w     d6,d0
  lsl.w      #2,d0
  movea.l    0(a6,d0.w),a0
  move.w     d6,d2
  muls.w     HandYSize,d2
  add.w      d4,d2
  move.w     d7,d1
  move.w     DialWk,d0
  jsr        v_gtext
DialAlert_37:
  addq.w     #1,d6
DialAlert_33:
  cmp.w      4(a7),d6
  blt        DialAlert_38
  movea.l    a2,a1
  movea.l    a2,a0
  moveq.l    #5,d2
  clr.w      d1
  move.w     DialWk,d0
  jsr        vst_alignment
  suba.l     a0,a0
  move.w     #$0101,d0
  jsr        GrafMouse
  lea.l      76(a7),a1
  lea.l      74(a7),a0
  jsr        GrafGetForm
  suba.l     a0,a0
  clr.w      d0
  jsr        GrafMouse
  suba.l     a1,a1
  movea.l    a4,a0
  jsr        DialDo
  move.w     d0,d6
  lea.l      76(a7),a0
  move.w     74(a7),d0
  jsr        GrafMouse
  movea.l    a4,a0
  jsr        DialEnd
  movea.l    a5,a0
  jsr        ObjcRemoveTree
  movea.l    a3,a0
  movea.l    dialfree,a1
  jsr        (a1)
  moveq.l    #2,d0
  jsr        WindUpdate
  clr.w      d0
  jsr        WindUpdate
  moveq.l    #-3,d0
  add.w      d6,d0
DialAlert_31:
  lea.l      150(a7),a7
  movem.l    (a7)+,d3-d7/a2-a6
  rts

DialAnimAlert:
  move.l     a2,-(a7)
  lea.l      ~_248,a2
  clr.w      8(a2)
  move.l     a0,(a2)
  move.l     a1,4(a2)
  move.l     12(a7),-(a7)
  movea.l    #$00000001,a0
  movea.l    12(a7),a1
  jsr        DialAlert(pc)
  addq.w     #4,a7
  movea.l    (a7)+,a2
  rts

DialSuccess:
  move.w     ~_244,d0
  move.w     #$0001,~_244
  rts

~_252:
  movem.l    d3-d4/a2-a3,-(a7)
  move.l     d0,d4
  movea.l    a0,a3
  suba.l     a0,a0
  jsr        Super
  move.l     d0,d3
  movea.l    ($000005A0).w,a2
  movea.l    d3,a0
  jsr        Super
  move.l     a2,d0
  beq.s      ~_252_1
~_252_5:
  cmp.l      (a2),d4
  bne.s      ~_252_2
  move.l     a3,d0
  beq.s      ~_252_3
  move.l     4(a2),(a3)
~_252_3:
  moveq.l    #1,d0
  bra.s      ~_252_4
~_252_2:
  addq.w     #8,a2
  move.l     (a2),d0
  bne.s      ~_252_5
~_252_1:
  clr.w      d0
~_252_4:
  movem.l    (a7)+,d3-d4/a2-a3
  rts

~_253:
  move.w     d3,-(a7)
  move.l     a2,-(a7)
  movea.l    a0,a2
  clr.w      d3
~_253_4:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     6(a2,d0.l),d2
  and.w      #$FF00,d2
  cmp.w      #$1100,d2
  bne.s      ~_253_1
  moveq.l    #18,d0
  move.w     d3,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  and.w      10(a2,d1.l),d0
  cmp.w      #$0012,d0
  bne.s      ~_253_1
  move.w     d3,d0
  bra.s      ~_253_2
~_253_1:
  moveq.l    #32,d0
  move.w     d3,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  and.w      8(a2,d1.l),d0
  beq.s      ~_253_3
  moveq.l    #-1,d0
  bra.s      ~_253_2
~_253_3:
  addq.w     #1,d3
  bra.s      ~_253_4
~_253_2:
  movea.l    (a7)+,a2
  move.w     (a7)+,d3
  rts

~_254:
  move.w     d3,-(a7)
  move.l     a2,-(a7)
  movea.l    a0,a2
  jsr        ~_253(pc)
  move.w     d0,d3
  addq.w     #1,d0
  beq.s      ~_254_1
  move.w     d3,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  andi.w     #$FF7F,8(a2,d1.l)
~_254_1:
  movea.l    (a7)+,a2
  move.w     (a7)+,d3
  rts

~_255:
  move.w     d3,-(a7)
  move.l     a2,-(a7)
  movea.l    a0,a2
  jsr        ~_253(pc)
  move.w     d0,d3
  addq.w     #1,d0
  beq.s      ~_255_1
  move.w     d3,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  ori.w      #$0080,8(a2,d1.l)
~_255_1:
  movea.l    (a7)+,a2
  move.w     (a7)+,d3
  rts

DialExStart:
  movem.l    d3/a2-a4,-(a7)
  movea.l    a0,a2
  movea.l    a1,a3
  move.l     a0,(a1)
  clr.w      32(a3)
  move.w     16(a2),24(a3)
  move.w     18(a2),26(a3)
  move.w     20(a2),28(a3)
  move.w     22(a2),30(a3)
  move.w     6(a2),d0
  and.w      #$00FF,d0
  moveq.l    #16,d1
  and.w      10(a2),d1
  beq.s      DialExStart_1
  move.w     #$0003,32(a3)
DialExStart_1:
  moveq.l    #32,d1
  and.w      10(a2),d1
  beq.s      DialExStart_2
  addq.w     #2,30(a3)
  addq.w     #2,28(a3)
DialExStart_2:
  cmp.w      #$0014,d0
  beq.s      DialExStart_3
  cmp.w      #$0019,d0
  bne.s      DialExStart_4
DialExStart_3:
  move.w     12(a2),d0
  lsl.w      #8,d0
  asr.w      #8,d0
  tst.w      d0
  bge.s      DialExStart_4
  sub.w      d0,32(a3)
DialExStart_4:
  move.w     32(a3),d0
  sub.w      d0,24(a3)
  move.w     32(a3),d0
  sub.w      d0,26(a3)
  lsl.w      32(a3)
  move.w     32(a3),d0
  add.w      d0,28(a3)
  move.w     32(a3),d0
  add.w      d0,30(a3)
  asr.w      32(a3)
  lea.l      4(a3),a0
  move.w     30(a3),d1
  move.w     28(a3),d0
  jsr        RastSize
  move.l     d0,d3
  suba.l     a4,a4
  move.l     a4,4(a3)
  move.w     30(a3),-(a7)
  move.w     28(a3),d2
  move.w     26(a3),d1
  move.w     24(a3),d0
  jsr        RectOnScreen
  addq.w     #2,a7
  tst.w      d0
  beq.s      DialExStart_5
  move.l     d3,d0
  movea.l    dialmalloc,a0
  jsr        (a0)
  movea.l    a0,a4
  move.l     a0,4(a3)
DialExStart_5:
  move.l     a4,d0
  bne.s      DialExStart_6
  movea.l    a2,a0
  jsr        ~_255(pc)
  move.w     30(a3),-(a7)
  move.w     28(a3),-(a7)
  move.w     26(a3),-(a7)
  move.w     24(a3),-(a7)
  move.w     30(a3),-(a7)
  move.w     28(a3),-(a7)
  move.w     26(a3),d2
  move.w     24(a3),d1
  clr.w      d0
  jsr        form_dial
  lea.l      12(a7),a7
  clr.w      d0
  bra.s      DialExStart_7
DialExStart_6:
  movea.l    a2,a0
  jsr        ~_254(pc)
  suba.l     a0,a0
  move.w     #$0100,d0
  jsr        GrafMouse
  clr.w      -(a7)
  clr.w      -(a7)
  move.w     30(a3),-(a7)
  lea.l      4(a3),a0
  move.w     28(a3),d2
  move.w     26(a3),d1
  move.w     24(a3),d0
  jsr        RastSave
  addq.w     #6,a7
  suba.l     a0,a0
  move.w     #$0101,d0
  jsr        GrafMouse
  moveq.l    #1,d0
DialExStart_7:
  movem.l    (a7)+,d3/a2-a4
  rts

DialStart:
  moveq.l    #1,d0
  jsr        DialExStart(pc)
  rts

DialEnd:
  move.l     a2,-(a7)
  subq.w     #8,a7
  movea.l    a0,a2
  move.l     4(a2),d0
  bne.s      DialEnd_1
  move.w     30(a2),-(a7)
  move.w     28(a2),-(a7)
  move.w     26(a2),-(a7)
  move.w     24(a2),-(a7)
  move.w     30(a2),-(a7)
  move.w     28(a2),-(a7)
  move.w     26(a2),d2
  move.w     24(a2),d1
  moveq.l    #3,d0
  jsr        form_dial
  lea.l      12(a7),a7
  bra.s      DialEnd_2
DialEnd_1:
  move.w     30(a2),-(a7)
  lea.l      2(a7),a0
  move.w     28(a2),d2
  move.w     26(a2),d1
  move.w     24(a2),d0
  jsr        RectAES2VDI
  addq.w     #2,a7
  suba.l     a0,a0
  move.w     #$0100,d0
  jsr        GrafMouse
  lea.l      (a7),a0
  moveq.l    #1,d1
  move.w     HandAES,d0
  jsr        vs_clip
  clr.w      -(a7)
  clr.w      -(a7)
  move.w     30(a2),-(a7)
  lea.l      4(a2),a0
  move.w     28(a2),d2
  move.w     26(a2),d1
  move.w     24(a2),d0
  jsr        RastRestore
  addq.w     #6,a7
  movea.l    4(a2),a0
  movea.l    dialfree,a1
  jsr        (a1)
  suba.l     a0,a0
  move.w     #$0101,d0
  jsr        GrafMouse
DialEnd_2:
  addq.w     #8,a7
  movea.l    (a7)+,a2
  rts

DialMove:
  movem.l    d3-d7/a2-a5,-(a7)
  lea.l      -66(a7),a7
  move.w     d0,56(a7)
  move.w     d1,54(a7)
  move.w     d2,52(a7)
  movea.l    a0,a2
  lea.l      4(a2),a3
  move.w     28(a2),d3
  move.w     30(a2),d4
  move.w     HandAES,4(a7)
  jsr        HandFast
  move.w     d0,6(a7)
  pea.l      ~_260
  lea.l      8(a7),a1
  lea.l      ~_257,a0
  jsr        v_opnvwk
  addq.w     #4,a7
  move.w     4(a7),d0
  beq.s      DialMove_1
  moveq.l    #3,d1
  jsr        vswr_mode
  move.w     #$5555,d1
  move.w     4(a7),d0
  jsr        vsl_udsty
  move.w     106(a7),-(a7)
  lea.l      60(a7),a0
  move.w     54(a7),d2
  move.w     56(a7),d1
  move.w     58(a7),d0
  jsr        RectAES2VDI
  addq.w     #2,a7
  lea.l      58(a7),a0
  moveq.l    #1,d1
  move.w     HandAES,d0
  jsr        vs_clip
  move.l     4(a2),d0
  bhi.s      DialMove_2
  move.w     4(a7),d0
  jsr        v_clsvwk
  bra.s      DialMove_1
DialMove_2:
  lea.l      32(a7),a0
  move.w     d4,d1
  move.w     d3,d0
  jsr        RastSize
  movea.l    dialmalloc,a0
  jsr        (a0)
  move.l     a0,32(a7)
  move.l     a0,d0
  bhi.s      DialMove_3
DialMove_1:
  clr.w      d0
  bra        DialMove_4
DialMove_3:
  suba.l     a0,a0
  move.w     #$0100,d0
  jsr        GrafMouse
  clr.w      -(a7)
  clr.w      -(a7)
  move.w     d4,-(a7)
  lea.l      38(a7),a0
  move.w     d3,d2
  move.w     26(a2),d1
  move.w     24(a2),d0
  jsr        RastSave
  addq.w     #6,a7
  move.w     6(a7),d0
  bne.s      DialMove_5
  move.w     d4,-(a7)
  move.w     d3,-(a7)
  move.w     26(a2),d2
  move.w     24(a2),d1
  move.w     8(a7),d0
  jsr        RastDotRect
  addq.w     #4,a7
DialMove_5:
  suba.l     a0,a0
  move.w     #$0101,d0
  jsr        GrafMouse
  pea.l      (a7)
  pea.l      34(a7)
  lea.l      28(a7),a1
  lea.l      30(a7),a0
  jsr        graf_mkstate
  addq.w     #8,a7
  move.w     24(a2),d5
  move.w     d5,10(a7)
  move.w     26(a2),d6
  move.w     d6,8(a7)
DialMove_34:
  lea.l      14(a7),a4
  lea.l      12(a7),a5
  pea.l      (a7)
  pea.l      34(a7)
  lea.l      32(a7),a1
  lea.l      34(a7),a0
  jsr        graf_mkstate
  addq.w     #8,a7
  move.w     26(a7),d7
  add.w      24(a2),d7
  sub.w      22(a7),d7
  move.w     24(a7),d0
  add.w      26(a2),d0
  sub.w      20(a7),d0
  move.w     d0,28(a7)
  cmp.w      56(a7),d7
  bge.s      DialMove_6
  move.w     56(a7),d7
DialMove_6:
  move.w     28(a7),d0
  cmp.w      54(a7),d0
  bge.s      DialMove_7
  move.w     54(a7),28(a7)
DialMove_7:
  move.w     d7,d0
  add.w      d3,d0
  move.w     56(a7),d1
  add.w      52(a7),d1
  cmp.w      d1,d0
  ble.s      DialMove_8
  move.w     d1,d7
  sub.w      d3,d7
DialMove_8:
  move.w     28(a7),d0
  add.w      d4,d0
  move.w     54(a7),d1
  add.w      106(a7),d1
  cmp.w      d1,d0
  ble.s      DialMove_9
  sub.w      d4,d1
  move.w     d1,28(a7)
DialMove_9:
  cmp.w      d5,d7
  bne.s      DialMove_10
  cmp.w      28(a7),d6
  bne.s      DialMove_10
  move.w     30(a7),d0
  bne        DialMove_11
DialMove_10:
  suba.l     a0,a0
  move.w     #$0100,d0
  jsr        GrafMouse
  move.w     6(a7),d0
  bne.s      DialMove_12
  move.w     30(a7),d1
  beq.s      DialMove_12
  move.w     d4,-(a7)
  move.w     d3,-(a7)
  move.w     d6,d2
  move.w     8(a7),d0
  move.w     d5,d1
  jsr        RastDotRect
  addq.w     #4,a7
  move.w     d4,-(a7)
  move.w     d3,-(a7)
  move.w     32(a7),d2
  move.w     d7,d1
  move.w     8(a7),d0
  jsr        RastDotRect
  addq.w     #4,a7
  bra        DialMove_13
DialMove_12:
  move.w     6(a7),d0
  bne.s      DialMove_14
  move.w     d4,-(a7)
  move.w     d3,-(a7)
  move.w     d6,d2
  move.w     d5,d1
  move.w     8(a7),d0
  jsr        RastDotRect
  addq.w     #4,a7
  move.w     10(a7),d5
  move.w     8(a7),d6
DialMove_14:
  pea.l      (a5)
  pea.l      (a4)
  move.w     d4,-(a7)
  move.w     d3,-(a7)
  move.w     40(a7),-(a7)
  move.w     d7,-(a7)
  move.w     d4,-(a7)
  lea.l      34(a7),a1
  lea.l      36(a7),a0
  move.w     d3,d2
  move.w     d6,d1
  move.w     d5,d0
  jsr        RectInter
  lea.l      18(a7),a7
  tst.w      d0
  bne.s      DialMove_15
  clr.w      -(a7)
  clr.w      -(a7)
  move.w     d4,-(a7)
  movea.l    a3,a0
  move.w     d3,d2
  move.w     d6,d1
  move.w     d5,d0
  jsr        RastRestore
  addq.w     #6,a7
  clr.w      -(a7)
  clr.w      -(a7)
  move.w     d4,-(a7)
  movea.l    a3,a0
  move.w     d3,d2
  move.w     34(a7),d1
  move.w     d7,d0
  jsr        RastSave
  addq.w     #6,a7
  bra        DialMove_16
DialMove_15:
  move.w     d4,d0
  sub.w      (a5),d0
  beq.s      DialMove_17
  move.w     (a5),2(a7)
  cmp.w      28(a7),d6
  bge.s      DialMove_18
  clr.w      2(a7)
DialMove_18:
  move.w     2(a7),-(a7)
  clr.w      -(a7)
  move.w     d4,d0
  sub.w      (a5),d0
  move.w     d0,-(a7)
  movea.l    a3,a0
  move.w     d3,d2
  move.w     d6,d1
  add.w      8(a7),d1
  move.w     d5,d0
  jsr        RastRestore
  addq.w     #6,a7
DialMove_17:
  move.w     d3,d0
  sub.w      (a4),d0
  beq.s      DialMove_19
  move.w     (a4),2(a7)
  cmp.w      d7,d5
  bge.s      DialMove_20
  clr.w      2(a7)
DialMove_20:
  cmp.w      16(a7),d6
  beq.s      DialMove_21
  move.w     d4,d0
  sub.w      (a5),d0
  bra.s      DialMove_22
DialMove_21:
  clr.w      d0
DialMove_22:
  move.w     d0,-(a7)
  move.w     4(a7),-(a7)
  move.w     (a5),-(a7)
  movea.l    a3,a0
  move.w     d3,d2
  sub.w      (a4),d2
  move.w     22(a7),d1
  move.w     d5,d0
  add.w      8(a7),d0
  jsr        RastRestore
  addq.w     #6,a7
DialMove_19:
  cmp.w      18(a7),d5
  beq.s      DialMove_23
  cmp.w      16(a7),d6
  beq.s      DialMove_23
  clr.w      -(a7)
  clr.w      -(a7)
  move.w     (a5),-(a7)
  movea.l    a3,a0
  move.w     (a4),d2
  move.w     d4,d1
  sub.w      (a5),d1
  move.w     d3,d0
  sub.w      (a4),d0
  jsr        RastBufCopy
  addq.w     #6,a7
  bra.s      DialMove_24
DialMove_23:
  cmp.w      18(a7),d5
  bne.s      DialMove_25
  cmp.w      16(a7),d6
  bne.s      DialMove_25
  move.w     d4,d0
  sub.w      (a5),d0
  move.w     d0,-(a7)
  move.w     d3,d1
  sub.w      (a4),d1
  move.w     d1,-(a7)
  move.w     (a5),-(a7)
  movea.l    a3,a0
  move.w     (a4),d2
  clr.w      d0
  move.w     d0,d1
  jsr        RastBufCopy
  addq.w     #6,a7
  bra.s      DialMove_24
DialMove_25:
  cmp.w      18(a7),d5
  bne.s      DialMove_26
  cmp.w      16(a7),d6
  beq.s      DialMove_26
  clr.w      -(a7)
  move.w     d3,d0
  sub.w      (a4),d0
  move.w     d0,-(a7)
  move.w     (a5),-(a7)
  movea.l    a3,a0
  move.w     (a4),d2
  move.w     d4,d1
  sub.w      (a5),d1
  clr.w      d0
  jsr        RastBufCopy
  addq.w     #6,a7
  bra.s      DialMove_24
DialMove_26:
  move.w     d4,d0
  sub.w      (a5),d0
  move.w     d0,-(a7)
  clr.w      -(a7)
  move.w     (a5),-(a7)
  movea.l    a3,a0
  move.w     (a4),d2
  clr.w      d1
  move.w     d3,d0
  sub.w      (a4),d0
  jsr        RastBufCopy
  addq.w     #6,a7
DialMove_24:
  move.w     d4,d0
  sub.w      (a5),d0
  beq.s      DialMove_27
  cmp.w      28(a7),d6
  bge.s      DialMove_28
  move.w     (a5),-(a7)
  clr.w      -(a7)
  move.w     d0,-(a7)
  movea.l    a3,a0
  move.w     d3,d2
  move.w     d6,d1
  add.w      d4,d1
  move.w     d7,d0
  jsr        RastSave
  addq.w     #6,a7
  bra.s      DialMove_27
DialMove_28:
  clr.w      -(a7)
  clr.w      -(a7)
  move.w     d4,d0
  sub.w      (a5),d0
  move.w     d0,-(a7)
  movea.l    a3,a0
  move.w     d3,d2
  move.w     34(a7),d1
  move.w     d7,d0
  jsr        RastSave
  addq.w     #6,a7
DialMove_27:
  move.w     d3,d0
  sub.w      (a4),d0
  beq.s      DialMove_16
  cmp.w      d7,d5
  bge.s      DialMove_29
  cmp.w      16(a7),d6
  beq.s      DialMove_30
  clr.w      d1
  bra.s      DialMove_31
DialMove_30:
  move.w     d4,d1
  sub.w      (a5),d1
DialMove_31:
  move.w     d1,-(a7)
  move.w     (a4),-(a7)
  move.w     (a5),-(a7)
  movea.l    a3,a0
  move.w     d3,d2
  sub.w      (a4),d2
  move.w     22(a7),d1
  move.w     d5,d0
  add.w      d3,d0
  jsr        RastSave
  addq.w     #6,a7
  bra.s      DialMove_16
DialMove_29:
  cmp.w      16(a7),d6
  beq.s      DialMove_32
  clr.w      d0
  bra.s      DialMove_33
DialMove_32:
  move.w     d4,d0
  sub.w      (a5),d0
DialMove_33:
  move.w     d0,-(a7)
  clr.w      -(a7)
  move.w     (a5),-(a7)
  movea.l    a3,a0
  move.w     d3,d2
  sub.w      (a4),d2
  move.w     22(a7),d1
  move.w     d7,d0
  jsr        RastSave
  addq.w     #6,a7
DialMove_16:
  clr.w      -(a7)
  clr.w      -(a7)
  move.w     d4,-(a7)
  lea.l      38(a7),a0
  move.w     d3,d2
  move.w     34(a7),d1
  move.w     d7,d0
  jsr        RastRestore
  addq.w     #6,a7
DialMove_13:
  suba.l     a0,a0
  move.w     #$0101,d0
  jsr        GrafMouse
  move.w     d7,d5
  move.w     28(a7),d6
DialMove_11:
  move.w     30(a7),d0
  bne        DialMove_34
  movea.l    32(a7),a0
  movea.l    dialfree,a1
  jsr        (a1)
  move.w     d7,24(a2)
  move.w     28(a7),26(a2)
  move.w     24(a2),d0
  add.w      32(a2),d0
  movea.l    (a2),a0
  move.w     d0,16(a0)
  move.w     26(a2),d1
  add.w      32(a2),d1
  movea.l    (a2),a0
  move.w     d1,18(a0)
  move.w     4(a7),d0
  jsr        v_clsvwk
  moveq.l    #1,d0
DialMove_4:
  lea.l      66(a7),a7
  movem.l    (a7)+,d3-d7/a2-a5
  rts

DialDo:
  movem.l    d3-d5/a2-a4,-(a7)
  lea.l      -86(a7),a7
  movea.l    a0,a4
  movea.l    a1,a2
  moveq.l    #1,d3
  clr.w      d4
  move.w     d4,(a7)
  move.l     a2,d0
  bne.s      DialDo_1
  lea.l      (a7),a2
DialDo_1:
  pea.l      2(a7)
  pea.l      8(a7)
  lea.l      14(a7),a1
  lea.l      16(a7),a0
  jsr        HandScreenSize
  addq.w     #8,a7
  moveq.l    #1,d0
  jsr        WindUpdate
  moveq.l    #3,d0
  jsr        WindUpdate
  jsr        FormGetFormKeybd
  movea.l    a0,a3
DialDo_4:
  movea.l    a3,a0
  jsr        FormSetFormKeybd
  movea.l    a2,a1
  movea.l    (a4),a0
  jsr        FormXDo
  move.w     d0,d5
  and.w      #$00FF,d0
  ext.l      d0
  move.l     d0,d1
  add.l      d1,d1
  add.l      d0,d1
  lsl.l      #3,d1
  movea.l    (a4),a0
  move.w     6(a0,d1.l),d2
  and.w      #$FF00,d2
  cmp.w      #$1100,d2
  bne.s      DialDo_2
  tst.w      d3
  beq.s      DialDo_3
  lea.l      12(a7),a1
  lea.l      10(a7),a0
  jsr        GrafGetForm
  suba.l     a0,a0
  moveq.l    #4,d0
  jsr        GrafMouse
  move.w     2(a7),-(a7)
  move.w     6(a7),d2
  move.w     8(a7),d1
  move.w     10(a7),d0
  movea.l    a4,a0
  jsr        DialMove(pc)
  addq.w     #2,a7
  move.w     d0,d3
  lea.l      12(a7),a0
  move.w     10(a7),d0
  jsr        GrafMouse
  bra.s      DialDo_3
DialDo_2:
  moveq.l    #1,d4
DialDo_3:
  tst.w      d4
  beq.w      DialDo_4
  moveq.l    #2,d0
  jsr        WindUpdate
  clr.w      d0
  jsr        WindUpdate
  move.w     d5,d0
  lea.l      86(a7),a7
  movem.l    (a7)+,d3-d5/a2-a4
  rts

DialDraw:
  move.l     a2,-(a7)
  movea.l    a0,a2
  move.w     30(a2),-(a7)
  move.w     28(a2),-(a7)
  move.w     26(a2),-(a7)
  move.w     24(a2),d2
  moveq.l    #12,d1
  clr.w      d0
  movea.l    (a0),a0
  jsr        ObjcDraw
  addq.w     #6,a7
  movea.l    (a7)+,a2
  rts

DialCenter:
  movem.l    d3-d5/a2-a6,-(a7)
  lea.l      -26(a7),a7
  movea.l    a0,a4
  pea.l      (a7)
  pea.l      6(a7)
  pea.l      12(a7)
  lea.l      16(a7),a1
  jsr        form_center
  lea.l      12(a7),a7
  lea.l      6(a7),a5
  movea.l    a5,a0
  move.l     #$56534352,d0
  jsr        ~_252(pc)
  tst.w      d0
  beq        DialCenter_1
  movea.l    (a5),a0
  cmpi.l     #$56534352,(a0)
  bne        DialCenter_1
  move.w     2(a7),d3
  sub.w      20(a4),d3
  asr.w      #1,d3
  move.w     (a7),d4
  sub.w      22(a4),d4
  asr.w      #1,d4
  lea.l      22(a7),a6
  lea.l      24(a7),a2
  pea.l      18(a7)
  pea.l      24(a7)
  movea.l    a6,a1
  movea.l    a2,a0
  jsr        HandScreenSize
  addq.w     #8,a7
  lea.l      14(a7),a3
  pea.l      10(a7)
  pea.l      16(a7)
  movea.l    (a5),a0
  move.w     16(a0),-(a7)
  move.w     14(a0),-(a7)
  move.w     12(a0),-(a7)
  move.w     10(a0),-(a7)
  move.w     34(a7),-(a7)
  movea.l    a3,a1
  lea.l      34(a7),a0
  move.w     38(a7),d2
  move.w     (a6),d1
  move.w     (a2),d0
  jsr        RectInter
  lea.l      18(a7),a7
  tst.w      d0
  beq        DialCenter_1
  move.w     12(a7),d0
  sub.w      2(a7),d0
  ext.l      d0
  divs.w     #$0002,d0
  move.w     10(a7),d1
  sub.w      (a7),d1
  ext.l      d1
  divs.w     #$0002,d1
  tst.w      d0
  bge.s      DialCenter_2
  move.w     16(a7),d2
  add.w      d0,d2
  cmp.w      (a2),d2
  bge.s      DialCenter_3
  move.w     (a2),d0
  sub.w      16(a7),d0
DialCenter_3:
  move.w     16(a7),d2
  add.w      d0,d2
  add.w      2(a7),d2
  move.w     (a2),d5
  add.w      20(a7),d5
  cmp.w      d5,d2
  ble.s      DialCenter_4
  move.w     d5,d0
  sub.w      2(a7),d0
  sub.w      16(a7),d0
DialCenter_4:
  move.w     16(a7),d2
  add.w      d0,d2
  cmp.w      (a2),d2
  blt.s      DialCenter_1
DialCenter_2:
  tst.w      d1
  bge.s      DialCenter_5
  move.w     (a3),d2
  add.w      d1,d2
  cmp.w      (a6),d2
  bge.s      DialCenter_6
  move.w     (a6),d1
  sub.w      (a3),d1
DialCenter_6:
  move.w     (a3),d2
  add.w      d1,d2
  add.w      (a7),d2
  move.w     (a6),d5
  add.w      18(a7),d5
  cmp.w      d5,d2
  ble.s      DialCenter_7
  move.w     d5,d1
  sub.w      (a7),d1
  sub.w      (a3),d1
DialCenter_7:
  move.w     (a3),d2
  add.w      d1,d2
  cmp.w      (a6),d2
  blt.s      DialCenter_1
DialCenter_5:
  move.w     16(a7),d2
  add.w      d0,d2
  add.w      d3,d2
  move.w     d2,16(a4)
  move.w     (a3),d0
  add.w      d1,d0
  add.w      d4,d0
  move.w     d0,18(a4)
DialCenter_1:
  lea.l      26(a7),a7
  movem.l    (a7)+,d3-d5/a2-a6
  rts

DialInit:
  move.l     a2,-(a7)
  subq.w     #8,a7
  move.l     a0,dialmalloc
  move.l     a1,dialfree
  lea.l      DialWk,a2
  move.w     (a2),d0
  bne.s      DialInit_1
  jsr        HandInit
  move.w     HandAES,(a2)
  pea.l      ~_260
  movea.l    a2,a1
  lea.l      2(a2),a0
  jsr        v_opnvwk
  addq.w     #4,a7
  lea.l      (a7),a1
  lea.l      (a7),a0
  moveq.l    #5,d2
  clr.w      d1
  move.w     (a2),d0
  jsr        vst_alignment
  pea.l      6(a7)
  pea.l      8(a7)
  lea.l      10(a7),a1
  lea.l      8(a7),a0
  jsr        HandScreenSize
  addq.w     #8,a7
  move.w     (a2),d0
  beq.s      DialInit_2
  moveq.l    #1,d1
  move.w     d1,-(a7)
  move.w     8(a7),-(a7)
  move.w     8(a7),d2
  move.w     4(a7),d0
  move.w     6(a7),d1
  jsr        HandClip
  addq.w     #4,a7
DialInit_2:
  jsr        ObjcInit
DialInit_1:
  move.w     (a2),d0
  addq.w     #8,a7
  movea.l    (a7)+,a2
  rts

DialExit:
  move.w     DialWk,d0
  beq.s      DialExit_1
  jsr        v_clsvwk
  clr.w      DialWk
DialExit_1:
  rts

~_261:
  move.l     d3,-(a7)
  move.l     a2,-(a7)
  cmpi.w     #$FFFF,~_272
  bne.s      ~_261_1
  suba.l     a0,a0
  jsr        Super
  move.l     d0,d3
  movea.l    ($000004F2).w,a2
  movea.l    d3,a0
  jsr        Super
  move.w     2(a2),~_272
~_261_1:
  move.w     ~_272,d0
  movea.l    (a7)+,a2
  move.l     (a7)+,d3
  rts

FormSetValidator:
  move.l     a0,~_273
  move.l     a1,~_274
  rts

~_262:
  movem.l    d3-d7/a2-a6,-(a7)
  lea.l      -18(a7),a7
  movea.l    a0,a3
  move.w     d0,d5
  move.w     d1,4(a7)
  move.w     d2,2(a7)
  movea.l    a1,a5
  move.w     62(a7),d4
  lea.l      2(a7),a2
  move.w     d1,d6
  asr.w      #8,d6
  and.w      #$00FF,d6
  and.w      #$00FF,d1
  move.w     d1,(a7)
  cmp.w      #$0002,d4
  bne        ~_262_1
  moveq.l    #8,d2
  move.w     d5,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  and.w      8(a3,d0.l),d2
  beq        ~_262_1
  movea.l    12(a3,d0.l),a0
  movea.l    (a0),a4
  move.w     d6,d2
  moveq.l    #4,d1
  lea.l      $000015B6(pc),a1
~_262_2:
  cmp.w      (a1)+,d2
  dbeq       d1,~_262_2
  bne        ~_262_3
  move.w     8(a1),d2
  jmp        $000015B6(pc,d2.w)
J1:
[000015b6] 004b                      dc.w $004b
[000015b8] 004d                      dc.w $004d
[000015ba] 0053                      dc.w $0053
[000015bc] 0073                      dc.w $0073
[000015be] 0074                      dc.w $0074
[000015c0] 0014                      dc.w $0014   ; ~_262_4-J1
[000015c2] 003c                      dc.w $003c   ; ~_262_5-J1
[000015c4] 00d0                      dc.w $00d0   ; ~_262_6-J1
[000015c6] 0058                      dc.w $0058   ; ~_262_7-J1
[000015c8] 0092                      dc.w $0092   ; ~_262_8-J1
~_262_4:
  moveq.l    #3,d0
  and.w      (a2),d0
  beq        ~_262_3
  bra.s      ~_262_9
~_262_10:
  moveq.l    #2,d2
  movea.l    a5,a1
  move.w     #$4B00,d1
  move.w     d5,d0
  movea.l    a3,a0
  jsr        objc_edit
  move.w     d0,d6
~_262_9:
  move.w     (a5),d0
  bne.s      ~_262_10
  move.w     d6,d0
  bra        ~_262_11
~_262_5:
  moveq.l    #3,d0
  and.w      (a2),d0
  beq        ~_262_3
  moveq.l    #3,d2
  movea.l    a5,a1
  clr.w      d1
  movea.l    a3,a0
  move.w     d5,d0
  jsr        objc_edit
  bra        ~_262_12
~_262_7:
  moveq.l    #4,d0
  and.w      (a2),d0
  beq        ~_262_3
  bra.s      ~_262_13
~_262_15:
  moveq.l    #2,d2
  movea.l    a5,a1
  move.w     #$4B00,d1
  move.w     d5,d0
  movea.l    a3,a0
  jsr        objc_edit
  move.w     d0,d6
  move.w     (a5),d1
  cmpi.b     #$20,-1(a4,d1.w)
  bne.s      ~_262_13
  cmpi.b     #$20,0(a4,d1.w)
  bne.s      ~_262_14
~_262_13:
  move.w     (a5),d0
  bne.s      ~_262_15
~_262_14:
  move.w     d6,d0
  bra        ~_262_11
~_262_8:
  moveq.l    #4,d0
  and.w      (a2),d0
  beq        ~_262_3
  bra.s      ~_262_16
~_262_18:
  moveq.l    #2,d2
  movea.l    a5,a1
  move.w     #$4D00,d1
  move.w     d5,d0
  movea.l    a3,a0
  jsr        objc_edit
  move.w     d0,d6
  move.w     (a5),d1
  cmpi.b     #$20,-1(a4,d1.w)
  bne.s      ~_262_16
  cmpi.b     #$20,0(a4,d1.w)
  bne.s      ~_262_17
~_262_16:
  move.w     (a5),d0
  move.b     0(a4,d0.w),d1
  bne.s      ~_262_18
~_262_17:
  move.w     d6,d0
  bra        ~_262_11
~_262_6:
  moveq.l    #4,d0
  and.w      (a2),d0
  beq.s      ~_262_3
  pea.l      6(a7)
  pea.l      12(a7)
  lea.l      18(a7),a1
  lea.l      20(a7),a0
  jsr        HandScreenSize
  addq.w     #8,a7
  moveq.l    #3,d2
  movea.l    a5,a1
  clr.w      d1
  move.w     d5,d0
  movea.l    a3,a0
  jsr        objc_edit
  move.w     (a5),d0
  move.w     d5,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  movea.l    12(a3,d1.l),a0
  movea.l    (a0),a1
  clr.b      0(a1,d0.w)
  move.w     6(a7),-(a7)
  move.w     10(a7),-(a7)
  move.w     14(a7),-(a7)
  move.w     d5,d0
  movea.l    a3,a0
  moveq.l    #1,d1
  move.w     18(a7),d2
  jsr        objc_draw
  addq.w     #6,a7
  bra        ~_262_12
~_262_3:
  move.l     ~_273,d0
  beq        ~_262_1
  move.w     (a5),d6
  move.w     d5,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  movea.l    12(a3,d1.l),a0
  movea.l    8(a0),a1
  move.b     0(a1,d6.w),d3
  tst.b      d3
  bne.s      ~_262_19
  subq.w     #1,d6
  move.b     0(a1,d6.w),d3
~_262_19:
  move.b     d3,d0
  ext.w      d0
  movea.l    ~_273,a0
  jsr        strchr
  movea.l    a0,a6
  move.l     a6,d0
  beq        ~_262_1
  move.l     a6,d7
  sub.l      ~_273,d7
  move.l     a2,-(a7)
  pea.l      (a2)
  move.w     (a5),d1
  lea.l      12(a7),a1
  move.w     d7,d2
  ext.l      d2
  lsl.l      #2,d2
  movea.l    ~_274,a2
  movea.l    0(a2,d2.l),a2
  movea.l    a3,a0
  move.w     d5,d0
  jsr        (a2)
  addq.w     #4,a7
  movea.l    (a7)+,a2
  tst.w      d0
  beq.s      ~_262_20
  move.w     d5,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  movea.l    12(a3,d0.l),a0
  movea.l    8(a0),a1
  move.b     #$58,0(a1,d6.w)
  move.w     d4,d2
  movea.l    a5,a1
  movea.l    a3,a0
  move.w     d5,d0
  move.w     4(a7),d1
  jsr        objc_edit
  move.w     d0,d7
  move.w     d5,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  movea.l    12(a3,d1.l),a0
  movea.l    8(a0),a1
  move.b     d3,0(a1,d6.w)
  bra        ~_262_11
~_262_20:
  move.w     d5,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  movea.l    12(a3,d0.l),a0
  movea.l    4(a0),a2
  move.l     a2,6(a7)
  clr.w      d7
  bra.s      ~_262_21
~_262_22:
  addq.l     #1,6(a7)
~_262_23:
  movea.l    6(a7),a0
  cmpi.b     #$5F,(a0)
  bne.s      ~_262_22
  addq.l     #1,6(a7)
  addq.w     #1,d7
~_262_21:
  cmp.w      (a5),d7
  blt.s      ~_262_23
  move.w     (a7),d0
  movea.l    6(a7),a0
  jsr        strchr
  movea.l    a0,a6
  move.l     a6,d0
  beq        ~_262_24
  sub.l      a2,d0
  clr.w      d3
  move.w     d3,d7
  bra.s      ~_262_25
~_262_27:
  cmpi.b     #$5F,0(a2,d7.w)
  bne.s      ~_262_26
  addq.w     #1,d3
~_262_26:
  addq.w     #1,d7
~_262_25:
  cmp.w      d7,d0
  bgt.s      ~_262_27
  pea.l      10(a7)
  pea.l      16(a7)
  lea.l      22(a7),a1
  lea.l      24(a7),a0
  jsr        HandScreenSize
  addq.w     #8,a7
  moveq.l    #3,d2
  movea.l    a5,a1
  clr.w      d1
  move.w     d5,d0
  movea.l    a3,a0
  jsr        objc_edit
  move.w     (a5),d0
  clr.b      0(a4,d0.w)
  bra.s      ~_262_28
~_262_29:
  lea.l      ~_276,a1
  movea.l    a4,a0
  jsr        strcat
~_262_28:
  move.w     d3,d0
  ext.l      d0
  move.l     d0,-(a7)
  movea.l    a4,a0
  jsr        strlen
  cmp.l      (a7)+,d0
  bcs.s      ~_262_29
  move.w     10(a7),-(a7)
  move.w     14(a7),-(a7)
  move.w     18(a7),-(a7)
  move.w     22(a7),d2
  moveq.l    #1,d1
  move.w     d5,d0
  movea.l    a3,a0
  jsr        objc_draw
  addq.w     #6,a7
~_262_12:
  moveq.l    #1,d2
  movea.l    a5,a1
  clr.w      d1
  move.w     d5,d0
  movea.l    a3,a0
  jsr        objc_edit
  bra.s      ~_262_11
~_262_24:
  clr.w      4(a7)
~_262_1:
  move.w     d4,d2
  movea.l    a5,a1
  move.w     4(a7),d1
  move.w     d5,d0
  movea.l    a3,a0
  jsr        objc_edit
~_262_11:
  lea.l      18(a7),a7
  movem.l    (a7)+,d3-d7/a2-a6
  rts

~_263:
  move.w     d3,-(a7)
  move.l     a2,-(a7)
  movea.l    a0,a2
  clr.w      d3
  move.w     d3,(a0)
~_263_2:
  jsr        evnt_keybd
  move.w     d0,d3
  cmp.w      #$5230,d0
  beq.s      ~_263_1
  moveq.l    #10,d1
  muls.w     (a2),d1
  move.w     d1,(a2)
  and.w      #$00FF,d0
  add.w      #$FFD0,d0
  add.w      d0,(a2)
  bra.s      ~_263_2
~_263_1:
  andi.w     #$00FF,(a2)
  movea.l    (a7)+,a2
  move.w     (a7)+,d3
  rts

~_264:
  move.w     d3,-(a7)
  move.l     a2,-(a7)
  movea.l    a0,a2
  clr.w      d3
  bra.s      ~_264_1
~_264_2:
  addq.w     #1,d3
~_264_1:
  moveq.l    #32,d0
  move.w     d3,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  and.w      8(a2,d1.l),d0
  beq.s      ~_264_2
  move.w     d3,d0
  movea.l    (a7)+,a2
  move.w     (a7)+,d3
  rts

~_265:
  movem.l    d3-d7/a3,-(a7)
  lea.l      -16(a7),a7
  movea.l    a0,a3
  move.w     d0,d4
  move.w     d1,d5
  move.w     d2,d7
  clr.w      d3
  lea.l      (a7),a1
  jsr        ObjcXywh
  move.w     #$0001,10(a7)
  move.w     (a7),14(a7)
  move.w     2(a7),12(a7)
~_265_6:
  move.w     d3,d0
  move.w     14(a7),d1
  cmp.w      (a7),d1
  blt.s      ~_265_1
  move.w     12(a7),d2
  cmp.w      2(a7),d2
  blt.s      ~_265_1
  move.w     (a7),d1
  add.w      4(a7),d1
  movea.w    14(a7),a0
  cmpa.w     d1,a0
  bge.s      ~_265_1
  move.w     2(a7),d2
  add.w      6(a7),d2
  movea.w    12(a7),a1
  cmpa.w     d2,a1
  bge.s      ~_265_1
  moveq.l    #1,d3
  bra.s      ~_265_2
~_265_1:
  clr.w      d3
~_265_2:
  cmp.w      d0,d3
  beq.s      ~_265_3
  tst.w      d3
  beq.s      ~_265_4
  move.w     d5,d6
  bra.s      ~_265_5
~_265_4:
  move.w     d7,d6
~_265_5:
  moveq.l    #1,d0
  move.w     d0,-(a7)
  move.w     d6,-(a7)
  move.w     10(a7),-(a7)
  move.w     10(a7),-(a7)
  move.w     10(a7),-(a7)
  move.w     10(a7),d2
  clr.w      d1
  movea.l    a3,a0
  move.w     d4,d0
  jsr        ObjcChange
  lea.l      10(a7),a7
~_265_3:
  pea.l      8(a7)
  pea.l      14(a7)
  lea.l      20(a7),a1
  lea.l      22(a7),a0
  jsr        graf_mkstate
  addq.w     #8,a7
  move.w     10(a7),d0
  bne        ~_265_6
  move.w     d3,d0
  lea.l      16(a7),a7
  movem.l    (a7)+,d3-d7/a3
  rts

~_266:
  movem.l    d3-d6/a2-a3,-(a7)
  movea.l    a0,a2
  move.w     d0,d6
  move.w     d1,d3
  cmp.w      #$6200,d1
  bne.s      ~_266_1
  clr.w      d4
  bra.s      ~_266_2
~_266_5:
  move.w     d4,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     6(a2,d0.l),d2
  and.w      #$FF00,d2
  cmp.w      #$1500,d2
  beq        ~_266_3
  moveq.l    #32,d0
  move.w     d4,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  and.w      8(a2,d1.l),d0
  beq.s      ~_266_4
  moveq.l    #-1,d4
  bra.s      ~_266_2
~_266_4:
  addq.w     #1,d4
~_266_2:
  tst.w      d4
  bge.s      ~_266_5
~_266_1:
  move.w     d3,d0
  lsr.w      #8,d0
  and.w      #$00FF,d0
  move.w     d0,d3
  pea.l      ($FFFFFFFF).w
  movea.l    #$FFFFFFFF,a1
  movea.l    #$FFFFFFFF,a0
  jsr        Keytbl
  addq.w     #4,a7
  cmp.w      #$0078,d3
  bcs.s      ~_266_6
  move.b     d3,d5
  add.b      #$B9,d5
  cmp.b      #$3A,d5
  bne.s      ~_266_7
  moveq.l    #48,d5
  bra.s      ~_266_7
~_266_6:
  moveq.l    #0,d0
  move.w     d3,d0
  movea.l    (a0),a1
  move.b     0(a1,d0.l),d5
~_266_7:
  clr.w      d0
  move.b     d5,d0
  jsr        toupper
  move.b     d0,d5
  clr.w      d4
  bra.w      ~_266_8
~_266_12:
  move.w     d4,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     6(a2,d0.l),d2
  and.w      #$00FF,d2
  cmp.w      #$0018,d2
  bne.s      ~_266_9
  movea.l    12(a2,d0.l),a0
  movea.l    (a0),a1
  cmpa.l     #ObjcMyButton,a1
  bne.s      ~_266_9
  movea.l    4(a0),a3
  movea.l    a3,a0
  moveq.l    #91,d0
  jsr        strchr
  movea.l    a0,a3
  move.l     a3,d0
  beq.s      ~_266_9
  cmpi.b     #$5B,1(a3)
  beq.s      ~_266_9
  clr.w      d1
  move.b     d5,d1
  move.w     d1,-(a7)
  move.b     1(a3),d0
  ext.w      d0
  jsr        toupper
  cmp.w      (a7)+,d0
  bne.s      ~_266_9
~_266_3:
  move.w     d4,d0
  bra.s      ~_266_10
~_266_9:
  moveq.l    #32,d0
  move.w     d4,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  and.w      8(a2,d1.l),d0
  beq.s      ~_266_11
  moveq.l    #-1,d4
  bra.s      ~_266_8
~_266_11:
  addq.w     #1,d4
~_266_8:
  tst.w      d4
  bge.w      ~_266_12
  move.w     d6,d0
~_266_10:
  movem.l    (a7)+,d3-d6/a2-a3
  rts

~_267:
  move.w     d3,-(a7)
  move.l     a2,-(a7)
  movea.l    a0,a2
  clr.w      d3
~_267_4:
  moveq.l    #32,d0
  move.w     d3,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  and.w      8(a2,d1.l),d0
  beq.s      ~_267_1
  moveq.l    #-1,d0
  bra.s      ~_267_2
~_267_1:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     6(a2,d0.l),d2
  and.w      #$00FF,d2
  cmp.w      #$0018,d2
  bne.s      ~_267_3
  movea.l    12(a2,d0.l),a0
  movea.l    (a0),a1
  cmpa.l     #ObjcAnimImage,a1
  bne.s      ~_267_3
  move.w     d3,d0
  bra.s      ~_267_2
~_267_3:
  addq.w     #1,d3
  bra.s      ~_267_4
~_267_2:
  movea.l    (a7)+,a2
  move.w     (a7)+,d3
  rts

~_268:
  movem.l    d3-d6/a2,-(a7)
  movea.l    a0,a2
  move.w     d0,d6
  clr.w      d3
  moveq.l    #1,d4
  moveq.l    #8,d5
  move.w     d1,d2
  addq.w     #3,d2
  beq.s      ~_268_1
  subq.w     #1,d2
  beq.s      ~_268_2
  subq.w     #1,d2
  beq.s      ~_268_3
  bra.s      ~_268_4
~_268_3:
  moveq.l    #-1,d4
~_268_2:
  move.w     d6,d3
  add.w      d4,d3
  bra.s      ~_268_4
~_268_1:
  moveq.l    #2,d5
  bra.s      ~_268_4
~_268_8:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     8(a2,d0.l),d1
  move.w     d1,d2
  and.w      d5,d2
  beq.s      ~_268_5
  move.w     d3,d0
  bra.s      ~_268_6
~_268_5:
  moveq.l    #32,d0
  and.w      d1,d0
  beq.s      ~_268_7
  moveq.l    #-1,d3
  bra.s      ~_268_4
~_268_7:
  add.w      d4,d3
~_268_4:
  tst.w      d3
  bge.s      ~_268_8
  move.w     d6,d0
~_268_6:
  movem.l    (a7)+,d3-d6/a2
  rts

~_269:
  move.w     d3,-(a7)
  move.w     d0,d3
  tst.w      d0
  bne.s      ~_269_1
  moveq.l    #-2,d1
  clr.w      d0
  jsr        ~_268(pc)
  move.w     d0,d3
~_269_1:
  move.w     d3,d0
  move.w     (a7)+,d3
  rts

~_270:
  movem.l    d3-d5/a2,-(a7)
  movea.l    a0,a2
  move.w     d0,d3
  jsr        ObjcGParent
  move.w     d0,d4
  ext.l      d0
  move.l     d0,d1
  add.l      d1,d1
  add.l      d0,d1
  lsl.l      #3,d1
  move.w     2(a2,d1.l),d5
  bra.s      ~_270_1
~_270_3:
  cmp.w      d5,d3
  beq.s      ~_270_2
  moveq.l    #16,d0
  move.w     d5,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  and.w      8(a2,d1.l),d0
  beq.s      ~_270_2
  movea.l    a2,a0
  move.w     d5,d0
  jsr        ObjcDsel
~_270_2:
  move.w     d5,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     0(a2,d0.l),d5
~_270_1:
  cmp.w      d5,d4
  bne.s      ~_270_3
  move.w     d3,d0
  movea.l    a2,a0
  jsr        ObjcSel
  movem.l    (a7)+,d3-d5/a2
  rts

FormButton:
  movem.l    d3-d6/a2-a3,-(a7)
  subq.w     #6,a7
  movea.l    a0,a2
  move.w     d0,d3
  move.w     d1,4(a7)
  movea.l    a1,a3
  ext.l      d0
  move.l     d0,d2
  add.l      d2,d2
  add.l      d0,d2
  lsl.l      #3,d2
  move.w     8(a2,d2.l),d4
  move.w     10(a2,d2.l),d5
  moveq.l    #64,d6
  and.w      d4,d6
  moveq.l    #1,d0
  and.w      d4,d0
  moveq.l    #8,d1
  and.w      d5,d1
  moveq.l    #8,d2
  and.w      d4,d2
  move.w     d2,2(a7)
  tst.w      d6
  bne.s      FormButton_1
  tst.w      d0
  beq.s      FormButton_2
  tst.w      d1
  beq.s      FormButton_1
FormButton_2:
  move.w     2(a7),d2
  beq.w      FormButton_3
FormButton_1:
  tst.w      d6
  beq.s      FormButton_4
  cmpi.w     #$0002,4(a7)
  bne.s      FormButton_4
  move.w     #$8000,(a7)
  bra.s      FormButton_5
FormButton_4:
  clr.w      (a7)
FormButton_5:
  tst.w      d0
  beq.s      FormButton_6
  tst.w      d1
  bne.s      FormButton_6
  moveq.l    #16,d0
  and.w      d4,d0
  beq.s      FormButton_7
  movea.l    a2,a0
  move.w     d3,d0
  jsr        ~_270(pc)
  bra.s      FormButton_6
FormButton_7:
  tst.w      d6
  bne.s      FormButton_8
  move.w     d5,d2
  moveq.l    #1,d1
  eor.w      d5,d1
  move.w     d3,d0
  movea.l    a2,a0
  jsr        ~_265(pc)
  tst.w      d0
  bne.s      FormButton_6
  bra.s      FormButton_3
FormButton_8:
  move.w     d3,d0
  movea.l    a2,a0
  jsr        ObjcToggle
FormButton_6:
  tst.w      d6
  bne.s      FormButton_9
  moveq.l    #4,d0
  and.w      d4,d0
  beq.s      FormButton_10
FormButton_9:
  move.w     d3,d0
  or.w       (a7),d0
  move.w     d0,(a3)
  clr.w      d0
  bra.s      FormButton_11
FormButton_10:
  move.w     2(a7),d0
  bne.s      FormButton_12
FormButton_3:
  clr.w      (a3)
FormButton_12:
  moveq.l    #1,d0
FormButton_11:
  addq.w     #6,a7
  movem.l    (a7)+,d3-d6/a2-a3
  rts

FormKeybd:
  movem.l    d3-d7/a2-a4,-(a7)
  subq.w     #2,a7
  movea.l    a0,a2
  move.w     d0,d5
  move.w     d2,d3
  move.w     38(a7),d7
  movea.l    a1,a3
  movea.l    40(a7),a4
  move.w     d1,(a7)
  move.w     d2,d4
  and.w      #$FF00,d4
  lsr.w      #8,d4
  cmp.w      #$0072,d4
  beq.s      FormKeybd_1
  cmp.w      #$001C,d4
  bne.s      FormKeybd_2
FormKeybd_1:
  moveq.l    #-3,d1
  move.w     d5,d0
  movea.l    a2,a0
  jsr        ~_268(pc)
  move.w     d0,d6
  move.w     d0,(a3)
  clr.w      (a4)
  cmp.w      d5,d0
  beq.s      FormKeybd_3
  lea.l      (a7),a1
  moveq.l    #1,d1
  movea.l    a2,a0
  jsr        FormButton(pc)
  clr.w      d0
  bra        FormKeybd_4
FormKeybd_3:
  moveq.l    #15,d4
FormKeybd_2:
  cmp.w      #$0047,d4
  bne.s      FormKeybd_5
  moveq.l    #3,d0
  and.w      d7,d0
  beq.s      FormKeybd_6
  movea.l    a2,a0
  jsr        ~_264(pc)
  movea.l    a2,a0
  moveq.l    #-1,d1
  jsr        ~_268(pc)
  move.w     d0,d6
  bra.s      FormKeybd_7
FormKeybd_6:
  moveq.l    #-2,d1
  clr.w      d0
  movea.l    a2,a0
  jsr        ~_268(pc)
  move.w     d0,d6
  bra.s      FormKeybd_7
FormKeybd_5:
  cmp.w      #$000F,d4
  bne.s      FormKeybd_8
  moveq.l    #1,d0
  bra.s      FormKeybd_9
FormKeybd_8:
  clr.w      d0
FormKeybd_9:
  move.w     d0,-(a7)
  moveq.l    #3,d1
  and.w      d7,d1
  bne.s      FormKeybd_10
  moveq.l    #1,d2
  bra.s      FormKeybd_11
FormKeybd_10:
  clr.w      d2
FormKeybd_11:
  and.w      (a7)+,d2
  bne.s      FormKeybd_12
  cmp.w      #$0050,d4
  bne.s      FormKeybd_13
FormKeybd_12:
  moveq.l    #-2,d1
  move.w     d5,d0
  movea.l    a2,a0
  jsr        ~_268(pc)
  move.w     d0,d6
  bra.s      FormKeybd_7
FormKeybd_13:
  cmp.w      #$0048,d4
  beq.s      FormKeybd_14
  cmp.w      #$000F,d4
  bne.s      FormKeybd_15
FormKeybd_14:
  moveq.l    #-1,d1
  move.w     d5,d0
  movea.l    a2,a0
  jsr        ~_268(pc)
  move.w     d0,d6
FormKeybd_7:
  move.w     d6,(a3)
  clr.w      (a4)
  bra.s      FormKeybd_16
FormKeybd_15:
  move.w     d3,d0
  and.w      #$00FF,d0
  bne.s      FormKeybd_17
  move.w     d3,d1
  movea.l    a2,a0
  move.w     d5,d0
  jsr        ~_266(pc)
  move.w     d0,d6
  move.w     d0,(a3)
  clr.w      (a4)
  cmp.w      d5,d0
  bne.s      FormKeybd_18
FormKeybd_17:
  move.w     d3,(a4)
FormKeybd_16:
  moveq.l    #1,d0
  bra.s      FormKeybd_4
FormKeybd_18:
  lea.l      (a7),a1
  moveq.l    #1,d1
  move.w     d6,d0
  movea.l    a2,a0
  jsr        FormButton(pc)
  move.w     d0,d1
  tst.w      d0
  beq.s      FormKeybd_19
  move.w     d5,(a3)
  clr.w      (a4)
FormKeybd_19:
  move.w     d1,d0
FormKeybd_4:
  addq.w     #2,a7
  movem.l    (a7)+,d3-d7/a2-a4
  rts

FormSetFormKeybd:
  move.l     a0,~_275
  rts

FormGetFormKeybd:
  movea.l    ~_275,a0
  rts

FormDo:
  subq.w     #2,a7
  move.w     d0,(a7)
  lea.l      (a7),a1
  jsr        FormXDo
  addq.w     #2,a7
  rts

FormXDo:
  movem.l    d3-d7/a2-a6,-(a7)
  lea.l      -28(a7),a7
  movea.l    a0,a2
  move.l     a1,24(a7)
  moveq.l    #3,d3
  moveq.l    #1,d0
  jsr        WindUpdate
  movea.l    a2,a0
  jsr        ~_267(pc)
  move.w     d0,d7
  addq.w     #1,d0
  beq.s      FormXDo_1
  move.w     d7,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  movea.l    12(a2,d1.l),a0
  movea.l    4(a0),a3
  or.w       #$0020,d3
  move.w     8(a3),d0
  ext.l      d0
  add.l      d0,d0
  movea.l    4(a3),a1
  move.w     0(a1,d0.l),d4
  pea.l      4(a7)
  lea.l      10(a7),a1
  movea.l    a2,a0
  move.w     d7,d0
  jsr        objc_offset
  addq.w     #4,a7
  movea.l    (a3),a0
  movea.l    (a0),a1
  move.w     4(a1),d0
  lsl.w      #3,d0
  move.w     d0,2(a7)
  move.w     6(a1),(a7)
FormXDo_1:
  lea.l      22(a7),a5
  movea.l    24(a7),a0
  move.w     (a0),d0
  movea.l    a2,a0
  jsr        ~_269(pc)
  move.w     d0,(a5)
  clr.w      d7
  moveq.l    #1,d5
  lea.l      20(a7),a6
  lea.l      10(a7),a4
  bra        FormXDo_2
FormXDo_11:
  move.w     (a5),d0
  beq.s      FormXDo_3
  cmp.w      d0,d7
  beq.s      FormXDo_3
  move.w     d0,d7
  clr.w      (a5)
  moveq.l    #1,d0
  move.w     d0,-(a7)
  movea.l    a6,a1
  clr.w      d2
  clr.w      d1
  movea.l    a2,a0
  move.w     d7,d0
  jsr        ~_262(pc)
  addq.w     #2,a7
FormXDo_3:
  pea.l      8(a7)
  pea.l      (a4)
  pea.l      20(a7)
  pea.l      26(a7)
  pea.l      32(a7)
  clr.w      -(a7)
  move.w     d4,-(a7)
  clr.w      -(a7)
  clr.w      -(a7)
  clr.w      -(a7)
  clr.w      -(a7)
  clr.w      -(a7)
  clr.w      -(a7)
  clr.w      -(a7)
  clr.w      -(a7)
  clr.w      -(a7)
  clr.w      -(a7)
  moveq.l    #1,d0
  move.w     d0,-(a7)
  lea.l      64(a7),a1
  suba.l     a0,a0
  move.w     d0,d2
  moveq.l    #2,d1
  move.w     d3,d0
  jsr        evnt_multi
  lea.l      46(a7),a7
  move.w     d0,d6
  moveq.l    #32,d1
  and.w      d0,d1
  beq.s      FormXDo_4
  move.w     (a7),-(a7)
  move.w     4(a7),-(a7)
  move.w     8(a7),-(a7)
  move.w     12(a7),d2
  movea.l    a2,a0
  clr.w      d0
  moveq.l    #10,d1
  jsr        ObjcDraw
  addq.w     #6,a7
  move.w     8(a3),d0
  ext.l      d0
  add.l      d0,d0
  movea.l    4(a3),a0
  move.w     0(a0,d0.l),d4
FormXDo_4:
  moveq.l    #1,d0
  and.w      d6,d0
  beq        FormXDo_5
  cmpi.w     #$5230,(a4)
  bne.s      FormXDo_6
  movea.l    a4,a0
  jsr        ~_263(pc)
FormXDo_6:
  move.l     a2,-(a7)
  pea.l      (a4)
  move.w     20(a7),-(a7)
  movea.l    a5,a1
  move.w     (a4),d2
  move.w     (a5),d1
  move.w     d7,d0
  movea.l    a2,a0
  movea.l    ~_275,a2
  jsr        (a2)
  addq.w     #6,a7
  movea.l    (a7)+,a2
  move.w     d0,d5
  move.w     (a4),d1
  beq.s      FormXDo_5
  jsr        ~_261(pc)
  cmp.w      #$0102,d0
  bge.s      FormXDo_7
  moveq.l    #8,d0
  move.w     d7,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  and.w      8(a2,d1.l),d0
  beq.s      FormXDo_5
  movea.w    (a6),a0
  movea.l    12(a2,d1.l),a1
  movea.l    8(a1),a1
  cmpi.b     #$39,0(a1,a0.w)
  bne.s      FormXDo_7
  move.w     (a4),d0
  and.w      #$00FF,d0
  cmp.w      #$005F,d0
  beq.s      FormXDo_5
FormXDo_7:
  moveq.l    #2,d0
  move.w     d0,-(a7)
  movea.l    a6,a1
  move.w     14(a7),d2
  move.w     (a4),d1
  movea.l    a2,a0
  move.w     d7,d0
  jsr        ~_262(pc)
  addq.w     #2,a7
FormXDo_5:
  moveq.l    #2,d0
  and.w      d6,d0
  beq.s      FormXDo_8
  move.w     16(a7),-(a7)
  move.w     20(a7),d2
  moveq.l    #8,d1
  movea.l    a2,a0
  clr.w      d0
  jsr        objc_find
  addq.w     #2,a7
  move.w     d0,(a5)
  addq.w     #1,d0
  bne.s      FormXDo_9
  clr.w      (a5)
  moveq.l    #7,d1
  moveq.l    #2,d0
  jsr        Bconout
  bra.s      FormXDo_8
FormXDo_9:
  movea.l    a5,a1
  move.w     8(a7),d1
  move.w     (a5),d0
  movea.l    a2,a0
  jsr        FormButton(pc)
  move.w     d0,d5
FormXDo_8:
  tst.w      d5
  beq.s      FormXDo_10
  move.w     (a5),d0
  beq.s      FormXDo_2
  cmp.w      d0,d7
  beq.s      FormXDo_2
FormXDo_10:
  moveq.l    #3,d0
  move.w     d0,-(a7)
  movea.l    a6,a1
  clr.w      d2
  clr.w      d1
  movea.l    a2,a0
  move.w     d7,d0
  jsr        ~_262(pc)
  addq.w     #2,a7
FormXDo_2:
  tst.w      d5
  bne        FormXDo_11
  clr.w      d0
  jsr        WindUpdate
  move.l     #FormKeybd,~_275
  movea.l    24(a7),a0
  move.w     d7,(a0)
  move.w     (a5),d0
  lea.l      28(a7),a7
  movem.l    (a7)+,d3-d7/a2-a6
  rts

~_277:
  movem.l    d3-d5/a2,-(a7)
  movea.l    a0,a2
  move.w     d0,d3
  jsr        ObjcGParent
  move.w     d0,d4
  moveq.l    #-1,d5
  ext.l      d0
  move.l     d0,d1
  add.l      d1,d1
  add.l      d0,d1
  lsl.l      #3,d1
  move.w     2(a2,d1.l),d4
  cmp.w      d4,d3
  beq.s      ~_277_1
~_277_3:
  move.w     #$0080,d0
  move.w     d4,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  and.w      8(a2,d1.l),d0
  bne.s      ~_277_2
  moveq.l    #8,d0
  and.w      10(a2,d1.l),d0
  bne.s      ~_277_2
  move.w     d4,d5
~_277_2:
  move.w     d4,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     0(a2,d0.l),d4
  cmp.w      d4,d3
  bne.s      ~_277_3
  cmp.w      #$FFFF,d5
  beq.s      ~_277_1
  move.w     d5,d0
  bra.s      ~_277_4
~_277_1:
  move.w     d3,d0
~_277_4:
  movem.l    (a7)+,d3-d5/a2
  rts

~_278:
  movem.l    d3-d5/a2,-(a7)
  movea.l    a0,a2
  move.w     d0,d3
  jsr        ObjcGParent
  move.w     d0,d4
  move.w     d3,d5
~_278_3:
  move.w     d5,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     0(a2,d0.l),d5
  cmp.w      d5,d4
  beq.s      ~_278_1
  move.w     #$0080,d0
  move.w     d5,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  and.w      8(a2,d1.l),d0
  bne.s      ~_278_1
  moveq.l    #8,d0
  and.w      10(a2,d1.l),d0
  bne.s      ~_278_1
  move.w     d5,d0
  bra.s      ~_278_2
~_278_1:
  cmp.w      d5,d4
  bne.s      ~_278_3
  move.w     d3,d0
~_278_2:
  movem.l    (a7)+,d3-d5/a2
  rts

~_279:
  movem.l    d3-d7/a2-a6,-(a7)
  lea.l      -96(a7),a7
  movea.l    a0,a5
  move.w     d0,d6
  move.w     d1,d5
  move.w     d2,d4
  move.w     140(a7),d3
  move.l     a1,80(a7)
  move.w     d0,d7
  move.w     d1,(a7)
  moveq.l    #3,d0
  jsr        WindUpdate
  lea.l      2(a7),a2
  lea.l      8(a7),a4
  pea.l      (a2)
  pea.l      8(a7)
  lea.l      14(a7),a1
  movea.l    a4,a0
  jsr        graf_mkstate
  addq.w     #8,a7
  tst.w      d4
  beq.s      ~_279_1
  add.w      (a4),d6
  add.w      6(a7),d5
~_279_1:
  cmp.w      #$FFFF,d3
  beq.s      ~_279_2
  tst.w      d4
  beq.s      ~_279_3
  pea.l      84(a7)
  lea.l      90(a7),a1
  move.w     d3,d0
  movea.l    a5,a0
  jsr        ObjcOffset
  addq.w     #4,a7
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     20(a5,d0.l),d2
  asr.w      #1,d2
  add.w      86(a7),d2
  sub.w      16(a5),d2
  sub.w      d2,d6
  move.w     22(a5,d0.l),d4
  asr.w      #1,d4
  add.w      84(a7),d4
  sub.w      18(a5),d4
  sub.w      d4,d5
  bra.s      ~_279_2
~_279_3:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  sub.w      16(a5,d0.l),d6
  sub.w      18(a5,d0.l),d5
~_279_2:
  lea.l      76(a7),a6
  pea.l      72(a7)
  pea.l      78(a7)
  movea.l    a6,a1
  lea.l      86(a7),a0
  jsr        HandScreenSize
  addq.w     #8,a7
  moveq.l    #-1,d3
  movea.l    146(a7),a0
  move.w     d3,(a0)
  movea.l    80(a7),a1
  clr.l      (a1)
  moveq.l    #1,d0
  add.w      78(a7),d0
  cmp.w      d0,d6
  bge.s      ~_279_4
  move.w     d0,d6
~_279_4:
  moveq.l    #1,d0
  add.w      (a6),d0
  cmp.w      d0,d5
  bge.s      ~_279_5
  move.w     d0,d5
~_279_5:
  move.w     20(a5),d0
  add.w      d6,d0
  addq.w     #3,d0
  move.w     78(a7),d1
  add.w      74(a7),d1
  cmp.w      d1,d0
  ble.s      ~_279_6
  move.w     d1,d6
  moveq.l    #3,d2
  add.w      20(a5),d2
  sub.w      d2,d6
~_279_6:
  move.w     22(a5),d0
  add.w      d5,d0
  addq.w     #3,d0
  move.w     (a6),d1
  add.w      72(a7),d1
  cmp.w      d1,d0
  ble.s      ~_279_7
  move.w     d1,d5
  moveq.l    #3,d2
  add.w      22(a5),d2
  sub.w      d2,d5
~_279_7:
  move.w     d6,16(a5)
  move.w     d5,18(a5)
  move.w     22(a5),d0
  lea.l      10(a7),a1
  movea.l    a5,a0
  jsr        DialStart
  tst.w      d0
  bne.s      ~_279_8
  move.w     142(a7),d0
  beq.s      ~_279_8
  movea.l    146(a7),a0
  move.w     #$FFFE,(a0)
  bra        ~_279_9
~_279_8:
  move.w     6(a7),-(a7)
  move.w     (a4),d2
  moveq.l    #8,d1
  clr.w      d0
  movea.l    a5,a0
  jsr        objc_find
  addq.w     #2,a7
  move.w     d0,d4
  move.w     d4,d5
  clr.w      d6
  addq.w     #1,d0
  bne.s      ~_279_10
  move.w     (a7),-(a7)
  move.w     d7,d2
  moveq.l    #8,d1
  movea.l    a5,a0
  move.w     d6,d0
  jsr        objc_find
  addq.w     #2,a7
  move.w     d0,d4
  move.w     d4,d5
  addq.w     #1,d0
  beq.s      ~_279_10
  or.w       #$0001,d6
~_279_10:
  cmp.w      #$FFFF,d4
  beq.s      ~_279_11
  moveq.l    #8,d0
  move.w     d4,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  and.w      10(a5,d1.l),d0
  bne.s      ~_279_12
  moveq.l    #1,d7
  and.w      8(a5,d1.l),d7
  bne.s      ~_279_11
~_279_12:
  moveq.l    #-1,d4
~_279_11:
  cmp.w      #$FFFF,d4
  beq.s      ~_279_13
  moveq.l    #1,d0
  move.w     d4,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  and.w      8(a5,d1.l),d0
  beq.s      ~_279_13
  ori.w      #$0001,10(a5,d1.l)
~_279_13:
  lea.l      10(a7),a0
  jsr        DialDraw
~_279_31:
  lea.l      84(a7),a3
  cmp.w      #$FFFF,d5
  beq.s      ~_279_14
  move.w     #$0001,92(a7)
  pea.l      2(a3)
  movea.l    a3,a1
  move.w     d5,d0
  movea.l    a5,a0
  jsr        ObjcOffset
  addq.w     #4,a7
  move.w     d5,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     20(a5,d0.l),4(a3)
  move.w     22(a5,d0.l),6(a3)
  bra.s      ~_279_15
~_279_14:
  clr.w      92(a7)
  pea.l      2(a3)
  movea.l    a3,a1
  clr.w      d0
  movea.l    a5,a0
  jsr        ObjcOffset
  addq.w     #4,a7
  move.w     20(a5),4(a3)
  move.w     22(a5),6(a3)
~_279_15:
  moveq.l    #1,d0
  and.w      d6,d0
  beq.s      ~_279_16
  move.w     #$0001,92(a7)
  move.w     (a4),(a3)
  move.w     6(a7),2(a3)
  moveq.l    #1,d1
  move.w     d1,6(a3)
  move.w     d1,4(a3)
~_279_16:
  pea.l      (a2)
  pea.l      98(a7)
  pea.l      (a2)
  pea.l      (a2)
  pea.l      22(a7)
  clr.w      -(a7)
  clr.w      -(a7)
  clr.w      -(a7)
  clr.w      -(a7)
  clr.w      -(a7)
  clr.w      -(a7)
  clr.w      -(a7)
  move.w     6(a3),-(a7)
  move.w     4(a3),-(a7)
  move.w     2(a3),-(a7)
  move.w     (a3),-(a7)
  move.w     134(a7),-(a7)
  move.w     48(a7),d0
  not.w      d0
  and.w      #$0001,d0
  move.w     d0,-(a7)
  movea.l    a4,a1
  suba.l     a0,a0
  moveq.l    #1,d2
  moveq.l    #1,d1
  moveq.l    #7,d0
  jsr        evnt_multi
  lea.l      46(a7),a7
  move.w     d0,d6
  move.w     d4,d3
  clr.w      d7
  moveq.l    #1,d1
  and.w      d0,d1
  beq.s      ~_279_17
  move.w     94(a7),d2
  and.w      #$FF00,d2
  cmp.w      #$5000,d2
  bne.s      ~_279_18
  tst.w      d4
  blt.s      ~_279_19
  move.w     d3,d0
  bra.s      ~_279_20
~_279_19:
  moveq.l    #1,d0
~_279_20:
  movea.l    a5,a0
  jsr        ~_278(pc)
  move.w     d0,d4
  move.w     d4,d5
~_279_18:
  move.w     94(a7),d0
  and.w      #$FF00,d0
  cmp.w      #$4800,d0
  bne.s      ~_279_21
  tst.w      d3
  blt.s      ~_279_22
  move.w     d3,d0
  bra.s      ~_279_23
~_279_22:
  moveq.l    #1,d0
~_279_23:
  movea.l    a5,a0
  jsr        ~_277(pc)
  move.w     d0,d4
  move.w     d4,d5
~_279_21:
  move.w     94(a7),d0
  and.w      #$FF00,d0
  cmp.w      #$6100,d0
  bne.s      ~_279_24
  moveq.l    #-1,d4
  move.w     d4,d7
~_279_24:
  move.w     94(a7),d0
  and.w      #$00FF,d0
  cmp.w      #$000D,d0
  bne.s      ~_279_25
  moveq.l    #1,d7
  bra.s      ~_279_25
~_279_17:
  move.w     6(a7),-(a7)
  move.w     (a4),d2
  moveq.l    #8,d1
  clr.w      d0
  movea.l    a5,a0
  jsr        objc_find
  addq.w     #2,a7
  move.w     d0,d4
  move.w     d4,d5
~_279_25:
  cmp.w      #$FFFF,d4
  beq.s      ~_279_26
  moveq.l    #8,d0
  move.w     d4,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  and.w      10(a5,d1.l),d0
  bne.s      ~_279_27
  moveq.l    #1,d0
  and.w      8(a5,d1.l),d0
  bne.s      ~_279_26
~_279_27:
  moveq.l    #-1,d4
~_279_26:
  cmp.w      d3,d4
  beq.s      ~_279_28
  cmp.w      #$FFFF,d3
  beq.s      ~_279_28
  moveq.l    #1,d0
  move.w     d0,-(a7)
  move.w     d3,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  move.w     10(a5,d1.l),d0
  and.w      #$FFFE,d0
  move.w     d0,-(a7)
  move.w     76(a7),-(a7)
  move.w     80(a7),-(a7)
  move.w     (a6),-(a7)
  movea.l    a5,a0
  move.w     d3,d0
  clr.w      d1
  move.w     88(a7),d2
  jsr        objc_change
  lea.l      10(a7),a7
~_279_28:
  cmp.w      #$FFFF,d4
  beq.s      ~_279_29
  moveq.l    #1,d0
  move.w     d0,-(a7)
  moveq.l    #1,d1
  move.w     d4,d0
  ext.l      d0
  move.l     d0,d2
  add.l      d2,d2
  add.l      d0,d2
  lsl.l      #3,d2
  or.w       10(a5,d2.l),d1
  move.w     d1,-(a7)
  move.w     76(a7),-(a7)
  move.w     80(a7),-(a7)
  move.w     (a6),-(a7)
  movea.l    a5,a0
  move.w     d4,d0
  clr.w      d1
  move.w     88(a7),d2
  jsr        objc_change
  lea.l      10(a7),a7
~_279_29:
  moveq.l    #2,d0
  and.w      d6,d0
  bne.s      ~_279_30
  tst.w      d7
  beq        ~_279_31
~_279_30:
  lea.l      10(a7),a0
  jsr        DialEnd
  move.w     4(a7),d0
  not.w      d0
  and.w      #$0001,d0
  beq.s      ~_279_32
  tst.w      d7
  bne.s      ~_279_32
  pea.l      (a2)
  pea.l      (a2)
  movea.l    a2,a1
  movea.l    a2,a0
  clr.w      d2
  moveq.l    #1,d1
  moveq.l    #1,d0
  jsr        evnt_button
  addq.w     #8,a7
~_279_32:
  cmp.w      #$FFFF,d4
  beq.s      ~_279_33
  movea.l    80(a7),a0
  move.l     a5,(a0)
  movea.l    146(a7),a1
  move.w     d4,(a1)
~_279_33:
  moveq.l    #2,d0
  jsr        WindUpdate
~_279_9:
  lea.l      96(a7),a7
  movem.l    (a7)+,d3-d7/a2-a6
  rts

~_280:
  movem.l    d3-d4/a2,-(a7)
  movea.l    a0,a2
  move.w     d0,d3
  jsr        ~_278(pc)
  move.w     d0,d4
  cmp.w      d0,d3
  bne.s      ~_280_1
  move.w     2(a2),d4
  move.w     #$0080,d0
  move.w     d4,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  and.w      8(a2,d1.l),d0
  bne.s      ~_280_2
  moveq.l    #8,d3
  and.w      10(a2,d1.l),d3
  beq.s      ~_280_1
~_280_2:
  move.w     d4,d0
  movea.l    a2,a0
  jsr        ~_278(pc)
  move.w     d0,d4
~_280_1:
  move.w     d4,d0
  movem.l    (a7)+,d3-d4/a2
  rts

JazzSelect:
  movem.l    d3-d7/a2-a5,-(a7)
  lea.l      -10(a7),a7
  movea.l    a0,a4
  move.w     d0,d7
  movea.l    a1,a2
  move.w     d1,d5
  move.w     d2,d6
  movea.l    50(a7),a3
  moveq.l    #-1,d3
  clr.w      d4
JazzSelect_4:
  moveq.l    #1,d0
  move.w     d4,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  and.w      8(a2,d1.l),d0
  beq.s      JazzSelect_1
  andi.w     #$FFFE,10(a2,d1.l)
JazzSelect_1:
  tst.w      d5
  beq.s      JazzSelect_2
  move.w     d4,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  andi.w     #$FFFB,10(a2,d0.l)
JazzSelect_2:
  move.w     d4,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.l     12(a2,d0.l),d2
  cmp.l      (a3),d2
  bne.s      JazzSelect_3
  move.w     d4,d3
JazzSelect_3:
  addq.w     #1,d4
  moveq.l    #32,d0
  moveq.l    #-1,d2
  add.w      d4,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  and.w      8(a2,d1.l),d0
  beq.s      JazzSelect_4
  cmp.w      #$FFFF,d3
  bne.s      JazzSelect_5
  clr.w      d0
  bra        JazzSelect_6
JazzSelect_5:
  tst.w      d5
  beq.s      JazzSelect_7
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  ori.w      #$0004,10(a2,d0.l)
JazzSelect_7:
  lea.l      4(a7),a5
  tst.w      d6
  bne.s      JazzSelect_8
  pea.l      6(a7)
  lea.l      12(a7),a1
  move.w     d7,d0
  movea.l    a4,a0
  jsr        ObjcOffset
  addq.w     #4,a7
  pea.l      (a5)
  moveq.l    #1,d0
  move.w     d0,-(a7)
  move.w     d0,-(a7)
  move.w     d3,-(a7)
  lea.l      10(a7),a1
  clr.w      d2
  move.w     16(a7),d1
  movea.l    a2,a0
  move.w     18(a7),d0
  jsr        ~_279(pc)
  lea.l      10(a7),a7
  bra.s      JazzSelect_9
JazzSelect_8:
  cmp.w      #$0001,d6
  bne.s      JazzSelect_10
  move.w     d3,d0
  movea.l    a2,a0
  jsr        ~_278(pc)
  move.w     d0,(a5)
  bra.s      JazzSelect_9
JazzSelect_10:
  cmp.w      #$FFFF,d6
  bne.s      JazzSelect_11
  move.w     d3,d0
  movea.l    a2,a0
  jsr        ~_277(pc)
  move.w     d0,(a5)
  bra.s      JazzSelect_9
JazzSelect_11:
  move.w     d3,d0
  movea.l    a2,a0
  jsr        ~_280(pc)
  move.w     d0,(a5)
JazzSelect_9:
  cmpi.w     #$FFFE,(a5)
  bne.s      JazzSelect_12
  move.w     d3,d0
  movea.l    a2,a0
  jsr        ~_280(pc)
  move.w     d0,(a5)
JazzSelect_12:
  cmpi.w     #$FFFF,(a5)
  beq.s      JazzSelect_13
  move.w     (a5),d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.l     12(a2,d0.l),(a3)
  bra.s      JazzSelect_14
JazzSelect_13:
  clr.l      (a3)
JazzSelect_14:
  move.w     (a5),d0
JazzSelect_6:
  lea.l      10(a7),a7
  movem.l    (a7)+,d3-d7/a2-a5
  rts

JazzUp:
  move.l     8(a7),-(a7)
  clr.w      -(a7)
  move.w     12(a7),-(a7)
  move.w     12(a7),-(a7)
  jsr        ~_279(pc)
  lea.l      10(a7),a7
  rts

~_281:
  movem.l    d3-d6/a2,-(a7)
  lea.l      -16(a7),a7
  move.w     d0,d6
  move.w     d1,d5
  lea.l      ~_317,a2
  movea.l    (a2),a0
  move.w     4(a0),d3
  move.w     6(a0),d4
  move.w     d4,-(a7)
  lea.l      2(a7),a0
  move.w     d3,d2
  clr.w      d0
  move.w     d0,d1
  jsr        RectAES2VDI
  addq.w     #2,a7
  move.w     d4,-(a7)
  lea.l      10(a7),a0
  move.w     d3,d2
  move.w     d5,d1
  move.w     d6,d0
  jsr        RectAES2VDI
  addq.w     #2,a7
  pea.l      ~_310
  pea.l      ~_308
  moveq.l    #1,d0
  and.w      50(a7),d0
  beq.s      ~_281_1
  movea.l    4(a2),a1
  bra.s      ~_281_2
~_281_1:
  movea.l    (a2),a1
~_281_2:
  lea.l      8(a7),a0
  moveq.l    #3,d1
  move.w     DialWk,d0
  jsr        vrt_cpyfm
  addq.w     #8,a7
  lea.l      16(a7),a7
  movem.l    (a7)+,d3-d6/a2
  rts

~_282:
  movem.l    d3-d6/a3,-(a7)
  subq.w     #8,a7
  move.w     d0,d6
  move.w     d1,d5
  move.w     d2,d4
  move.w     32(a7),d3
  move.w     d3,-(a7)
  lea.l      2(a7),a0
  jsr        RectAES2VDI
  addq.w     #2,a7
  lea.l      DialWk,a3
  moveq.l    #1,d1
  move.w     (a3),d0
  jsr        vsf_color
  moveq.l    #1,d1
  move.w     (a3),d0
  jsr        vsf_perimeter
  clr.w      d1
  move.w     (a3),d0
  jsr        vsf_interior
  lea.l      (a7),a0
  move.w     (a3),d0
  jsr        v_bar
  moveq.l    #-4,d0
  add.w      d3,d0
  move.w     d0,-(a7)
  lea.l      2(a7),a0
  moveq.l    #-4,d2
  add.w      d4,d2
  moveq.l    #2,d1
  add.w      d5,d1
  moveq.l    #2,d0
  add.w      d6,d0
  jsr        RectAES2VDI
  addq.w     #2,a7
  moveq.l    #1,d0
  and.w      34(a7),d0
  beq.s      ~_282_1
  moveq.l    #1,d1
  bra.s      ~_282_2
~_282_1:
  clr.w      d1
~_282_2:
  move.w     (a3),d0
  jsr        vsf_interior
  lea.l      (a7),a0
  move.w     (a3),d0
  jsr        v_bar
  addq.w     #8,a7
  movem.l    (a7)+,d3-d6/a3
  rts

~_283:
  movem.l    d3-d5/a2-a3,-(a7)
  clr.w      d3
  lea.l      ~_311,a2
  movea.l    (a2),a3
  move.l     (a2),d0
  beq.s      ~_283_1
  move.w     d3,d4
  bra.s      ~_283_2
~_283_4:
  move.w     d4,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #3,d0
  sub.l      d1,d0
  add.l      d0,d0
  movea.l    (a2),a0
  move.l     0(a0,d0.l),d2
  beq.s      ~_283_3
  addq.w     #1,d3
~_283_3:
  addq.w     #1,d4
~_283_2:
  move.w     d4,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #3,d0
  sub.l      d1,d0
  add.l      d0,d0
  movea.l    (a2),a0
  moveq.l    #-1,d2
  cmp.l      0(a0,d0.l),d2
  bne.s      ~_283_4
  moveq.l    #20,d5
  add.w      d3,d5
  bra.s      ~_283_5
~_283_1:
  moveq.l    #100,d5
  add.w      d3,d5
~_283_5:
  move.w     d5,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #3,d0
  sub.l      d1,d0
  add.l      d0,d0
  movea.l    dialmalloc,a0
  jsr        (a0)
  move.l     a0,(a2)
  move.l     a0,d0
  bne.s      ~_283_6
  move.l     a3,(a2)
  clr.w      d0
  bra.s      ~_283_7
~_283_6:
  move.w     d5,d0
  ext.l      d0
  move.l     d0,d1
  lsl.l      #3,d1
  sub.l      d0,d1
  add.l      d1,d1
  movea.l    (a2),a0
  clr.w      d0
  jsr        memset
  moveq.l    #-1,d1
  add.w      d5,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #3,d0
  sub.l      d1,d0
  add.l      d0,d0
  movea.l    (a2),a0
  move.l     #$FFFFFFFF,0(a0,d0.l)
  move.l     a3,d2
  beq.s      ~_283_8
  clr.w      d4
  bra.s      ~_283_9
~_283_11:
  move.l     (a3),d0
  beq.s      ~_283_10
  movea.l    a3,a0
  move.w     d4,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #3,d0
  sub.l      d1,d0
  add.l      d0,d0
  movea.l    (a2),a1
  adda.l     d0,a1
  move.l     (a0)+,(a1)+
  move.l     (a0)+,(a1)+
  move.l     (a0)+,(a1)+
  move.w     (a0)+,(a1)+
~_283_10:
  addq.w     #1,d4
  lea.l      14(a3),a3
~_283_9:
  moveq.l    #-1,d0
  cmp.l      (a3),d0
  bne.s      ~_283_11
  movea.l    a3,a0
  movea.l    dialfree,a1
  jsr        (a1)
~_283_8:
  moveq.l    #1,d0
~_283_7:
  movem.l    (a7)+,d3-d5/a2-a3
  rts

~_284:
  movea.l    ~_311,a0
  move.l     a0,d0
  beq.s      ~_284_1
~_284_3:
  move.l     (a0),d0
  bne.s      ~_284_2
  rts
~_284_2:
  lea.l      14(a0),a0
  moveq.l    #-1,d0
  cmp.l      (a0),d0
  bne.s      ~_284_3
~_284_1:
  suba.l     a0,a0
  rts

~_285:
  move.l     d3,-(a7)
  move.l     a2,-(a7)
  move.l     d0,d3
  jsr        ~_284(pc)
  movea.l    a0,a2
  move.l     a2,d0
  bne.s      ~_285_1
  jsr        ~_283(pc)
  tst.w      d0
  bne.s      ~_285_2
  suba.l     a0,a0
  bra.s      ~_285_3
~_285_2:
  jsr        ~_284(pc)
  movea.l    a0,a2
~_285_1:
  move.l     d3,(a2)
  movea.l    a2,a0
~_285_3:
  movea.l    (a7)+,a2
  move.l     (a7)+,d3
  rts

~_286:
  movem.l    d3-d4/a2,-(a7)
  move.l     d0,d4
  lea.l      ~_311,a2
  move.l     (a2),d1
  beq.s      ~_286_1
  clr.w      d3
  bra.s      ~_286_2
~_286_4:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #3,d0
  sub.l      d1,d0
  add.l      d0,d0
  movea.l    (a2),a0
  cmp.l      0(a0,d0.l),d4
  bne.s      ~_286_3
  clr.l      0(a0,d0.l)
~_286_3:
  addq.w     #1,d3
~_286_2:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #3,d0
  sub.l      d1,d0
  add.l      d0,d0
  movea.l    (a2),a0
  moveq.l    #-1,d2
  cmp.l      0(a0,d0.l),d2
  bne.s      ~_286_4
~_286_1:
  movem.l    (a7)+,d3-d4/a2
  rts

~_287:
  move.l     a2,-(a7)
  move.l     a3,-(a7)
  subq.w     #8,a7
  movea.l    20(a7),a2
  move.w     6(a2),d0
  cmp.w      8(a2),d0
  bne        ~_287_1
  moveq.l    #1,d1
  move.w     d1,-(a7)
  move.w     24(a2),-(a7)
  move.w     22(a2),d2
  move.w     20(a2),d1
  move.w     18(a2),d0
  jsr        HandClip
  addq.w     #4,a7
  lea.l      DialWk,a3
  movea.l    26(a2),a0
  move.w     12(a2),d2
  move.w     10(a2),d1
  move.w     (a3),d0
  jsr        v_gtext
  moveq.l    #1,d0
  move.w     d0,-(a7)
  lea.l      2(a7),a0
  move.w     14(a2),d2
  move.w     12(a2),d1
  add.w      16(a2),d1
  subq.w     #1,d1
  move.w     10(a2),d0
  jsr        RectAES2VDI
  addq.w     #2,a7
  moveq.l    #1,d1
  move.w     (a3),d0
  jsr        vsl_type
  moveq.l    #1,d1
  move.w     (a3),d0
  jsr        vsl_color
  lea.l      (a7),a0
  moveq.l    #2,d1
  move.w     (a3),d0
  jsr        v_pline
  clr.w      -(a7)
  clr.w      -(a7)
  clr.w      d2
  clr.w      d1
  clr.w      d0
  jsr        HandClip
  addq.w     #4,a7
~_287_1:
  move.w     8(a2),d0
  addq.w     #8,a7
  movea.l    (a7)+,a3
  movea.l    (a7)+,a2
  rts

ObjcAnimImage:
  movem.l    a2-a5,-(a7)
  lea.l      -16(a7),a7
  movea.l    36(a7),a2
  movea.l    26(a2),a3
  moveq.l    #1,d0
  move.w     d0,-(a7)
  move.w     24(a2),-(a7)
  move.w     22(a2),d2
  move.w     20(a2),d1
  move.w     18(a2),d0
  jsr        HandClip
  addq.w     #4,a7
  addq.w     #1,8(a3)
  move.w     8(a3),d0
  ext.l      d0
  lsl.l      #2,d0
  movea.l    (a3),a0
  move.l     0(a0,d0.l),d1
  bne.s      ObjcAnimImage_1
  clr.w      8(a3)
ObjcAnimImage_1:
  move.w     8(a3),d0
  ext.l      d0
  lsl.l      #2,d0
  movea.l    (a3),a0
  movea.l    0(a0,d0.l),a3
  lea.l      ~_320,a4
  move.l     (a3),(a4)
  move.w     4(a3),d0
  lsl.w      #3,d0
  move.w     d0,4(a4)
  move.w     6(a3),6(a4)
  move.w     4(a3),d1
  asr.w      #1,d1
  move.w     d1,8(a4)
  clr.w      10(a4)
  move.w     #$0001,12(a4)
  lea.l      ~_312,a5
  move.w     12(a3),(a5)
  move.w     6(a3),-(a7)
  lea.l      2(a7),a0
  move.w     d0,d2
  move.w     10(a3),d1
  move.w     8(a3),d0
  jsr        RectAES2VDI
  addq.w     #2,a7
  move.w     6(a3),-(a7)
  lea.l      10(a7),a0
  move.w     4(a3),d2
  lsl.w      #3,d2
  move.w     12(a2),d1
  move.w     10(a2),d0
  jsr        RectAES2VDI
  addq.w     #2,a7
  pea.l      (a5)
  pea.l      -36(a5)
  movea.l    a4,a1
  lea.l      8(a7),a0
  moveq.l    #3,d1
  move.w     DialWk,d0
  jsr        vrt_cpyfm
  addq.w     #8,a7
  clr.w      -(a7)
  clr.w      -(a7)
  clr.w      d2
  clr.w      d1
  clr.w      d0
  jsr        HandClip
  addq.w     #4,a7
  clr.w      d0
  lea.l      16(a7),a7
  movem.l    (a7)+,a2-a5
  rts

~_288:
  move.l     a2,-(a7)
  movea.l    8(a7),a2
  move.w     6(a2),d0
  cmp.w      8(a2),d0
  bne        ~_288_1
  moveq.l    #1,d1
  move.w     d1,-(a7)
  move.w     24(a2),-(a7)
  move.w     22(a2),d2
  move.w     20(a2),d1
  move.w     18(a2),d0
  jsr        HandClip
  addq.w     #4,a7
  moveq.l    #1,d1
  move.w     DialWk,d0
  jsr        vswr_mode
  move.w     16(a2),d0
  move.w     HandYSize,d1
  asr.w      #1,d1
  sub.w      d1,d0
  move.w     d0,-(a7)
  move.w     14(a2),-(a7)
  move.w     d1,d2
  add.w      12(a2),d2
  move.w     10(a2),d1
  move.w     DialWk,d0
  jsr        RastDrawRect
  addq.w     #4,a7
  movea.l    26(a2),a0
  move.w     12(a2),d2
  move.w     10(a2),d1
  add.w      HandXSize,d1
  move.w     DialWk,d0
  jsr        v_gtext
  clr.w      -(a7)
  clr.w      -(a7)
  clr.w      d2
  clr.w      d1
  clr.w      d0
  jsr        HandClip
  addq.w     #4,a7
~_288_1:
  move.w     8(a2),d0
  movea.l    (a7)+,a2
  rts

~_289:
  movem.l    d3/a2-a3,-(a7)
  movea.w    a0,a2
  moveq.l    #-1,d3
  movea.l    a0,a3
  bra.s      ~_289_1
~_289_4:
  cmpi.b     #$5B,(a3)
  bne.s      ~_289_2
  lea.l      1(a3),a1
  movea.l    a3,a0
  jsr        strcpy
  cmpi.b     #$5B,(a3)
  beq.s      ~_289_3
  move.w     a3,d3
  sub.w      a2,d3
~_289_3:
  addq.w     #1,a3
~_289_2:
  addq.w     #1,a3
~_289_1:
  move.b     (a3),d0
  bne.s      ~_289_4
  move.w     d3,d0
  movem.l    (a7)+,d3/a2-a3
  rts

~_290:
  movem.l    d3-d6/a2-a3,-(a7)
  subq.w     #2,a7
  move.w     d0,d5
  move.w     d1,d4
  movea.l    a0,a3
  move.w     d2,d6
  move.w     30(a7),d3
  lea.l      DialWk,a2
  moveq.l    #8,d2
  and.w      d3,d2
  beq.s      ~_290_1
  moveq.l    #2,d1
  bra.s      ~_290_2
~_290_1:
  clr.w      d1
~_290_2:
  move.w     (a2),d0
  jsr        vst_effects
  movea.l    a3,a0
  move.w     d4,d2
  move.w     d5,d1
  move.w     (a2),d0
  jsr        v_gtext
  moveq.l    #4,d0
  and.w      d3,d0
  beq.s      ~_290_3
  lea.l      ~_315,a0
  move.w     d4,d2
  move.w     d5,d1
  move.w     (a2),d0
  jsr        v_gtext
~_290_3:
  cmp.w      #$FFFF,d6
  beq.s      ~_290_4
  move.b     0(a3,d6.w),(a7)
  clr.b      1(a7)
  moveq.l    #8,d0
  and.w      d3,d0
  beq.s      ~_290_5
  moveq.l    #10,d1
  bra.s      ~_290_6
~_290_5:
  moveq.l    #8,d1
~_290_6:
  move.w     (a2),d0
  jsr        vst_effects
  lea.l      (a7),a0
  move.w     d4,d2
  move.w     d6,d1
  muls.w     HandXSize,d1
  add.w      d5,d1
  move.w     (a2),d0
  jsr        v_gtext
~_290_4:
  addq.w     #2,a7
  movem.l    (a7)+,d3-d6/a2-a3
  rts

ObjcMyButton:
  movem.l    d3-d7/a2-a4,-(a7)
  lea.l      -100(a7),a7
  movea.l    136(a7),a2
  clr.w      86(a7)
  clr.w      84(a7)
  moveq.l    #1,d0
  move.w     d0,-(a7)
  move.w     24(a2),-(a7)
  move.w     22(a2),d2
  move.w     20(a2),d1
  move.w     18(a2),d0
  jsr        HandClip
  addq.w     #4,a7
  move.w     4(a2),d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  movea.l    (a2),a0
  move.w     8(a0,d0.l),d5
  move.w     8(a2),d6
  move.w     10(a2),d7
  move.w     12(a2),90(a7)
  move.w     14(a2),d4
  move.w     16(a2),88(a7)
  moveq.l    #2,d2
  and.w      d6,d2
  beq.s      ObjcMyButton_1
  cmp.w      6(a2),d6
  beq.s      ObjcMyButton_1
  moveq.l    #5,d0
  and.w      d6,d0
  bne.s      ObjcMyButton_2
  or.w       #$0004,d6
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     d6,10(a0,d0.l)
  bra.s      ObjcMyButton_1
ObjcMyButton_2:
  moveq.l    #5,d0
  and.w      d6,d0
  subq.w     #5,d0
  bne.s      ObjcMyButton_1
  and.w      #$FFFA,d6
  move.w     4(a2),d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  movea.l    (a2),a0
  move.w     d6,10(a0,d0.l)
ObjcMyButton_1:
  lea.l      DialWk,a3
  moveq.l    #1,d1
  move.w     (a3),d0
  jsr        vswr_mode
  movea.l    26(a2),a1
  lea.l      (a7),a0
  jsr        strcpy
  lea.l      (a7),a0
  jsr        ~_289(pc)
  move.w     d0,80(a7)
  move.w     4(a2),d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  movea.l    (a2),a0
  move.w     6(a0,d1.l),d0
  and.w      #$FF00,d0
  cmp.w      #$1A00,d0
  beq.s      ObjcMyButton_3
  clr.w      -(a7)
  lea.l      2(a7),a0
  move.w     d7,d0
  move.w     92(a7),d1
  move.w     82(a7),d2
  jsr        ~_290(pc)
  addq.w     #2,a7
  clr.w      d1
  move.w     (a3),d0
  jsr        vst_effects
  clr.w      -(a7)
  clr.w      -(a7)
  clr.w      d2
  clr.w      d1
  clr.w      d0
  jsr        HandClip
  addq.w     #4,a7
  bra        ObjcMyButton_4
ObjcMyButton_3:
  move.w     88(a7),d0
  sub.w      HandYSize,d0
  asr.w      #1,d0
  add.w      90(a7),d0
  move.w     d0,82(a7)
  lea.l      (a7),a0
  jsr        strlen
  muls.w     HandXSize,d0
  move.w     d4,d3
  sub.w      d0,d3
  asr.w      #1,d3
  add.w      d7,d3
  moveq.l    #4,d0
  and.w      d5,d0
  bne.s      ObjcMyButton_5
  move.w     HandXSize,d4
  add.w      d4,d4
  move.w     d7,d3
  add.w      d4,d3
  add.w      HandXSize,d3
  subq.w     #1,d4
  subq.w     #1,88(a7)
ObjcMyButton_5:
  moveq.l    #4,d0
  and.w      d6,d0
  beq.s      ObjcMyButton_6
  moveq.l    #1,d1
  bra.s      ObjcMyButton_7
ObjcMyButton_6:
  clr.w      d1
ObjcMyButton_7:
  move.w     (a3),d0
  jsr        vsf_color
  moveq.l    #4,d0
  and.w      d6,d0
  beq.s      ObjcMyButton_8
  moveq.l    #2,d1
  bra.s      ObjcMyButton_9
ObjcMyButton_8:
  moveq.l    #1,d1
ObjcMyButton_9:
  move.w     (a3),d0
  jsr        vsf_interior
  moveq.l    #1,d1
  move.w     (a3),d0
  jsr        vsf_style
  move.w     88(a7),-(a7)
  lea.l      94(a7),a0
  move.w     d4,d2
  move.w     92(a7),d1
  move.w     d7,d0
  jsr        RectAES2VDI
  addq.w     #2,a7
  lea.l      92(a7),a0
  move.w     (a3),d0
  jsr        v_bar
  moveq.l    #16,d0
  and.w      d5,d0
  beq.s      ObjcMyButton_10
  clr.w      d1
  bra.s      ObjcMyButton_11
ObjcMyButton_10:
  move.w     d6,d1
ObjcMyButton_11:
  move.w     d1,-(a7)
  move.w     82(a7),d2
  lea.l      2(a7),a0
  move.w     84(a7),d1
  move.w     d3,d0
  jsr        ~_290(pc)
  addq.w     #2,a7
  moveq.l    #2,d0
  and.w      d5,d0
  beq.s      ObjcMyButton_12
  addq.w     #1,84(a7)
ObjcMyButton_12:
  moveq.l    #4,d0
  and.w      d5,d0
  beq.s      ObjcMyButton_13
  addq.w     #1,84(a7)
  bra.s      ObjcMyButton_14
ObjcMyButton_13:
  clr.w      d0
  move.w     d0,86(a7)
  move.w     d0,84(a7)
ObjcMyButton_14:
  moveq.l    #16,d0
  and.w      d6,d0
  beq.s      ObjcMyButton_15
  moveq.l    #2,d1
  move.w     d1,86(a7)
  move.w     d1,84(a7)
ObjcMyButton_15:
  moveq.l    #8,d0
  and.w      d6,d0
  beq.s      ObjcMyButton_16
  moveq.l    #20,d1
  and.w      d5,d1
  bne.s      ObjcMyButton_16
  move.w     (a3),d0
  move.w     #$5555,d1
  jsr        vsl_udsty
  moveq.l    #7,d1
  move.w     (a3),d0
  jsr        vsl_type
ObjcMyButton_16:
  moveq.l    #16,d0
  and.w      d5,d0
  bne.s      ObjcMyButton_17
  move.w     86(a7),d3
  bra.s      ObjcMyButton_18
ObjcMyButton_19:
  move.w     d3,d0
  add.w      d0,d0
  add.w      88(a7),d0
  move.w     d0,-(a7)
  move.w     d3,d1
  add.w      d1,d1
  add.w      d4,d1
  move.w     d1,-(a7)
  move.w     94(a7),d2
  sub.w      d3,d2
  move.w     d7,d1
  sub.w      d3,d1
  move.w     (a3),d0
  jsr        RastDrawRect
  addq.w     #4,a7
  addq.w     #1,d3
ObjcMyButton_18:
  cmp.w      84(a7),d3
  ble.s      ObjcMyButton_19
ObjcMyButton_17:
  moveq.l    #4,d0
  and.w      d5,d0
  bne.s      ObjcMyButton_20
  moveq.l    #16,d1
  and.w      d5,d1
  beq.s      ObjcMyButton_21
  move.w     d6,-(a7)
  move.w     90(a7),-(a7)
  move.w     d4,d2
  movea.l    ~_319,a0
  move.w     d7,d0
  move.w     94(a7),d1
  jsr        (a0)
  addq.w     #4,a7
  bra        ObjcMyButton_22
ObjcMyButton_21:
  moveq.l    #1,d0
  and.w      d6,d0
  beq        ObjcMyButton_22
  lea.l      92(a7),a4
  moveq.l    #-2,d1
  add.w      88(a7),d1
  move.w     d1,-(a7)
  movea.l    a4,a0
  moveq.l    #-2,d2
  add.w      d4,d2
  moveq.l    #1,d1
  add.w      92(a7),d1
  moveq.l    #1,d0
  add.w      d7,d0
  jsr        RectAES2VDI
  addq.w     #2,a7
  movea.l    a4,a0
  moveq.l    #2,d1
  move.w     (a3),d0
  jsr        v_pline
  move.w     (a4),d0
  move.w     4(a4),(a4)
  move.w     d0,4(a4)
  movea.l    a4,a0
  moveq.l    #2,d1
  move.w     (a3),d0
  jsr        v_pline
  bra.s      ObjcMyButton_22
ObjcMyButton_20:
  moveq.l    #1,d0
  and.w      d6,d0
  beq.s      ObjcMyButton_22
  moveq.l    #-2,d1
  add.w      88(a7),d1
  move.w     d1,-(a7)
  lea.l      94(a7),a0
  moveq.l    #-2,d2
  add.w      d4,d2
  moveq.l    #1,d1
  add.w      92(a7),d1
  moveq.l    #1,d0
  add.w      d7,d0
  jsr        RectAES2VDI
  addq.w     #2,a7
  clr.w      d1
  move.w     (a3),d0
  jsr        vsf_perimeter
  moveq.l    #3,d1
  move.w     (a3),d0
  jsr        vswr_mode
  moveq.l    #1,d1
  move.w     (a3),d0
  jsr        vsf_color
  moveq.l    #1,d1
  move.w     (a3),d0
  jsr        vsf_interior
  lea.l      92(a7),a0
  move.w     (a3),d0
  jsr        v_bar
ObjcMyButton_22:
  clr.w      d1
  move.w     (a3),d0
  jsr        vst_effects
  clr.w      -(a7)
  clr.w      -(a7)
  clr.w      d2
  clr.w      d1
  clr.w      d0
  jsr        HandClip
  addq.w     #4,a7
  moveq.l    #8,d0
  and.w      d6,d0
  beq.s      ObjcMyButton_23
  moveq.l    #20,d1
  and.w      d5,d1
  bne.s      ObjcMyButton_23
  move.w     (a3),d0
  moveq.l    #1,d1
  jsr        vsl_type
ObjcMyButton_23:
  moveq.l    #16,d0
  and.w      d5,d0
  beq.s      ObjcMyButton_4
  moveq.l    #8,d0
  and.w      d6,d0
  bra.s      ObjcMyButton_24
ObjcMyButton_4:
  clr.w      d0
ObjcMyButton_24:
  lea.l      100(a7),a7
  movem.l    (a7)+,d3-d7/a2-a4
  rts

~_291:
  movem.l    d3-d6/a2,-(a7)
  lea.l      -16(a7),a7
  movea.l    40(a7),a2
  moveq.l    #-2,d3
  add.w      10(a2),d3
  moveq.l    #-2,d4
  add.w      12(a2),d4
  moveq.l    #4,d5
  add.w      14(a2),d5
  moveq.l    #4,d6
  add.w      16(a2),d6
  moveq.l    #1,d0
  move.w     d0,-(a7)
  move.w     24(a2),-(a7)
  move.w     22(a2),d2
  move.w     20(a2),d1
  move.w     18(a2),d0
  jsr        HandClip
  addq.w     #4,a7
  move.w     d6,-(a7)
  lea.l      2(a7),a0
  move.w     d5,d2
  move.w     d4,d1
  move.w     d3,d0
  jsr        RectAES2VDI
  addq.w     #2,a7
  lea.l      DialWk,a2
  moveq.l    #1,d1
  move.w     (a2),d0
  jsr        vswr_mode
  clr.w      d1
  move.w     (a2),d0
  jsr        vsl_color
  moveq.l    #-2,d0
  add.w      d6,d0
  move.w     d0,-(a7)
  moveq.l    #-2,d1
  add.w      d5,d1
  move.w     d1,-(a7)
  moveq.l    #1,d2
  add.w      d4,d2
  moveq.l    #1,d1
  add.w      d3,d1
  move.w     (a2),d0
  jsr        RastDrawRect
  addq.w     #4,a7
  moveq.l    #1,d1
  move.w     (a2),d0
  jsr        vsl_color
  moveq.l    #-6,d0
  add.w      d6,d0
  move.w     d0,-(a7)
  moveq.l    #-6,d1
  add.w      d5,d1
  move.w     d1,-(a7)
  moveq.l    #3,d2
  add.w      d4,d2
  moveq.l    #3,d1
  add.w      d3,d1
  move.w     (a2),d0
  jsr        RastDrawRect
  addq.w     #4,a7
  moveq.l    #1,d0
  add.w      d6,d0
  move.w     d0,-(a7)
  moveq.l    #1,d1
  add.w      d5,d1
  move.w     d1,-(a7)
  moveq.l    #-1,d2
  add.w      d4,d2
  move.w     (a2),d0
  move.w     d3,d1
  jsr        RastDrawRect
  addq.w     #4,a7
  lea.l      (a7),a0
  moveq.l    #2,d1
  move.w     (a2),d0
  jsr        v_pline
  clr.w      -(a7)
  clr.w      -(a7)
  clr.w      d2
  clr.w      d1
  clr.w      d0
  jsr        HandClip
  addq.w     #4,a7
  clr.w      d0
  lea.l      16(a7),a7
  movem.l    (a7)+,d3-d6/a2
  rts

~_292:
  movem.l    d3-d4/a2/a4,-(a7)
  lea.l      -16(a7),a7
  movea.l    36(a7),a2
  movea.l    ~_318,a0
  move.w     4(a0),d3
  move.w     6(a0),d4
  moveq.l    #1,d0
  move.w     d0,-(a7)
  move.w     24(a2),-(a7)
  move.w     22(a2),d2
  move.w     20(a2),d1
  move.w     18(a2),d0
  jsr        HandClip
  addq.w     #4,a7
  moveq.l    #2,d0
  add.w      16(a2),d0
  move.w     d0,-(a7)
  lea.l      2(a7),a0
  moveq.l    #2,d2
  add.w      14(a2),d2
  moveq.l    #-1,d1
  add.w      12(a2),d1
  moveq.l    #-1,d0
  add.w      10(a2),d0
  jsr        RectAES2VDI
  addq.w     #2,a7
  moveq.l    #8,d0
  lea.l      (a7),a1
  lea.l      8(a7),a0
  jsr        memcpy
  lea.l      ~_308,a4
  pea.l      (a4)
  movea.l    a4,a1
  lea.l      4(a7),a0
  moveq.l    #15,d1
  move.w     DialWk,d0
  jsr        vro_cpyfm
  addq.w     #4,a7
  move.w     16(a2),-(a7)
  lea.l      2(a7),a0
  move.w     14(a2),d2
  move.w     12(a2),d1
  move.w     10(a2),d0
  jsr        RectAES2VDI
  addq.w     #2,a7
  moveq.l    #8,d0
  lea.l      (a7),a1
  lea.l      8(a7),a0
  jsr        memcpy
  pea.l      (a4)
  movea.l    a4,a1
  lea.l      4(a7),a0
  clr.w      d1
  move.w     DialWk,d0
  jsr        vro_cpyfm
  addq.w     #4,a7
  move.w     d4,-(a7)
  lea.l      2(a7),a0
  move.w     d3,d2
  clr.w      d1
  clr.w      d0
  jsr        RectAES2VDI
  addq.w     #2,a7
  pea.l      40(a4)
  pea.l      (a4)
  movea.l    ~_318,a1
  lea.l      8(a7),a0
  moveq.l    #3,d1
  move.w     DialWk,d0
  jsr        vrt_cpyfm
  addq.w     #8,a7
  clr.w      -(a7)
  clr.w      -(a7)
  clr.w      d2
  clr.w      d1
  clr.w      d0
  jsr        HandClip
  addq.w     #4,a7
  moveq.l    #8,d0
  and.w      8(a2),d0
  lea.l      16(a7),a7
  movem.l    (a7)+,d3-d4/a2/a4
  rts

ObjcInit:
  movem.l    d3/a2-a3,-(a7)
  jsr        ~_283(pc)
  lea.l      ~_317,a3
  move.l     #~_282,24(a3)
  clr.w      d3
  lea.l      ~_306,a2
  bra.s      ObjcInit_1
ObjcInit_3:
  moveq.l    #12,d0
  muls.w     d3,d0
  move.w     HandXSize,d1
  cmp.w      8(a2,d0.w),d1
  bne.s      ObjcInit_2
  move.w     HandYSize,d2
  cmp.w      10(a2,d0.w),d2
  bne.s      ObjcInit_2
  lea.l      0(a2,d0.w),a0
  movea.l    a3,a1
  move.l     (a0)+,(a1)+
  move.l     (a0)+,(a1)+
  move.l     (a0)+,(a1)+
  movea.l    (a3),a0
  move.w     6(a0),d1
  move.w     8(a0),d0
  add.w      d0,d0
  movea.l    (a0),a0
  move.w     DialWk,d2
  jsr        RastTrans
  move.w     DialWk,d2
  movea.l    4(a3),a0
  move.w     6(a0),d1
  move.w     8(a0),d0
  add.w      d0,d0
  movea.l    (a0),a0
  jsr        RastTrans
  move.l     #~_281,24(a3)
ObjcInit_2:
  addq.w     #1,d3
ObjcInit_1:
  cmp.w      #$0002,d3
  blt.s      ObjcInit_3
  clr.w      d3
  bra.s      ObjcInit_4
ObjcInit_6:
  moveq.l    #12,d0
  muls.w     d3,d0
  move.w     HandXSize,d1
  cmp.w      8(a2,d0.w),d1
  bne.s      ObjcInit_5
  move.w     HandYSize,d2
  cmp.w      10(a2,d0.w),d2
  bne.s      ObjcInit_5
  lea.l      24(a2,d0.w),a0
  lea.l      12(a3),a1
  move.l     (a0)+,(a1)+
  move.l     (a0)+,(a1)+
  move.l     (a0)+,(a1)+
  movea.l    12(a3),a0
  move.w     6(a0),d1
  move.w     8(a0),d0
  add.w      d0,d0
  movea.l    (a0),a0
  move.w     DialWk,d2
  jsr        RastTrans
  move.l     #~_292,68(a2)
ObjcInit_5:
  addq.w     #1,d3
ObjcInit_4:
  cmp.w      #$0002,d3
  blt.s      ObjcInit_6
  movem.l    (a7)+,d3/a2-a3
  rts

ObjcTreeInit:
  movem.l    d3-d4/a2-a4,-(a7)
  movea.l    a0,a2
  clr.w      d3
ObjcTreeInit_16:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     6(a2,d0.l),d2
  and.w      #$FF00,d2
  cmp.w      #$1200,d2
  bne.s      ObjcTreeInit_1
  moveq.l    #4,d0
  move.w     d3,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  and.w      8(a2,d1.l),d0
  bne.s      ObjcTreeInit_2
  movea.l    12(a2,d1.l),a0
  jsr        strlen
  move.l     d0,d4
  addq.w     #3,d4
  moveq.l    #91,d0
  move.w     d3,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  movea.l    12(a2,d1.l),a0
  jsr        strchr
  move.l     a0,d0
  beq.s      ObjcTreeInit_3
  subq.w     #1,d4
ObjcTreeInit_3:
  move.w     HandXSize,d0
  muls.w     d4,d0
  move.w     d3,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  move.w     d0,20(a2,d1.l)
  bra.s      ObjcTreeInit_1
ObjcTreeInit_2:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  subq.w     #2,18(a2,d0.l)
  addq.w     #4,22(a2,d0.l)
ObjcTreeInit_1:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     6(a2,d0.l),d2
  and.w      #$FF00,d2
  cmp.w      #$1200,d2
  bne.s      ObjcTreeInit_4
  move.l     a2,d0
  jsr        ~_285(pc)
  movea.l    a0,a3
  move.l     a3,d0
  beq        ObjcTreeInit_5
  move.w     d3,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  move.l     12(a2,d1.l),8(a3)
  move.l     #ObjcMyButton,4(a3)
  move.w     6(a2,d1.l),12(a3)
  move.w     6(a2,d1.l),d4
  lsl.w      #8,d4
  move.w     d4,6(a2,d1.l)
  andi.w     #$FF00,6(a2,d1.l)
  ori.w      #$0018,6(a2,d1.l)
  lea.l      4(a3),a1
  move.l     a1,12(a2,d1.l)
ObjcTreeInit_4:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     6(a2,d0.l),d2
  and.w      #$FF00,d2
  cmp.w      #$1300,d2
  bne.s      ObjcTreeInit_6
  move.l     a2,d0
  jsr        ~_285(pc)
  movea.l    a0,a3
  move.l     a3,d0
  beq        ObjcTreeInit_5
  move.w     d3,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  addq.w     #1,22(a2,d1.l)
  move.l     12(a2,d1.l),8(a3)
  move.l     #~_287,4(a3)
  move.w     6(a2,d1.l),12(a3)
  andi.w     #$FF00,6(a2,d1.l)
  ori.w      #$0018,6(a2,d1.l)
  lea.l      4(a3),a1
  move.l     a1,12(a2,d1.l)
ObjcTreeInit_6:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     6(a2,d0.l),d2
  and.w      #$FF00,d2
  cmp.w      #$1400,d2
  bne.s      ObjcTreeInit_7
  move.l     a2,d0
  jsr        ~_285(pc)
  movea.l    a0,a3
  move.l     a3,d0
  beq        ObjcTreeInit_5
  move.w     d3,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  move.l     12(a2,d1.l),8(a3)
  move.l     #~_288,4(a3)
  move.w     6(a2,d1.l),12(a3)
  andi.w     #$FF00,6(a2,d1.l)
  ori.w      #$0018,6(a2,d1.l)
  lea.l      4(a3),a1
  move.l     a1,12(a2,d1.l)
ObjcTreeInit_7:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     6(a2,d0.l),d2
  and.w      #$FF00,d2
  cmp.w      #$1600,d2
  bne.s      ObjcTreeInit_8
  move.w     6(a2,d0.l),d4
  and.w      #$00FF,d4
  cmp.w      #$001B,d4
  bne.s      ObjcTreeInit_9
  andi.w     #$FF00,6(a2,d0.l)
  ori.w      #$0018,6(a2,d0.l)
  move.l     #~_309,12(a2,d0.l)
  bra.s      ObjcTreeInit_8
ObjcTreeInit_9:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  subq.w     #1,20(a2,d0.l)
ObjcTreeInit_8:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     6(a2,d0.l),d2
  and.w      #$FF00,d2
  cmp.w      #$1700,d2
  bne.s      ObjcTreeInit_10
  andi.w     #$00FF,6(a2,d0.l)
  moveq.l    #2,d2
  movea.l    a2,a0
  move.w     d3,d0
  moveq.l    #3,d1
  jsr        ObjcVStretch
ObjcTreeInit_10:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     6(a2,d0.l),d2
  and.w      #$00FF,d2
  cmp.w      #$002A,d2
  bne.s      ObjcTreeInit_11
  move.l     a2,d0
  jsr        ~_285(pc)
  movea.l    a0,a3
  move.l     a3,d0
  beq.s      ObjcTreeInit_5
  move.w     d3,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  move.l     12(a2,d1.l),8(a3)
  move.l     #ObjcAnimImage,4(a3)
  move.w     6(a2,d1.l),12(a3)
  andi.w     #$FF00,6(a2,d1.l)
  ori.w      #$0018,6(a2,d1.l)
  lea.l      4(a3),a1
  move.l     a1,12(a2,d1.l)
ObjcTreeInit_11:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  cmpi.w     #$1119,6(a2,d0.l)
  bne.s      ObjcTreeInit_12
  moveq.l    #18,d2
  and.w      10(a2,d0.l),d2
  cmp.w      #$0012,d2
  bne.s      ObjcTreeInit_12
  move.l     a2,d0
  jsr        ~_285(pc)
  movea.l    a0,a4
  move.l     a4,d0
  bne.s      ObjcTreeInit_13
ObjcTreeInit_5:
  clr.w      d0
  bra.s      ObjcTreeInit_14
ObjcTreeInit_13:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.l     12(a2,d0.l),8(a4)
  move.l     #~_291,4(a4)
  move.w     6(a2,d0.l),12(a4)
  andi.w     #$FF00,6(a2,d0.l)
  ori.w      #$0018,6(a2,d0.l)
  lea.l      4(a4),a0
  move.l     a0,12(a2,d0.l)
ObjcTreeInit_12:
  moveq.l    #32,d0
  move.w     d3,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  and.w      8(a2,d1.l),d0
  beq.s      ObjcTreeInit_15
  moveq.l    #1,d0
  bra.s      ObjcTreeInit_14
ObjcTreeInit_15:
  addq.w     #1,d3
  bra        ObjcTreeInit_16
ObjcTreeInit_14:
  movem.l    (a7)+,d3-d4/a2-a4
  rts

ObjcRemoveTree:
  move.w     d3,-(a7)
  move.l     a2,-(a7)
  movea.l    a0,a2
  clr.w      d3
ObjcRemoveTree_4:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     6(a2,d0.l),d2
  and.w      #$00FF,d2
  cmp.w      #$0018,d2
  bne.s      ObjcRemoveTree_1
  movea.l    12(a2,d0.l),a0
  movea.l    (a0),a1
  cmpa.l     #~_291,a1
  bne.s      ObjcRemoveTree_1
  move.l     4(a0),12(a2,d0.l)
  move.w     #$1119,6(a2,d0.l)
ObjcRemoveTree_1:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     6(a2,d0.l),d2
  and.w      #$00FF,d2
  cmp.w      #$0018,d2
  bne.s      ObjcRemoveTree_2
  movea.l    12(a2,d0.l),a0
  movea.l    (a0),a1
  cmpa.l     #ObjcMyButton,a1
  bne.s      ObjcRemoveTree_2
  move.l     4(a0),12(a2,d0.l)
  move.w     #$121A,6(a2,d0.l)
ObjcRemoveTree_2:
  moveq.l    #32,d0
  move.w     d3,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  and.w      8(a2,d1.l),d0
  bne.s      ObjcRemoveTree_3
  addq.w     #1,d3
  bra.w      ObjcRemoveTree_4
ObjcRemoveTree_3:
  moveq.l    #1,d0
  movea.l    (a7)+,a2
  move.w     (a7)+,d3
  rts

ObjcDeepDraw:
  move.w     ~_314,d0
  rts

ObjcGParent:
  movem.l    d3-d4/a2,-(a7)
  movea.l    a0,a2
  move.w     d0,d3
  addq.w     #1,d0
  bne.s      ObjcGParent_1
  moveq.l    #-1,d0
  bra.s      ObjcGParent_2
ObjcGParent_1:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     0(a2,d0.l),d4
  cmp.w      #$FFFF,d4
  beq.s      ObjcGParent_3
  bra.s      ObjcGParent_4
ObjcGParent_5:
  move.w     d4,d3
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     0(a2,d0.l),d4
ObjcGParent_4:
  move.w     d4,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  cmp.w      4(a2,d0.l),d3
  bne.s      ObjcGParent_5
ObjcGParent_3:
  move.w     d4,d0
ObjcGParent_2:
  movem.l    (a7)+,d3-d4/a2
  rts

ObjcOffset:
  movem.l    d3-d5/a2-a3,-(a7)
  movea.l    a0,a2
  move.w     d0,d5
  movea.l    a1,a3
  clr.w      d3
  move.w     d3,d4
ObjcOffset_1:
  move.w     d5,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  add.w      16(a2,d0.l),d3
  add.w      18(a2,d0.l),d4
  movea.l    a2,a0
  move.w     d5,d0
  jsr        ObjcGParent(pc)
  move.w     d0,d5
  addq.w     #1,d0
  bne.s      ObjcOffset_1
  move.w     d3,(a3)
  movea.l    24(a7),a0
  move.w     d4,(a0)
  moveq.l    #1,d0
  movem.l    (a7)+,d3-d5/a2-a3
  rts

ObjcDraw:
  move.w     8(a7),-(a7)
  move.w     8(a7),-(a7)
  move.w     8(a7),-(a7)
  jsr        objc_draw
  addq.w     #6,a7
  rts

ObjcXywh:
  movem.l    d3/a2-a3,-(a7)
  movea.l    a0,a3
  move.w     d0,d3
  movea.l    a1,a2
  pea.l      2(a2)
  jsr        ObjcOffset(pc)
  addq.w     #4,a7
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     20(a3,d0.l),4(a2)
  move.w     22(a3,d0.l),6(a2)
  movem.l    (a7)+,d3/a2-a3
  rts

ObjcChange:
  move.w     12(a7),-(a7)
  move.w     12(a7),-(a7)
  move.w     12(a7),-(a7)
  move.w     12(a7),-(a7)
  move.w     12(a7),-(a7)
  jsr        objc_change
  lea.l      10(a7),a7
  rts

ObjcToggle:
  move.w     d3,-(a7)
  move.l     a3,-(a7)
  subq.w     #8,a7
  movea.l    a0,a3
  move.w     d0,d3
  lea.l      (a7),a1
  clr.w      d0
  jsr        ObjcXywh(pc)
  moveq.l    #1,d0
  move.w     d0,-(a7)
  moveq.l    #1,d1
  move.w     d3,d0
  ext.l      d0
  move.l     d0,d2
  add.l      d2,d2
  add.l      d0,d2
  lsl.l      #3,d2
  move.w     10(a3,d2.l),d2
  eor.w      d2,d1
  move.w     d1,-(a7)
  move.w     10(a7),-(a7)
  move.w     10(a7),-(a7)
  move.w     10(a7),-(a7)
  move.w     10(a7),d2
  movea.l    a3,a0
  move.w     d3,d0
  clr.w      d1
  jsr        ObjcChange(pc)
  lea.l      10(a7),a7
  addq.w     #8,a7
  movea.l    (a7)+,a3
  move.w     (a7)+,d3
  rts

ObjcSel:
  move.w     d3,-(a7)
  move.l     a2,-(a7)
  movea.l    a0,a2
  move.w     d0,d3
  moveq.l    #1,d1
  ext.l      d0
  move.l     d0,d2
  add.l      d2,d2
  add.l      d0,d2
  lsl.l      #3,d2
  and.w      10(a2,d2.l),d1
  bne.s      ObjcSel_1
  move.w     d3,d0
  jsr        ObjcToggle(pc)
ObjcSel_1:
  movea.l    (a7)+,a2
  move.w     (a7)+,d3
  rts

ObjcDsel:
  move.w     d3,-(a7)
  move.l     a2,-(a7)
  movea.l    a0,a2
  move.w     d0,d3
  moveq.l    #1,d1
  ext.l      d0
  move.l     d0,d2
  add.l      d2,d2
  add.l      d0,d2
  lsl.l      #3,d2
  and.w      10(a2,d2.l),d1
  beq.s      ObjcDsel_1
  move.w     d3,d0
  jsr        ObjcToggle(pc)
ObjcDsel_1:
  movea.l    (a7)+,a2
  move.w     (a7)+,d3
  rts

ObjcVStretch:
  movem.l    d3-d6/a2,-(a7)
  movea.l    a0,a2
  move.w     d0,d3
  move.w     d1,d5
  move.w     d2,d6
  move.w     d0,d4
  ext.l      d0
  move.l     d0,d1
  add.l      d1,d1
  add.l      d0,d1
  lsl.l      #3,d1
  move.w     2(a2,d1.l),d3
ObjcVStretch_1:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     18(a2,d0.l),d2
  muls.w     d5,d2
  move.w     d2,18(a2,d0.l)
  ext.l      d2
  divs.w     d6,d2
  move.w     d2,18(a2,d0.l)
  move.w     0(a2,d0.l),d3
  cmp.w      d3,d4
  bne.s      ObjcVStretch_1
  movem.l    (a7)+,d3-d6/a2
  rts

ObjcGetObspec:
  move.w     d3,-(a7)
  move.l     a2,-(a7)
  movea.l    a0,a2
  move.w     d0,d3
  ext.l      d0
  move.l     d0,d1
  add.l      d1,d1
  add.l      d0,d1
  lsl.l      #3,d1
  move.w     6(a2,d1.l),d2
  and.w      #$00FF,d2
  cmp.w      #$0018,d2
  beq.s      ObjcGetObspec_1
  lea.l      12(a2,d1.l),a0
  bra.s      ObjcGetObspec_2
ObjcGetObspec_1:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  movea.l    12(a2,d0.l),a0
  addq.w     #4,a0
ObjcGetObspec_2:
  movea.l    (a7)+,a2
  move.w     (a7)+,d3
  rts

RastSize:
  movem.l    d3-d5/a2,-(a7)
  lea.l      -114(a7),a7
  move.w     d0,d3
  move.w     d1,d5
  movea.l    a0,a2
  lea.l      (a7),a0
  move.w     DialWk,d0
  moveq.l    #1,d1
  jsr        vq_extnd
  moveq.l    #15,d4
  add.w      d3,d4
  asr.w      #4,d4
  clr.l      ~_323
  move.w     d3,4(a2)
  move.w     d5,6(a2)
  move.w     d4,8(a2)
  move.w     8(a7),12(a2)
  clr.w      10(a2)
  move.w     d5,d0
  ext.l      d0
  move.w     d4,d1
  ext.l      d1
  add.l      d1,d1
  jsr        _lmul
  move.w     8(a7),d1
  ext.l      d1
  jsr        _lmul
  lea.l      114(a7),a7
  movem.l    (a7)+,d3-d5/a2
  rts

RastSave:
  movem.l    d3-d4/a3,-(a7)
  lea.l      -16(a7),a7
  move.w     d2,d4
  move.w     32(a7),d3
  movea.l    a0,a3
  move.w     d3,-(a7)
  lea.l      2(a7),a0
  jsr        RectAES2VDI
  addq.w     #2,a7
  move.w     d3,-(a7)
  lea.l      10(a7),a0
  move.w     d4,d2
  move.w     38(a7),d1
  move.w     36(a7),d0
  jsr        RectAES2VDI
  addq.w     #2,a7
  move.l     a3,-(a7)
  lea.l      ~_323,a1
  lea.l      4(a7),a0
  moveq.l    #3,d1
  move.w     DialWk,d0
  jsr        vro_cpyfm
  addq.w     #4,a7
  lea.l      16(a7),a7
  movem.l    (a7)+,d3-d4/a3
  rts

RastRestore:
  movem.l    d3-d6/a3,-(a7)
  lea.l      -16(a7),a7
  move.w     d0,d6
  move.w     d1,d5
  move.w     d2,d4
  move.w     40(a7),d3
  movea.l    a0,a3
  move.w     d3,-(a7)
  lea.l      2(a7),a0
  move.w     44(a7),d0
  move.w     46(a7),d1
  jsr        RectAES2VDI
  addq.w     #2,a7
  move.w     d3,-(a7)
  lea.l      10(a7),a0
  move.w     d4,d2
  move.w     d5,d1
  move.w     d6,d0
  jsr        RectAES2VDI
  addq.w     #2,a7
  pea.l      ~_323
  movea.l    a3,a1
  lea.l      4(a7),a0
  moveq.l    #3,d1
  move.w     DialWk,d0
  jsr        vro_cpyfm
  addq.w     #4,a7
  lea.l      16(a7),a7
  movem.l    (a7)+,d3-d6/a3
  rts

RastBufCopy:
  movem.l    d3-d4/a3,-(a7)
  lea.l      -16(a7),a7
  move.w     d2,d4
  move.w     32(a7),d3
  movea.l    a0,a3
  move.w     d3,-(a7)
  lea.l      2(a7),a0
  jsr        RectAES2VDI
  addq.w     #2,a7
  move.w     d3,-(a7)
  lea.l      10(a7),a0
  move.w     d4,d2
  move.w     38(a7),d1
  move.w     36(a7),d0
  jsr        RectAES2VDI
  addq.w     #2,a7
  move.l     a3,-(a7)
  movea.l    a3,a1
  lea.l      4(a7),a0
  moveq.l    #3,d1
  move.w     DialWk,d0
  jsr        vro_cpyfm
  addq.w     #4,a7
  lea.l      16(a7),a7
  movem.l    (a7)+,d3-d4/a3
  rts

RastDrawRect:
  move.w     d3,-(a7)
  move.w     d4,-(a7)
  lea.l      -20(a7),a7
  move.w     d0,d4
  lea.l      (a7),a0
  move.w     d1,d0
  add.w      28(a7),d0
  subq.w     #1,d0
  move.w     d2,d3
  add.w      30(a7),d3
  subq.w     #1,d3
  move.w     d1,(a0)+
  move.w     d2,(a0)+
  move.w     d1,(a0)+
  move.w     d3,(a0)+
  move.w     d0,(a0)+
  move.w     d3,(a0)+
  move.w     d0,(a0)+
  move.w     d2,(a0)+
  moveq.l    #1,d0
  add.w      d1,d0
  move.w     d0,(a0)+
  move.w     d2,(a0)
  lea.l      (a7),a0
  moveq.l    #5,d1
  move.w     d4,d0
  jsr        v_pline
  lea.l      20(a7),a7
  move.w     (a7)+,d4
  move.w     (a7)+,d3
  rts

RastSetDotStyle:
  move.w     d3,-(a7)
  move.w     d4,-(a7)
  move.w     d0,d4
  move.w     #$AAAA,d3
  move.w     (a0),d1
  add.w      2(a0),d1
  and.w      #$0001,d1
  beq.s      RastSetDotStyle_1
  move.w     #$5555,d3
RastSetDotStyle_1:
  move.w     (a0),d0
  cmp.w      4(a0),d0
  beq.s      RastSetDotStyle_2
  moveq.l    #1,d1
  and.w      d0,d1
  bne.s      RastSetDotStyle_3
RastSetDotStyle_2:
  eori.w     #$FFFF,d3
RastSetDotStyle_3:
  move.w     d3,d1
  move.w     d4,d0
  jsr        vsl_udsty
  move.w     (a7)+,d4
  move.w     (a7)+,d3
  rts

RastDotRect:
  movem.l    d3-d6,-(a7)
  subq.w     #8,a7
  move.w     d0,d3
  move.w     d1,d4
  move.w     d2,d5
  move.w     30(a7),d6
  moveq.l    #7,d1
  jsr        vsl_type
  move.w     d4,(a7)
  move.w     d5,2(a7)
  move.w     d4,d0
  add.w      28(a7),d0
  subq.w     #1,d0
  move.w     d0,4(a7)
  move.w     d5,6(a7)
  lea.l      (a7),a0
  move.w     d3,d0
  jsr        RastSetDotStyle(pc)
  lea.l      (a7),a0
  moveq.l    #2,d1
  move.w     d3,d0
  jsr        v_pline
  moveq.l    #-1,d0
  add.w      d6,d0
  add.w      d0,2(a7)
  move.w     2(a7),6(a7)
  lea.l      (a7),a0
  move.w     d3,d0
  jsr        RastSetDotStyle(pc)
  lea.l      (a7),a0
  moveq.l    #2,d1
  move.w     d3,d0
  jsr        v_pline
  move.w     4(a7),(a7)
  moveq.l    #1,d0
  add.w      d5,d0
  move.w     d0,2(a7)
  move.w     d5,d1
  add.w      d6,d1
  subq.w     #2,d1
  move.w     d1,6(a7)
  lea.l      (a7),a0
  move.w     d3,d0
  jsr        RastSetDotStyle(pc)
  lea.l      (a7),a0
  moveq.l    #2,d1
  move.w     d3,d0
  jsr        v_pline
  move.w     d4,4(a7)
  move.w     d4,(a7)
  lea.l      (a7),a0
  move.w     d3,d0
  jsr        RastSetDotStyle(pc)
  lea.l      (a7),a0
  moveq.l    #2,d1
  move.w     d3,d0
  jsr        v_pline
  moveq.l    #1,d1
  move.w     d3,d0
  jsr        vsl_type
  addq.w     #8,a7
  movem.l    (a7)+,d3-d6
  rts

~_321:
  move.w     d0,d2
  asr.w      #1,d2
  move.w     d2,8(a0)
  move.w     d0,d2
  lsl.w      #3,d2
  move.w     d2,4(a0)
  move.w     d1,6(a0)
  move.w     #$0001,12(a0)
  move.l     a1,(a0)
  rts

RastTrans:
  movem.l    d3-d5/a2,-(a7)
  lea.l      -40(a7),a7
  movea.l    a0,a2
  move.w     d0,d4
  move.w     d1,d3
  move.w     d2,d5
  movea.l    a0,a1
  lea.l      20(a7),a0
  jsr        ~_321(pc)
  move.w     #$0001,30(a7)
  move.w     d3,d1
  move.w     d4,d0
  movea.l    a2,a1
  lea.l      (a7),a0
  jsr        ~_321(pc)
  clr.w      10(a7)
  lea.l      (a7),a1
  lea.l      20(a7),a0
  move.w     d5,d0
  jsr        vr_trnfm
  lea.l      40(a7),a7
  movem.l    (a7)+,d3-d5/a2
  rts

RectAES2VDI:
  move.w     d3,-(a7)
  move.w     d0,(a0)+
  move.w     d1,(a0)+
  move.w     d0,d3
  add.w      d2,d3
  subq.w     #1,d3
  move.w     d3,(a0)+
  move.w     d1,d0
  add.w      6(a7),d0
  subq.w     #1,d0
  move.w     d0,(a0)
  move.w     (a7)+,d3
  rts

RectGRECT2VDI:
  move.w     (a0),(a1)+
  move.w     2(a0),(a1)+
  move.w     (a0),d0
  add.w      4(a0),d0
  subq.w     #1,d0
  move.w     d0,(a1)+
  move.w     2(a0),d0
  add.w      6(a0),d0
  subq.w     #1,d0
  move.w     d0,(a1)
  rts

RectInter:
  movem.l    d3-d5/a2-a3,-(a7)
  move.w     26(a7),d3
  move.w     28(a7),d4
  movea.l    34(a7),a2
  movea.l    38(a7),a3
  cmp.w      d0,d3
  bge.s      RectInter_1
  move.w     d0,d5
  bra.s      RectInter_2
RectInter_1:
  move.w     d3,d5
RectInter_2:
  move.w     d5,(a0)
  cmp.w      d1,d4
  bge.s      RectInter_3
  move.w     d1,d5
  bra.s      RectInter_4
RectInter_3:
  move.w     d4,d5
RectInter_4:
  move.w     d5,(a1)
  move.w     d0,d5
  add.w      d2,d5
  move.w     d5,d2
  move.w     d3,d0
  add.w      30(a7),d0
  cmp.w      d5,d0
  ble.s      RectInter_5
  bra.s      RectInter_6
RectInter_5:
  move.w     d0,d5
RectInter_6:
  sub.w      (a0),d5
  move.w     d5,(a2)
  move.w     d1,d2
  add.w      24(a7),d2
  move.w     d4,d0
  add.w      32(a7),d0
  cmp.w      d2,d0
  ble.s      RectInter_7
  move.w     d2,d1
  bra.s      RectInter_8
RectInter_7:
  move.w     d0,d1
RectInter_8:
  sub.w      (a1),d1
  move.w     d1,(a3)
  move.w     (a2),d0
  ble.s      RectInter_9
  tst.w      d1
  ble.s      RectInter_9
  moveq.l    #1,d0
  bra.s      RectInter_10
RectInter_9:
  clr.w      d0
RectInter_10:
  movem.l    (a7)+,d3-d5/a2-a3
  rts

RectGInter:
  move.l     a2,-(a7)
  movea.l    8(a7),a2
  move.w     (a0),d0
  cmp.w      (a1),d0
  ble.s      RectGInter_1
  bra.s      RectGInter_2
RectGInter_1:
  move.w     (a1),d0
RectGInter_2:
  move.w     d0,(a2)
  move.w     2(a0),d1
  cmp.w      2(a1),d1
  ble.s      RectGInter_3
  bra.s      RectGInter_4
RectGInter_3:
  move.w     2(a1),d1
RectGInter_4:
  move.w     d1,2(a2)
  move.w     (a0),d0
  add.w      4(a0),d0
  move.w     (a1),d1
  add.w      4(a1),d1
  cmp.w      d0,d1
  ble.s      RectGInter_5
  move.w     d0,d2
  bra.s      RectGInter_6
RectGInter_5:
  move.w     d1,d2
RectGInter_6:
  sub.w      (a2),d2
  move.w     d2,4(a2)
  move.w     2(a0),d0
  add.w      6(a0),d0
  move.w     2(a1),d1
  add.w      6(a1),d1
  cmp.w      d0,d1
  ble.s      RectGInter_7
  move.w     d0,d2
  bra.s      RectGInter_8
RectGInter_7:
  move.w     d1,d2
RectGInter_8:
  sub.w      2(a2),d2
  move.w     d2,6(a2)
  move.w     4(a2),d0
  ble.s      RectGInter_9
  tst.w      d2
  ble.s      RectGInter_9
  moveq.l    #1,d0
  bra.s      RectGInter_10
RectGInter_9:
  clr.w      d0
RectGInter_10:
  movea.l    (a7)+,a2
  rts

RectOnScreen:
  movem.l    d3-d5,-(a7)
  subq.w     #8,a7
  move.w     d0,d5
  move.w     d1,d3
  move.w     d2,d4
  pea.l      (a7)
  pea.l      6(a7)
  lea.l      12(a7),a1
  lea.l      14(a7),a0
  jsr        HandScreenSize
  addq.w     #8,a7
  cmp.w      6(a7),d5
  blt.s      RectOnScreen_1
  cmp.w      4(a7),d3
  blt.s      RectOnScreen_1
  move.w     d5,d0
  add.w      d4,d0
  move.w     6(a7),d1
  add.w      2(a7),d1
  cmp.w      d1,d0
  bgt.s      RectOnScreen_1
  move.w     d3,d2
  add.w      24(a7),d2
  move.w     4(a7),d0
  add.w      (a7),d0
  cmp.w      d0,d2
  bgt.s      RectOnScreen_1
  moveq.l    #1,d0
  bra.s      RectOnScreen_2
RectOnScreen_1:
  clr.w      d0
RectOnScreen_2:
  addq.w     #8,a7
  movem.l    (a7)+,d3-d5
  rts

RectInside:
  movem.l    d3-d5,-(a7)
  move.w     18(a7),d4
  move.w     20(a7),d3
  cmp.w      d4,d0
  bgt.s      RectInside_1
  cmp.w      d3,d1
  bgt.s      RectInside_1
  move.w     d0,d5
  add.w      d2,d5
  cmp.w      d5,d4
  bge.s      RectInside_1
  move.w     d1,d5
  add.w      16(a7),d5
  cmp.w      d5,d3
  bge.s      RectInside_1
  moveq.l    #1,d5
  bra.s      RectInside_2
RectInside_1:
  clr.w      d5
RectInside_2:
  move.w     d5,d0
  movem.l    (a7)+,d3-d5
  rts

RectClipWithScreen:
  move.l     a2,-(a7)
  move.l     a3,-(a7)
  subq.w     #8,a7
  movea.l    a0,a3
  lea.l      ~_325,a2
  move.w     4(a2),d0
  bne.s      RectClipWithScreen_1
  pea.l      6(a2)
  pea.l      4(a2)
  lea.l      2(a2),a1
  movea.l    a2,a0
  jsr        HandScreenSize
  addq.w     #8,a7
RectClipWithScreen_1:
  movea.l    a3,a0
  lea.l      (a7),a1
  move.l     (a0)+,(a1)+
  move.l     (a0)+,(a1)+
  move.l     a3,-(a7)
  movea.l    a2,a1
  lea.l      4(a7),a0
  jsr        RectGInter(pc)
  addq.w     #4,a7
  addq.w     #8,a7
  movea.l    (a7)+,a3
  movea.l    (a7)+,a2
  rts

HandFast:
  move.w     d3,-(a7)
  lea.l      -112(a7),a7
  moveq.l    #-1,d0
  jsr        Blitmode
  move.w     d0,d3
  lea.l      (a7),a0
  moveq.l    #1,d1
  move.w     HandAES,d0
  jsr        vq_extnd
  clr.w      d0
  cmpi.w     #$07D0,12(a7)
  ble.s      HandFast_1
  moveq.l    #1,d0
HandFast_1:
  moveq.l    #3,d1
  and.w      d3,d1
  subq.w     #2,d1
  bne.s      HandFast_2
  clr.w      d0
HandFast_2:
  moveq.l    #1,d1
  and.w      d3,d1
  beq.s      HandFast_3
  moveq.l    #1,d0
HandFast_3:
  tst.w      d0
  lea.l      112(a7),a7
  move.w     (a7)+,d3
  rts

HandScreenSize:
  movem.l    a2-a5,-(a7)
  movea.l    a0,a4
  movea.l    a1,a5
  lea.l      ~_328,a2
  lea.l      ~_337,a3
  cmpi.w     #$FFFF,(a2)
  bne.s      HandScreenSize_1
  pea.l      (a3)
  pea.l      -2(a3)
  pea.l      -4(a3)
  pea.l      (a2)
  moveq.l    #4,d1
  clr.w      d0
  jsr        wind_get
  lea.l      16(a7),a7
HandScreenSize_1:
  move.w     (a2),(a4)
  move.w     -4(a3),(a5)
  movea.l    20(a7),a0
  move.w     -2(a3),(a0)
  movea.l    24(a7),a1
  move.w     (a3),(a1)
  movem.l    (a7)+,a2-a5
  rts

HandInit:
  move.l     a2,-(a7)
  lea.l      HandBYSize,a2
  pea.l      (a2)
  pea.l      -2(a2)
  lea.l      -4(a2),a1
  lea.l      -6(a2),a0
  jsr        graf_handle
  addq.w     #8,a7
  move.w     d0,-8(a2)
  movea.l    (a7)+,a2
  rts

HandClip:
  movem.l    d3-d7,-(a7)
  subq.w     #8,a7
  move.w     d0,d5
  move.w     d1,d6
  move.w     d2,d3
  move.w     32(a7),d7
  move.w     34(a7),d4
  tst.w      d2
  bne.s      HandClip_1
  clr.w      d4
HandClip_1:
  lea.l      ~_333,a0
  cmp.w      (a0),d4
  bne.s      HandClip_2
  cmp.w      -8(a0),d5
  bne.s      HandClip_2
  cmp.w      -6(a0),d6
  bne.s      HandClip_2
  cmp.w      -4(a0),d3
  bne.s      HandClip_2
  cmp.w      -2(a0),d7
  beq.s      HandClip_3
HandClip_2:
  move.w     d5,-8(a0)
  move.w     d6,-6(a0)
  move.w     d3,-4(a0)
  move.w     d7,-2(a0)
  move.w     d4,(a0)
  move.w     d7,-(a7)
  lea.l      2(a7),a0
  move.w     d3,d2
  move.w     d6,d1
  move.w     d5,d0
  jsr        RectAES2VDI
  addq.w     #2,a7
  lea.l      (a7),a0
  move.w     d4,d1
  move.w     DialWk,d0
  jsr        vs_clip
HandClip_3:
  addq.w     #8,a7
  movem.l    (a7)+,d3-d7
  rts

~_338:
  movem.l    d3-d6,-(a7)
  lea.l      -44(a7),a7
  move.w     d0,d3
  move.w     d1,d4
  lea.l      22(a7),a0
  jsr        vqt_attributes
  move.w     d4,d1
  move.w     d3,d0
  jsr        vst_font
  pea.l      (a7)
  pea.l      4(a7)
  lea.l      8(a7),a1
  lea.l      8(a7),a0
  moveq.l    #20,d1
  move.w     d3,d0
  jsr        vst_point
  addq.w     #8,a7
  pea.l      2(a7)
  pea.l      4(a7)
  pea.l      16(a7)
  lea.l      30(a7),a1
  lea.l      32(a7),a0
  move.w     d3,d0
  jsr        vqt_fontinfo
  lea.l      12(a7),a7
  clr.w      d4
  moveq.l    #-1,d5
  move.w     20(a7),d0
  bne.s      ~_338_1
  move.w     #$0001,20(a7)
~_338_1:
  move.w     20(a7),d6
  bra.s      ~_338_2
~_338_7:
  pea.l      (a7)
  lea.l      4(a7),a1
  lea.l      46(a7),a0
  move.w     d6,d1
  move.w     d3,d0
  jsr        vqt_width
  addq.w     #4,a7
  move.w     42(a7),d0
  beq.s      ~_338_3
  cmp.w      #$FFFF,d5
  bne.s      ~_338_4
  move.w     d0,d5
  bra.s      ~_338_3
~_338_4:
  cmp.w      42(a7),d5
  beq.s      ~_338_5
  moveq.l    #1,d4
  bra.s      ~_338_3
~_338_5:
  clr.w      d4
~_338_3:
  addq.w     #1,d6
~_338_2:
  cmp.w      18(a7),d6
  bgt.s      ~_338_6
  tst.w      d4
  beq.s      ~_338_7
~_338_6:
  move.w     22(a7),d1
  move.w     d3,d0
  jsr        vst_font
  pea.l      (a7)
  pea.l      4(a7)
  lea.l      8(a7),a1
  lea.l      8(a7),a0
  move.w     44(a7),d1
  move.w     d3,d0
  jsr        vst_point
  addq.w     #8,a7
  move.w     d4,d0
  lea.l      44(a7),a7
  movem.l    (a7)+,d3-d6
  rts

~_339:
  move.w     d3,-(a7)
  move.l     d4,-(a7)
  lea.l      -20(a7),a7
  move.w     d0,d3
  move.w     d1,d4
  lea.l      (a7),a0
  jsr        vqt_attributes
  move.w     d4,d1
  move.w     d3,d0
  jsr        vst_font
  moveq.l    #1,d1
  move.w     d3,d0
  jsr        vst_rotation
  subq.w     #1,d0
  bne.s      ~_339_1
  moveq.l    #1,d4
  bra.s      ~_339_2
~_339_1:
  clr.w      d4
~_339_2:
  clr.w      d1
  move.w     d3,d0
  jsr        vst_rotation
  move.w     (a7),d1
  move.w     d3,d0
  jsr        vst_font
  move.w     d4,d0
  lea.l      20(a7),a7
  move.l     (a7)+,d4
  move.w     (a7)+,d3
  rts

FontLoad:
  move.l     a2,-(a7)
  movea.l    a0,a2
  move.w     2(a2),d0
  bne.s      FontLoad_1
  cmpi.w     #$0210,_GemParBlk+$0000001E
  beq.s      FontLoad_2
  jsr        vq_gdos
  tst.w      d0
  beq.s      FontLoad_3
FontLoad_2:
  clr.w      d1
  move.w     (a2),d0
  jsr        vst_load_fonts
  move.w     d0,6(a2)
FontLoad_3:
  move.w     #$0001,2(a2)
  clr.l      8(a2)
FontLoad_1:
  movea.l    (a7)+,a2
  rts

FontUnLoad:
  move.l     a2,-(a7)
  movea.l    a0,a2
  move.w     2(a2),d0
  beq.s      FontUnLoad_1
  cmpi.w     #$0210,_GemParBlk+$0000001E
  beq.s      FontUnLoad_2
  jsr        vq_gdos
  tst.w      d0
  beq.s      FontUnLoad_3
FontUnLoad_2:
  clr.w      d1
  move.w     (a2),d0
  jsr        vst_unload_fonts
FontUnLoad_3:
  clr.w      2(a2)
  move.l     8(a2),d0
  beq.s      FontUnLoad_1
  movea.l    d0,a0
  movea.l    dialfree,a1
  jsr        (a1)
  clr.l      8(a2)
FontUnLoad_1:
  movea.l    (a7)+,a2
  rts

FontGetList:
  movem.l    d3-d6/a2-a5,-(a7)
  movea.l    a0,a2
  move.w     d0,d5
  move.w     d1,d6
  move.w     2(a2),d2
  beq.s      FontGetList_1
  move.l     8(a2),d1
  bne        FontGetList_2
  move.w     4(a2),d3
  add.w      6(a2),d3
  tst.w      d3
  beq.s      FontGetList_1
  moveq.l    #1,d2
  add.w      d3,d2
  ext.l      d2
  move.l     d2,d0
  lsl.l      #3,d0
  add.l      d2,d0
  add.l      d0,d0
  add.l      d2,d0
  add.l      d0,d0
  movea.l    dialmalloc,a0
  jsr        (a0)
  movea.l    a0,a3
  move.l     a3,d0
  bne.s      FontGetList_3
FontGetList_1:
  clr.w      d0
  bra        FontGetList_4
FontGetList_3:
  moveq.l    #1,d0
  add.w      d3,d0
  ext.l      d0
  move.l     d0,d1
  lsl.l      #3,d1
  add.l      d0,d1
  add.l      d1,d1
  add.l      d0,d1
  add.l      d1,d1
  movea.l    a3,a0
  clr.w      d0
  jsr        memset
  clr.w      d4
  lea.l      ~_340,a4
  bra        FontGetList_5
FontGetList_13:
  move.w     d4,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #3,d0
  add.l      d1,d0
  add.l      d0,d0
  add.l      d1,d0
  add.l      d0,d0
  lea.l      4(a3,d0.l),a0
  moveq.l    #1,d1
  add.w      d4,d1
  move.w     (a2),d0
  jsr        vqt_name
  move.w     d4,d2
  ext.l      d2
  move.l     d2,d1
  lsl.l      #3,d1
  add.l      d2,d1
  add.l      d1,d1
  add.l      d2,d1
  add.l      d1,d1
  move.w     d0,0(a3,d1.l)
  clr.b      36(a3,d1.l)
  bra.s      FontGetList_6
FontGetList_7:
  movea.l    a4,a1
  move.w     d4,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #3,d0
  add.l      d1,d0
  add.l      d0,d0
  add.l      d1,d0
  add.l      d0,d0
  lea.l      4(a3,d0.l),a0
  jsr        strstr
  movea.l    a0,a5
  lea.l      1(a5),a1
  jsr        strcpy
FontGetList_6:
  movea.l    a4,a1
  move.w     d4,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #3,d0
  add.l      d1,d0
  add.l      d0,d0
  add.l      d1,d0
  add.l      d0,d0
  lea.l      4(a3,d0.l),a0
  jsr        strstr
  move.l     a0,d0
  bne.s      FontGetList_7
  lea.l      3(a4),a1
  move.w     d4,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #3,d0
  add.l      d1,d0
  add.l      d0,d0
  add.l      d1,d0
  add.l      d0,d0
  lea.l      4(a3,d0.l),a0
  jsr        strcmp
  tst.w      d0
  bne.s      FontGetList_8
  lea.l      19(a4),a1
  move.w     d4,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #3,d0
  add.l      d1,d0
  add.l      d0,d0
  add.l      d1,d0
  add.l      d0,d0
  lea.l      4(a3,d0.l),a0
  jsr        strcpy
FontGetList_8:
  tst.w      d5
  beq.s      FontGetList_9
  move.w     d4,d2
  ext.l      d2
  move.l     d2,d0
  lsl.l      #3,d0
  add.l      d2,d0
  add.l      d0,d0
  add.l      d2,d0
  add.l      d0,d0
  move.w     0(a3,d0.l),d1
  move.w     (a2),d0
  jsr        ~_338(pc)
  bra.s      FontGetList_10
FontGetList_9:
  moveq.l    #1,d0
FontGetList_10:
  move.w     d4,d2
  ext.l      d2
  move.l     d2,d1
  lsl.l      #3,d1
  add.l      d2,d1
  add.l      d1,d1
  add.l      d2,d1
  add.l      d1,d1
  andi.w     #$7FFF,2(a3,d1.l)
  and.w      #$0001,d0
  lsl.w      #8,d0
  lsl.w      #7,d0
  or.w       d0,2(a3,d1.l)
  tst.w      d6
  beq.s      FontGetList_11
  move.w     0(a3,d1.l),d1
  move.w     (a2),d0
  jsr        ~_339(pc)
  bra.s      FontGetList_12
FontGetList_11:
  clr.w      d0
FontGetList_12:
  move.w     d4,d2
  ext.l      d2
  move.l     d2,d1
  lsl.l      #3,d1
  add.l      d2,d1
  add.l      d1,d1
  add.l      d2,d1
  add.l      d1,d1
  andi.w     #$BFFF,2(a3,d1.l)
  and.w      #$0001,d0
  lsl.w      #8,d0
  lsl.w      #6,d0
  or.w       d0,2(a3,d1.l)
  addq.w     #1,d4
FontGetList_5:
  cmp.w      d4,d3
  bgt        FontGetList_13
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #3,d0
  add.l      d1,d0
  add.l      d0,d0
  add.l      d1,d0
  add.l      d0,d0
  move.w     #$FFFF,0(a3,d0.l)
  move.l     a3,8(a2)
FontGetList_2:
  moveq.l    #1,d0
FontGetList_4:
  movem.l    (a7)+,d3-d6/a2-a5
  rts

FontSetPoint:
  movem.l    d3-d6/a2-a5,-(a7)
  subq.w     #4,a7
  move.w     d0,d6
  move.w     d1,d4
  move.w     d2,d5
  move.l     a1,(a7)
  movea.l    40(a7),a5
  movea.l    44(a7),a4
  movea.l    48(a7),a3
  clr.w      d3
  movea.l    8(a0),a2
  bra.s      FontSetPoint_1
FontSetPoint_5:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #3,d0
  add.l      d1,d0
  add.l      d0,d0
  add.l      d1,d0
  add.l      d0,d0
  cmp.w      0(a2,d0.l),d4
  bne.s      FontSetPoint_2
  move.w     2(a2,d0.l),d2
  moveq.l    #14,d1
  lsr.w      d1,d2
  and.w      #$0001,d2
  beq.s      FontSetPoint_3
  move.l     a3,-(a7)
  move.l     a4,-(a7)
  movea.l    a5,a1
  movea.l    8(a7),a0
  move.w     d6,d0
  move.w     d5,d1
  jsr        vst_arbpt
  addq.w     #8,a7
  bra.s      FontSetPoint_4
FontSetPoint_3:
  move.l     a3,-(a7)
  move.l     a4,-(a7)
  movea.l    a5,a1
  movea.l    8(a7),a0
  move.w     d5,d1
  move.w     d6,d0
  jsr        vst_point
  addq.w     #8,a7
  bra.s      FontSetPoint_4
FontSetPoint_2:
  addq.w     #1,d3
FontSetPoint_1:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #3,d0
  add.l      d1,d0
  add.l      d0,d0
  add.l      d1,d0
  add.l      d0,d0
  cmpi.w     #$FFFF,0(a2,d0.l)
  bne.s      FontSetPoint_5
  clr.w      d0
FontSetPoint_4:
  addq.w     #4,a7
  movem.l    (a7)+,d3-d6/a2-a5
  rts

FontIsFSM:
  movem.l    d3-d4/a2,-(a7)
  move.w     d0,d4
  clr.w      d3
  movea.l    8(a0),a2
  bra.s      FontIsFSM_1
FontIsFSM_4:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #3,d0
  add.l      d1,d0
  add.l      d0,d0
  add.l      d1,d0
  add.l      d0,d0
  cmp.w      0(a2,d0.l),d4
  bne.s      FontIsFSM_2
  move.w     2(a2,d0.l),d0
  moveq.l    #14,d2
  lsr.w      d2,d0
  and.w      #$0001,d0
  bra.s      FontIsFSM_3
FontIsFSM_2:
  addq.w     #1,d3
FontIsFSM_1:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #3,d0
  add.l      d1,d0
  add.l      d0,d0
  add.l      d1,d0
  add.l      d0,d0
  cmpi.w     #$FFFF,0(a2,d0.l)
  bne.s      FontIsFSM_4
  clr.w      d0
FontIsFSM_3:
  movem.l    (a7)+,d3-d4/a2
  rts

GrafGetForm:
  move.l     a2,-(a7)
  move.w     ~_342,(a0)
  lea.l      ~_345,a0
  movea.l    a1,a2
  moveq.l    #17,d0
GrafGetForm_1:
  move.l     (a0)+,(a2)+
  dbf        d0,GrafGetForm_1
  move.w     (a0)+,(a2)+
  movea.l    (a7)+,a2
  rts

GrafMouse:
  movem.l    d3/a2-a3,-(a7)
  move.w     d0,d3
  movea.l    a0,a3
  lea.l      ~_343,a2
  sub.w      #$00FF,d0
  beq.s      GrafMouse_1
  subq.w     #1,d0
  beq.s      GrafMouse_2
  subq.w     #1,d0
  beq.s      GrafMouse_3
  bra.s      GrafMouse_4
GrafMouse_3:
  cmpi.w     #$0001,(a2)
  bne.s      GrafMouse_5
  suba.l     a0,a0
  move.w     #$0101,d0
  jsr        graf_mouse
GrafMouse_5:
  move.w     (a2),d0
  beq.s      GrafMouse_6
  subq.w     #1,(a2)
  bra.s      GrafMouse_6
GrafMouse_2:
  move.w     (a2),d0
  bne.s      GrafMouse_7
  suba.l     a0,a0
  move.w     #$0100,d0
  jsr        graf_mouse
GrafMouse_7:
  addq.w     #1,(a2)
  bra.s      GrafMouse_6
GrafMouse_1:
  movea.l    a3,a0
  lea.l      ~_345,a1
  moveq.l    #17,d0
GrafMouse_8:
  move.l     (a0)+,(a1)+
  dbf        d0,GrafMouse_8
  move.w     (a0)+,(a1)+
GrafMouse_4:
  move.w     d3,-2(a2)
  movea.l    a3,a0
  move.w     d3,d0
  jsr        graf_mouse
GrafMouse_6:
  movem.l    (a7)+,d3/a2-a3
  rts

ImQuestionMark:
  move.l     a2,-(a7)
  lea.l      ~_349,a2
  move.w     (a2),d0
  bne.s      ImQuestionMark_1
  move.w     #$0001,(a2)
  move.w     HandAES,d2
  moveq.l    #32,d1
  moveq.l    #4,d0
  lea.l      -142(a2),a0
  jsr        RastTrans
ImQuestionMark_1:
  lea.l      -14(a2),a0
  movea.l    (a7)+,a2
  rts

ImHand:
  move.l     a2,-(a7)
  lea.l      ~_353,a2
  move.w     (a2),d0
  bne.s      ImHand_1
  move.w     #$0001,(a2)
  move.w     HandAES,d2
  moveq.l    #32,d1
  moveq.l    #4,d0
  lea.l      -142(a2),a0
  jsr        RastTrans
ImHand_1:
  lea.l      -14(a2),a0
  movea.l    (a7)+,a2
  rts

ImInfo:
  move.l     a2,-(a7)
  lea.l      ~_357,a2
  move.w     (a2),d0
  bne.s      ImInfo_1
  move.w     #$0001,(a2)
  move.w     HandAES,d2
  moveq.l    #32,d1
  moveq.l    #4,d0
  lea.l      -142(a2),a0
  jsr        RastTrans
ImInfo_1:
  lea.l      -14(a2),a0
  movea.l    (a7)+,a2
  rts

ImFinger:
  move.l     a2,-(a7)
  lea.l      ~_361,a2
  move.w     (a2),d0
  bne.s      ImFinger_1
  move.w     #$0001,(a2)
  move.w     HandAES,d2
  moveq.l    #32,d1
  moveq.l    #4,d0
  lea.l      -142(a2),a0
  jsr        RastTrans
ImFinger_1:
  lea.l      -14(a2),a0
  movea.l    (a7)+,a2
  rts

ImBomb:
  move.l     a2,-(a7)
  lea.l      ~_365,a2
  move.w     (a2),d0
  bne.s      ImBomb_1
  move.w     #$0001,(a2)
  move.w     HandAES,d2
  moveq.l    #32,d1
  moveq.l    #4,d0
  lea.l      -142(a2),a0
  jsr        RastTrans
ImBomb_1:
  lea.l      -14(a2),a0
  movea.l    (a7)+,a2
  rts

ImPrinter:
  move.l     a2,-(a7)
  lea.l      ~_369,a2
  move.w     (a2),d0
  bne.s      ImPrinter_1
  move.w     #$0001,(a2)
  move.w     HandAES,d2
  moveq.l    #32,d1
  moveq.l    #4,d0
  lea.l      -142(a2),a0
  jsr        RastTrans
ImPrinter_1:
  lea.l      -14(a2),a0
  movea.l    (a7)+,a2
  rts

ImDrive:
  move.l     a2,-(a7)
  lea.l      ~_373,a2
  move.w     (a2),d0
  bne.s      ImDrive_1
  move.w     #$0001,(a2)
  move.w     HandAES,d2
  moveq.l    #32,d1
  moveq.l    #4,d0
  lea.l      -142(a2),a0
  jsr        RastTrans
ImDrive_1:
  lea.l      -14(a2),a0
  movea.l    (a7)+,a2
  rts

ImDisk:
  move.l     a2,-(a7)
  lea.l      ~_377,a2
  move.w     (a2),d0
  bne.s      ImDisk_1
  move.w     #$0001,(a2)
  move.w     HandAES,d2
  moveq.l    #32,d1
  moveq.l    #4,d0
  lea.l      -142(a2),a0
  jsr        RastTrans
ImDisk_1:
  lea.l      -14(a2),a0
  movea.l    (a7)+,a2
  rts

ImExclamation:
  move.l     a2,-(a7)
  lea.l      ~_381,a2
  move.w     (a2),d0
  bne.s      ImExclamation_1
  move.w     #$0001,(a2)
  move.w     HandAES,d2
  moveq.l    #32,d1
  moveq.l    #4,d0
  lea.l      -142(a2),a0
  jsr        RastTrans
ImExclamation_1:
  lea.l      -14(a2),a0
  movea.l    (a7)+,a2
  rts

ImSignQuestion:
  move.l     a2,-(a7)
  lea.l      ~_385,a2
  move.w     (a2),d0
  bne.s      ImSignQuestion_1
  move.w     #$0001,(a2)
  move.w     HandAES,d2
  moveq.l    #32,d1
  moveq.l    #4,d0
  lea.l      -142(a2),a0
  jsr        RastTrans
ImSignQuestion_1:
  lea.l      -14(a2),a0
  movea.l    (a7)+,a2
  rts

ImSignStop:
  move.l     a2,-(a7)
  lea.l      ~_389,a2
  move.w     (a2),d0
  bne.s      ImSignStop_1
  move.w     #$0001,(a2)
  move.w     HandAES,d2
  moveq.l    #32,d1
  moveq.l    #4,d0
  lea.l      -142(a2),a0
  jsr        RastTrans
ImSignStop_1:
  lea.l      -14(a2),a0
  movea.l    (a7)+,a2
  rts

ImSqQuestionMark:
  move.l     a2,-(a7)
  lea.l      ~_393,a2
  move.w     (a2),d0
  bne.s      ImSqQuestionMark_1
  move.w     #$0001,(a2)
  move.w     HandAES,d2
  moveq.l    #32,d1
  moveq.l    #4,d0
  lea.l      -142(a2),a0
  jsr        RastTrans
ImSqQuestionMark_1:
  lea.l      -14(a2),a0
  movea.l    (a7)+,a2
  rts

ImSqExclamation:
  move.l     a2,-(a7)
  lea.l      ~_397,a2
  move.w     (a2),d0
  bne.s      ImSqExclamation_1
  move.w     #$0001,(a2)
  move.w     HandAES,d2
  moveq.l    #32,d1
  moveq.l    #4,d0
  lea.l      -142(a2),a0
  jsr        RastTrans
ImSqExclamation_1:
  lea.l      -14(a2),a0
  movea.l    (a7)+,a2
  rts

evnt_event:
  move.l     a2,-(a7)
  move.l     a3,-(a7)
  movea.l    a0,a2
  lea.l      _GemParBlk,a3
  moveq.l    #28,d0
  movea.l    a0,a1
  lea.l      190(a3),a0
  jsr        memcpy
  move.l     28(a2),792(a3)
  moveq.l    #-1,d0
  and.w      34(a2),d0
  move.w     d0,218(a3)
  move.l     32(a2),d1
  moveq.l    #16,d2
  lsr.l      d2,d1
  move.w     d1,220(a3)
  moveq.l    #25,d0
  jsr        _AesCtrl
  moveq.l    #12,d0
  lea.l      448(a3),a1
  lea.l      36(a2),a0
  jsr        memcpy
  move.w     446(a3),d0
  movea.l    (a7)+,a3
  movea.l    (a7)+,a2
  rts

vdi:
  move.l     4(a7),d1
  move.w     #$0073,d0
  trap       #2
  rts

vst_arbpt:
  movem.l    a2-a4,-(a7)
  movea.l    a0,a3
  movea.l    a1,a4
  lea.l      _GemParBlk,a2
  move.w     d1,190(a2)
  move.w     #$00F6,(a2)
  clr.w      d1
  move.w     d1,2(a2)
  move.w     d1,4(a2)
  move.w     #$0001,6(a2)
  move.w     d0,12(a2)
  pea.l      ~_399
  jsr        vdi
  addq.w     #4,a7
  move.w     536(a2),(a3)
  move.w     538(a2),(a4)
  movea.l    16(a7),a0
  move.w     540(a2),(a0)
  movea.l    20(a7),a1
  move.w     542(a2),(a1)
  move.w     446(a2),d0
  movem.l    (a7)+,a2-a4
  rts

vqt_devinfo:
  movem.l    a2-a4,-(a7)
  movea.l    a0,a3
  movea.l    a1,a4
  lea.l      _GemParBlk,a2
  move.w     d0,12(a2)
  move.w     d1,190(a2)
  move.w     #$00F8,(a2)
  clr.w      2(a2)
  move.w     #$0001,6(a2)
  pea.l      ~_401
  jsr        vdi
  addq.w     #4,a7
  move.w     536(a2),(a3)
  move.w     (a3),d0
  beq.s      vqt_devinfo_1
  clr.w      d1
  bra.s      vqt_devinfo_2
vqt_devinfo_3:
  move.w     d1,d0
  add.w      d0,d0
  lea.l      447(a2),a0
  move.b     0(a0,d0.w),0(a4,d1.w)
  addq.w     #1,d1
vqt_devinfo_2:
  cmp.w      8(a2),d1
  ble.s      vqt_devinfo_3
vqt_devinfo_1:
  movem.l    (a7)+,a2-a4
  rts

SlidDraw:
  movem.l    d3-d7/a2-a6,-(a7)
  lea.l      -22(a7),a7
  movea.l    a0,a2
  move.w     d0,20(a7)
  move.w     d1,18(a7)
  move.w     d2,16(a7)
  move.w     138(a2),d0
  bne.s      SlidDraw_1
  movea.w    #$0001,a1
  move.w     a1,138(a2)
  move.w     a1,68(a7)
SlidDraw_1:
  lea.l      8(a7),a3
  lea.l      10(a7),a4
  lea.l      12(a7),a5
  lea.l      14(a7),a6
  pea.l      (a3)
  pea.l      (a4)
  movea.l    a5,a1
  movea.l    a6,a0
  jsr        HandScreenSize
  addq.w     #8,a7
  pea.l      (a7)
  pea.l      6(a7)
  move.w     (a3),-(a7)
  move.w     (a4),-(a7)
  move.w     (a5),-(a7)
  move.w     (a6),-(a7)
  move.w     82(a7),-(a7)
  lea.l      22(a7),a1
  lea.l      24(a7),a0
  move.w     34(a7),d2
  move.w     36(a7),d1
  move.w     38(a7),d0
  jsr        RectInter
  lea.l      18(a7),a7
  move.w     14(a2),d3
  move.w     (a2),d0
  beq.s      SlidDraw_2
  move.w     106(a2),d4
  move.w     110(a2),d7
  bra.s      SlidDraw_3
SlidDraw_2:
  move.w     108(a2),d4
  move.w     112(a2),d7
SlidDraw_3:
  move.w     68(a7),d0
  beq.s      SlidDraw_4
  move.w     (a7),-(a7)
  move.w     4(a7),-(a7)
  move.w     8(a7),-(a7)
  move.w     12(a7),d2
  moveq.l    #10,d1
  lea.l      18(a2),a0
  clr.w      d0
  jsr        objc_draw
  addq.w     #6,a7
  bra        SlidDraw_5
SlidDraw_4:
  cmp.w      d4,d3
  beq        SlidDraw_5
  cmp.w      d3,d4
  bge.s      SlidDraw_6
  move.w     d4,d0
  add.w      d7,d0
  cmp.w      d0,d3
  bge.s      SlidDraw_6
  move.w     d0,d5
  move.w     d3,d6
  sub.w      d4,d6
  bra.s      SlidDraw_7
SlidDraw_6:
  cmp.w      d4,d3
  bge.s      SlidDraw_8
  move.w     d3,d0
  add.w      d7,d0
  cmp.w      d0,d4
  bge.s      SlidDraw_8
  move.w     d3,d5
  move.w     d4,d6
  sub.w      d3,d6
  bra.s      SlidDraw_7
SlidDraw_8:
  move.w     d3,d5
  move.w     d7,d6
SlidDraw_7:
  move.w     (a2),d0
  beq.s      SlidDraw_9
  pea.l      (a3)
  pea.l      (a4)
  move.w     74(a7),-(a7)
  move.w     d6,-(a7)
  move.w     30(a7),-(a7)
  move.w     d5,d1
  add.w      16(a2),d1
  move.w     d1,-(a7)
  move.w     16(a7),-(a7)
  movea.l    a5,a1
  movea.l    a6,a0
  move.w     20(a7),d2
  move.w     24(a7),d0
  move.w     22(a7),d1
  jsr        RectInter
  lea.l      18(a7),a7
  move.w     d0,d7
  bra.s      SlidDraw_10
SlidDraw_9:
  pea.l      (a3)
  pea.l      (a4)
  move.w     d6,-(a7)
  move.w     26(a7),-(a7)
  move.w     d5,d0
  add.w      16(a2),d0
  move.w     d0,-(a7)
  move.w     34(a7),-(a7)
  move.w     16(a7),-(a7)
  movea.l    a5,a1
  movea.l    a6,a0
  move.w     20(a7),d2
  move.w     22(a7),d1
  move.w     24(a7),d0
  jsr        RectInter
  lea.l      18(a7),a7
  move.w     d0,d7
SlidDraw_10:
  tst.w      d7
  beq.s      SlidDraw_11
  move.w     (a3),-(a7)
  move.w     (a4),-(a7)
  move.w     (a5),-(a7)
  move.w     (a6),d2
  clr.w      d1
  moveq.l    #2,d0
  lea.l      18(a2),a0
  jsr        objc_draw
  addq.w     #6,a7
SlidDraw_11:
  move.w     66(a7),-(a7)
  move.w     18(a7),-(a7)
  move.w     22(a7),-(a7)
  move.w     26(a7),d2
  clr.w      d1
  moveq.l    #3,d0
  lea.l      18(a2),a0
  jsr        objc_draw
  addq.w     #6,a7
SlidDraw_5:
  move.w     68(a7),d0
  beq.s      SlidDraw_12
  move.w     d4,14(a2)
SlidDraw_12:
  lea.l      22(a7),a7
  movem.l    (a7)+,d3-d7/a2-a6
  rts

SlidDrCompleted:
  move.w     (a0),d0
  beq.s      SlidDrCompleted_1
  move.w     106(a0),14(a0)
  rts
SlidDrCompleted_1:
  move.w     108(a0),14(a0)
  rts

SlidSlidSize:
  movem.l    d3-d5/a2,-(a7)
  movea.l    a0,a2
  move.w     d0,d3
  move.w     #$FFFF,14(a2)
  move.w     d0,8(a2)
  addq.w     #1,d0
  beq.s      SlidSlidSize_1
  tst.w      d3
  bne.s      SlidSlidSize_2
  move.w     (a0),d1
  beq.s      SlidSlidSize_3
  move.w     86(a2),d4
  bra.s      SlidSlidSize_4
SlidSlidSize_3:
  move.w     88(a2),d4
  bra.s      SlidSlidSize_4
SlidSlidSize_2:
  move.w     (a2),d0
  beq.s      SlidSlidSize_5
  move.w     86(a2),d5
  bra.s      SlidSlidSize_6
SlidSlidSize_5:
  move.w     88(a2),d5
SlidSlidSize_6:
  ext.l      d5
  move.l     d5,d0
  move.w     d3,d1
  ext.l      d1
  jsr        _lmul
  move.l     d0,d5
  move.w     8(a2),d1
  ext.l      d1
  add.l      4(a2),d1
  jsr        _ldiv
  move.l     d0,d5
  move.w     d5,d4
  cmp.w      62(a2),d5
  bge.s      SlidSlidSize_4
SlidSlidSize_1:
  move.w     62(a2),d4
SlidSlidSize_4:
  move.w     (a2),d0
  beq.s      SlidSlidSize_7
  move.w     d4,110(a2)
  bra.s      SlidSlidSize_8
SlidSlidSize_7:
  move.w     d4,112(a2)
SlidSlidSize_8:
  movem.l    (a7)+,d3-d5/a2
  rts

SlidScale:
  move.l     a2,-(a7)
  movea.l    a0,a2
  move.w     #$FFFF,14(a2)
  move.l     d0,4(a2)
  move.w     8(a2),d0
  jsr        SlidSlidSize(pc)
  movea.l    (a7)+,a2
  rts

SlidPos:
  movem.l    d3-d4/a2,-(a7)
  movea.l    a0,a2
  move.l     d0,d3
  cmp.l      10(a2),d0
  beq.s      SlidPos_1
  move.l     d0,10(a2)
  move.w     (a0),d1
  beq.s      SlidPos_2
  move.w     86(a2),d0
  sub.w      110(a2),d0
  bra.s      SlidPos_3
SlidPos_2:
  move.w     88(a2),d0
  sub.w      112(a2),d0
SlidPos_3:
  move.w     d0,d4
  ext.l      d4
  move.l     d4,d0
  move.l     d3,d1
  jsr        _lmul
  move.l     d0,d4
  move.l     4(a2),d1
  jsr        _ldiv
  move.l     d0,d4
  move.w     (a2),d1
  beq.s      SlidPos_4
  move.w     d4,106(a2)
  bra.s      SlidPos_1
SlidPos_4:
  move.w     d4,108(a2)
SlidPos_1:
  movem.l    (a7)+,d3-d4/a2
  rts

SlidCreate:
  movem.l    d3-d4/a2,-(a7)
  movea.l    a0,a2
  move.w     d0,d4
  move.w     d1,d3
  move.l     a2,d2
  bne.s      SlidCreate_1
  moveq.l    #1,d0
  move.l     #$0000008C,d1
  jsr        calloc
  movea.l    a0,a2
SlidCreate_1:
  move.l     a2,d0
  bne.s      SlidCreate_2
  suba.l     a0,a0
  bra.s      SlidCreate_3
SlidCreate_2:
  move.w     d3,2(a2)
  move.w     d4,(a2)
  move.l     #$000003E8,d0
  movea.l    a2,a0
  jsr        SlidScale(pc)
  moveq.l    #-1,d0
  movea.l    a2,a0
  jsr        SlidSlidSize(pc)
  moveq.l    #0,d0
  movea.l    a2,a0
  jsr        SlidPos(pc)
  moveq.l    #120,d0
  lea.l      ~_403,a1
  lea.l      18(a2),a0
  jsr        memcpy
  clr.w      d0
  bra.s      SlidCreate_4
SlidCreate_5:
  clr.w      d1
  moveq.l    #24,d2
  muls.w     d0,d2
  move.w     d1,36(a2,d2.w)
  move.w     d1,34(a2,d2.w)
  move.w     HandBYSize,40(a2,d2.w)
  move.w     HandBXSize,38(a2,d2.w)
  addq.w     #1,d0
SlidCreate_4:
  cmp.w      #$0004,d0
  ble.s      SlidCreate_5
  movea.l    a2,a0
SlidCreate_3:
  movem.l    (a7)+,d3-d4/a2
  rts

SlidDelete:
  jsr        free
  rts

SlidExtents:
  movem.l    d3-d4/a2,-(a7)
  movea.l    a0,a2
  subq.w     #1,d0
  subq.w     #1,d1
  addq.w     #2,d2
  move.w     #$FFFF,14(a2)
  move.w     d0,34(a2)
  move.w     d1,36(a2)
  tst.w      (a0)
  beq.s      SlidExtents_1
  move.w     d2,38(a2)
  moveq.l    #-1,d3
  add.w      62(a2),d3
  move.w     d3,82(a2)
  moveq.l    #2,d3
  add.w      d2,d3
  move.w     62(a2),d4
  add.w      d4,d4
  sub.w      d4,d3
  move.w     d3,86(a2)
  move.w     d0,d4
  add.w      82(a2),d4
  move.w     d4,16(a2)
  bra.s      SlidExtents_2
SlidExtents_1:
  andi.w     #$00FF,54(a2)
  ori.w      #$0100,54(a2)
  andi.w     #$00FF,126(a2)
  ori.w      #$0200,126(a2)
  move.w     d2,40(a2)
  moveq.l    #-1,d0
  add.w      64(a2),d0
  move.w     d0,84(a2)
  moveq.l    #2,d3
  add.w      d2,d3
  move.w     64(a2),d4
  add.w      d4,d4
  sub.w      d4,d3
  move.w     d3,88(a2)
  move.w     d1,d0
  add.w      84(a2),d0
  move.w     d0,16(a2)
SlidExtents_2:
  clr.w      d0
  move.w     d0,60(a2)
  move.w     d0,58(a2)
  move.w     38(a2),d1
  sub.w      134(a2),d1
  move.w     d1,130(a2)
  move.w     40(a2),d0
  sub.w      136(a2),d0
  move.w     d0,132(a2)
  move.w     8(a2),d0
  movea.l    a2,a0
  jsr        SlidSlidSize(pc)
  movem.l    (a7)+,d3-d4/a2
  rts

SlidClick:
  movem.l    d3-d7/a2-a3,-(a7)
  subq.w     #6,a7
  movea.l    a0,a2
  move.w     d0,d5
  move.w     d1,(a7)
  move.w     d2,d4
  move.w     38(a7),d6
  move.w     (a0),d0
  beq.s      SlidClick_1
  move.w     86(a2),d3
  sub.w      110(a2),d3
  bra.s      SlidClick_2
SlidClick_1:
  move.w     88(a2),d3
  sub.w      112(a2),d3
SlidClick_2:
  move.w     (a7),-(a7)
  move.w     d5,d2
  moveq.l    #2,d1
  clr.w      d0
  lea.l      18(a2),a0
  jsr        objc_find
  addq.w     #2,a7
  cmp.w      #$FFFF,d0
  bne.s      SlidClick_3
  moveq.l    #-1,d0
  bra        SlidClick_4
SlidClick_3:
  move.w     d0,d1
  subq.w     #1,d1
  beq.s      SlidClick_5
  subq.w     #1,d1
  beq        SlidClick_6
  subq.w     #1,d1
  beq        SlidClick_7
  subq.w     #1,d1
  beq.s      SlidClick_8
  bra        SlidClick_9
SlidClick_5:
  tst.w      d6
  beq.s      SlidClick_10
  lea.l      18(a2),a3
  moveq.l    #1,d0
  move.w     d0,-(a7)
  move.w     d0,-(a7)
  move.w     22(a3),-(a7)
  move.w     20(a3),-(a7)
  move.w     18(a3),-(a7)
  move.w     16(a3),d2
  clr.w      d1
  movea.l    a3,a0
  jsr        objc_change
  lea.l      10(a7),a7
SlidClick_10:
  move.l     10(a2),d7
  move.w     2(a2),d0
  ext.l      d0
  sub.l      d0,d7
  cmp.w      #$0001,d4
  ble        SlidClick_9
  moveq.l    #0,d7
  bra        SlidClick_9
SlidClick_8:
  tst.w      d6
  beq.s      SlidClick_11
  lea.l      18(a2),a3
  moveq.l    #1,d0
  move.w     d0,-(a7)
  move.w     d0,-(a7)
  move.w     22(a3),-(a7)
  move.w     20(a3),-(a7)
  move.w     18(a3),-(a7)
  move.w     16(a3),d2
  clr.w      d1
  movea.l    a3,a0
  moveq.l    #4,d0
  jsr        objc_change
  lea.l      10(a7),a7
SlidClick_11:
  move.w     2(a2),d7
  ext.l      d7
  add.l      10(a2),d7
  cmp.w      #$0001,d4
  ble        SlidClick_9
  move.l     4(a2),d7
  bra        SlidClick_9
SlidClick_6:
  pea.l      2(a7)
  lea.l      8(a7),a1
  moveq.l    #3,d0
  lea.l      18(a2),a0
  jsr        ObjcOffset
  addq.w     #4,a7
  cmp.w      4(a7),d5
  blt.s      SlidClick_12
  move.w     (a7),d0
  cmp.w      2(a7),d0
  bge.s      SlidClick_13
SlidClick_12:
  move.l     10(a2),d7
  move.w     8(a2),d0
  ext.l      d0
  sub.l      d0,d7
  bra        SlidClick_9
SlidClick_13:
  move.w     8(a2),d7
  ext.l      d7
  add.l      10(a2),d7
  bra.w      SlidClick_9
SlidClick_7:
  cmp.w      #$0002,d4
  beq.s      SlidClick_14
  tst.w      d6
  beq.s      SlidClick_15
  move.l     4(a2),d0
  move.w     d3,d1
  muls.w     2(a2),d1
  ext.l      d1
  cmp.l      d1,d0
  bge.s      SlidClick_15
SlidClick_14:
  moveq.l    #-2,d0
  bra.s      SlidClick_4
SlidClick_15:
  moveq.l    #3,d0
  jsr        WindUpdate
  moveq.l    #1,d2
  sub.w      (a2),d2
  moveq.l    #3,d1
  moveq.l    #2,d0
  lea.l      18(a2),a0
  jsr        graf_slidebox
  move.w     d0,d4
  moveq.l    #2,d0
  jsr        WindUpdate
  move.l     4(a2),d0
  move.w     d4,d1
  ext.l      d1
  jsr        _lmul
  move.l     d0,d4
  move.l     #$000003E8,d1
  jsr        _ldiv
  move.l     d0,d7
  ext.l      d7
  move.l     d4,d0
  move.l     #$000003E8,d1
  jsr        _lmod
  cmp.l      #$000001F4,d0
  blt.s      SlidClick_9
  addq.l     #1,d7
SlidClick_9:
  cmp.l      4(a2),d7
  ble.s      SlidClick_16
  move.l     4(a2),d7
  bra.s      SlidClick_17
SlidClick_16:
  tst.l      d7
  bge.s      SlidClick_17
  moveq.l    #0,d7
SlidClick_17:
  move.l     d7,d0
SlidClick_4:
  addq.w     #6,a7
  movem.l    (a7)+,d3-d7/a2-a3
  rts

SlidAdjustSlider:
  movem.l    d3-d5/a2,-(a7)
  subq.w     #8,a7
  movea.l    a0,a2
  move.w     d0,d4
  move.w     d1,d3
  pea.l      4(a7)
  lea.l      10(a7),a1
  lea.l      18(a2),a0
  moveq.l    #2,d0
  jsr        ObjcOffset
  addq.w     #4,a7
  pea.l      (a7)
  lea.l      6(a7),a1
  moveq.l    #3,d0
  lea.l      18(a2),a0
  jsr        ObjcOffset
  addq.w     #4,a7
  move.w     (a2),d0
  bne.s      SlidAdjustSlider_1
  move.w     112(a2),d1
  asr.w      #1,d1
  sub.w      d1,d3
  cmp.w      4(a7),d3
  ble        SlidAdjustSlider_2
  move.w     4(a7),d2
  add.w      88(a2),d2
  cmp.w      d2,d3
  bge.s      SlidAdjustSlider_3
  sub.w      4(a7),d3
  move.w     88(a2),d5
  sub.w      112(a2),d5
  tst.w      d5
  beq.s      SlidAdjustSlider_2
  move.w     d3,d0
  ext.l      d0
  move.l     4(a2),d1
  jsr        _lmul
  move.w     d5,d1
  ext.l      d1
  jsr        _ldiv
  bra.s      SlidAdjustSlider_4
SlidAdjustSlider_1:
  move.w     110(a2),d0
  asr.w      #1,d0
  sub.w      d0,d4
  cmp.w      6(a7),d4
  ble.s      SlidAdjustSlider_2
  move.w     6(a7),d1
  add.w      86(a2),d1
  cmp.w      d1,d4
  blt.s      SlidAdjustSlider_5
SlidAdjustSlider_3:
  move.l     4(a2),d0
  bra.s      SlidAdjustSlider_4
SlidAdjustSlider_5:
  sub.w      6(a7),d4
  move.w     86(a2),d5
  sub.w      110(a2),d5
  tst.w      d5
  beq.s      SlidAdjustSlider_2
  move.w     d4,d0
  ext.l      d0
  move.l     4(a2),d1
  jsr        _lmul
  move.w     d5,d1
  ext.l      d1
  jsr        _ldiv
  bra.s      SlidAdjustSlider_4
SlidAdjustSlider_2:
  moveq.l    #0,d0
SlidAdjustSlider_4:
  addq.w     #8,a7
  movem.l    (a7)+,d3-d5/a2
  rts

SlidDeselect:
  move.l     a2,-(a7)
  move.l     a3,-(a7)
  movea.l    a0,a2
  lea.l      18(a2),a3
  moveq.l    #1,d0
  and.w      34(a3),d0
  beq.s      SlidDeselect_1
  moveq.l    #1,d1
  move.w     d1,-(a7)
  clr.w      -(a7)
  move.w     22(a3),-(a7)
  move.w     20(a3),-(a7)
  move.w     18(a3),-(a7)
  move.w     16(a3),d2
  movea.l    a3,a0
  move.w     d1,d0
  clr.w      d1
  jsr        objc_change
  lea.l      10(a7),a7
SlidDeselect_1:
  moveq.l    #1,d0
  and.w      106(a3),d0
  beq.s      SlidDeselect_2
  moveq.l    #1,d1
  move.w     d1,-(a7)
  clr.w      -(a7)
  move.w     22(a3),-(a7)
  move.w     20(a3),-(a7)
  move.w     18(a3),-(a7)
  move.w     16(a3),d2
  lea.l      18(a2),a0
  moveq.l    #4,d0
  clr.w      d1
  jsr        objc_change
  lea.l      10(a7),a7
SlidDeselect_2:
  movea.l    (a7)+,a3
  movea.l    (a7)+,a2
  rts

~_404:
  move.l     d3,-(a7)
  move.l     a2,-(a7)
  movea.l    a0,a2
  move.l     d0,d3
  move.w     8(a2),d1
  bge.s      ~_404_1
  movea.l    64(a2),a0
  jsr        SlidPos
  bra.s      ~_404_2
~_404_1:
  movea.l    64(a2),a0
  move.l     4(a0),d0
  bne.s      ~_404_3
  moveq.l    #1,d1
  move.w     d1,-(a7)
  move.w     8(a2),d0
  moveq.l    #9,d1
  jsr        wind_set
  addq.w     #2,a7
  bra.s      ~_404_2
~_404_3:
  move.l     d3,d0
  lsl.l      #5,d0
  sub.l      d3,d0
  lsl.l      #2,d0
  add.l      d3,d0
  lsl.l      #3,d0
  movea.l    64(a2),a0
  move.l     4(a0),d1
  jsr        _ldiv
  move.w     d0,-(a7)
  moveq.l    #9,d1
  move.w     8(a2),d0
  jsr        wind_set
  addq.w     #2,a7
~_404_2:
  movea.l    (a7)+,a2
  move.l     (a7)+,d3
  rts

~_405:
  move.l     d3,-(a7)
  move.l     a2,-(a7)
  movea.l    a0,a2
  move.l     d0,d3
  move.w     8(a2),d1
  bge.s      ~_405_1
  movea.l    68(a2),a0
  jsr        SlidPos
  bra.s      ~_405_2
~_405_1:
  movea.l    68(a2),a0
  move.l     4(a0),d0
  bne.s      ~_405_3
  moveq.l    #1,d1
  move.w     d1,-(a7)
  move.w     8(a2),d0
  moveq.l    #8,d1
  jsr        wind_set
  addq.w     #2,a7
  bra.s      ~_405_2
~_405_3:
  move.l     d3,d0
  lsl.l      #5,d0
  sub.l      d3,d0
  lsl.l      #2,d0
  add.l      d3,d0
  lsl.l      #3,d0
  movea.l    68(a2),a0
  move.l     4(a0),d1
  jsr        _ldiv
  move.w     d0,-(a7)
  moveq.l    #8,d1
  move.w     8(a2),d0
  jsr        wind_set
  addq.w     #2,a7
~_405_2:
  movea.l    (a7)+,a2
  move.l     (a7)+,d3
  rts

~_406:
  move.w     d3,-(a7)
  move.l     a2,-(a7)
  movea.l    a0,a2
  move.w     d0,d3
  move.w     8(a2),d1
  bge.s      ~_406_1
  movea.l    64(a2),a0
  jsr        SlidSlidSize
  bra.s      ~_406_2
~_406_1:
  cmp.w      #$FFFF,d3
  bne.s      ~_406_3
  move.w     d3,-(a7)
  moveq.l    #16,d1
  move.w     8(a2),d0
  jsr        wind_set
  addq.w     #2,a7
  bra.s      ~_406_2
~_406_3:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #5,d0
  sub.l      d1,d0
  lsl.l      #2,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.l     58(a2),d1
  jsr        _ldiv
  move.w     d0,-(a7)
  moveq.l    #16,d1
  move.w     8(a2),d0
  jsr        wind_set
  addq.w     #2,a7
~_406_2:
  movea.l    (a7)+,a2
  move.w     (a7)+,d3
  rts

~_407:
  move.w     d3,-(a7)
  move.l     a2,-(a7)
  movea.l    a0,a2
  move.w     d0,d3
  move.w     8(a2),d1
  bge.s      ~_407_1
  movea.l    68(a2),a0
  jsr        SlidSlidSize
  bra.s      ~_407_2
~_407_1:
  cmp.w      #$FFFF,d3
  bne.s      ~_407_3
  move.w     d3,-(a7)
  moveq.l    #15,d1
  move.w     8(a2),d0
  jsr        wind_set
  addq.w     #2,a7
  bra.s      ~_407_2
~_407_3:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #5,d0
  sub.l      d1,d0
  lsl.l      #2,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     32(a2),d1
  ext.l      d1
  jsr        _ldiv
  move.w     d0,-(a7)
  moveq.l    #15,d1
  move.w     8(a2),d0
  jsr        wind_set
  addq.w     #2,a7
~_407_2:
  movea.l    (a7)+,a2
  move.w     (a7)+,d3
  rts

~_408:
  move.l     a2,-(a7)
  move.l     a3,-(a7)
  lea.l      -24(a7),a7
  movea.l    a0,a3
  lea.l      8(a7),a2
  pea.l      6(a2)
  pea.l      4(a2)
  lea.l      2(a2),a1
  movea.l    a2,a0
  jsr        HandScreenSize
  addq.w     #8,a7
  pea.l      (a7)
  movea.l    a2,a1
  movea.l    a3,a0
  jsr        RectGInter
  addq.w     #4,a7
  tst.w      d0
  beq.s      ~_408_1
  lea.l      16(a7),a1
  lea.l      (a7),a0
  jsr        RectGRECT2VDI
  moveq.l    #1,d1
  move.w     DialWk,d0
  jsr        vsf_color
  moveq.l    #3,d1
  move.w     DialWk,d0
  jsr        vswr_mode
  lea.l      16(a7),a0
  move.w     DialWk,d0
  jsr        vr_recfl
~_408_1:
  lea.l      24(a7),a7
  movea.l    (a7)+,a3
  movea.l    (a7)+,a2
  rts

~_409:
  cmp.l      44(a0),d0
  blt.s      ~_409_1
  move.w     62(a0),d1
  ext.l      d1
  add.l      44(a0),d1
  cmp.l      d1,d0
  bge.s      ~_409_1
  moveq.l    #1,d2
  bra.s      ~_409_2
~_409_1:
  clr.w      d2
~_409_2:
  move.w     d2,d0
  rts

~_410:
  move.l     d3,-(a7)
  cmp.l      d0,d1
  bge.s      ~_410_1
  cmp.l      d0,d2
  bgt.s      ~_410_2
  cmp.l      d2,d1
  bgt.s      ~_410_2
  moveq.l    #1,d3
  bra.s      ~_410_3
~_410_2:
  clr.w      d3
~_410_3:
  move.w     d3,d0
  bra.s      ~_410_4
~_410_1:
  cmp.l      d1,d2
  bgt.s      ~_410_5
  cmp.l      d2,d0
  bgt.s      ~_410_5
  moveq.l    #1,d3
  bra.s      ~_410_6
~_410_5:
  clr.w      d3
~_410_6:
  move.w     d3,d0
~_410_4:
  move.l     (a7)+,d3
  rts

~_411:
  moveq.l    #0,d0
  bra.s      ~_411_1
~_411_2:
  addq.l     #1,d0
  movea.l    (a0),a0
~_411_1:
  move.l     a0,d1
  bne.s      ~_411_2
  rts

ListIndex2List:
  bra.s      ListIndex2List_1
ListIndex2List_2:
  subq.l     #1,d0
  movea.l    (a0),a0
ListIndex2List_1:
  tst.l      d0
  bne.s      ListIndex2List_2
  rts

~_412:
  move.l     d3,-(a7)
  move.l     a2,-(a7)
  movea.l    a0,a2
  moveq.l    #1,d3
  move.l     (a0),d0
  beq.s      ~_412_1
  pea.l      12(a2)
  lea.l      10(a2),a1
  move.w     4(a2),d0
  movea.l    (a0),a0
  jsr        ObjcOffset
  addq.w     #4,a7
  move.w     4(a2),d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  movea.l    (a2),a0
  move.w     20(a0,d0.l),14(a2)
  move.w     4(a2),d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  movea.l    (a2),a0
  move.w     22(a0,d0.l),16(a2)
~_412_1:
  move.w     20(a2),d0
  beq.s      ~_412_2
  move.w     16(a2),d3
  ext.l      d3
  divs.w     d0,d3
  move.w     16(a2),d1
  ext.l      d1
  divs.w     d0,d1
  swap       d1
  tst.w      d1
  beq.s      ~_412_3
  bra.s      ~_412_4
~_412_2:
  move.w     14(a2),d3
  ext.l      d3
  divs.w     18(a2),d3
  move.w     14(a2),d0
  ext.l      d0
  divs.w     18(a2),d0
  swap       d0
  tst.w      d0
  beq.s      ~_412_3
~_412_4:
  addq.w     #1,d3
~_412_3:
  move.w     d3,d0
  movea.l    (a7)+,a2
  move.l     (a7)+,d3
  rts

ListInit:
  movem.l    d3-d4/a2,-(a7)
  movea.l    a0,a2
  move.l     (a0),d0
  beq        ListInit_1
  move.w     4(a2),d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  movea.l    d0,a1
  move.w     2(a1,d1.l),d3
  tst.w      d3
  blt.s      ListInit_2
  move.w     d3,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  move.w     20(a1,d1.l),d0
  move.w     d0,22(a2)
  move.w     d0,18(a2)
  movea.l    (a0),a1
  move.w     22(a1,d1.l),d2
  move.w     d2,24(a2)
  move.w     d2,20(a2)
ListInit_2:
  move.w     4(a2),d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  movea.l    (a2),a0
  move.w     2(a0,d0.l),d3
  tst.w      d3
  blt.s      ListInit_1
  move.w     d3,d0
  ext.l      d0
  move.l     d0,d2
  add.l      d2,d2
  add.l      d0,d2
  lsl.l      #3,d2
  move.w     0(a0,d2.l),d4
  blt.s      ListInit_1
  move.w     d4,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  move.w     16(a0,d1.l),d0
  move.w     d3,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  sub.w      16(a0,d1.l),d0
  jsr        abs
  move.w     d0,18(a2)
  move.w     d4,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  movea.l    (a2),a0
  move.w     18(a0,d1.l),d0
  move.w     d3,d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  sub.w      18(a0,d1.l),d0
  jsr        abs
  move.w     d0,20(a2)
ListInit_1:
  movea.l    48(a2),a0
  jsr        ~_411(pc)
  move.l     d0,58(a2)
  movea.l    a2,a0
  jsr        ~_412(pc)
  move.w     d0,62(a2)
  ext.l      d0
  cmp.l      58(a2),d0
  ble.s      ListInit_3
  move.w     60(a2),d1
  bra.s      ListInit_4
ListInit_3:
  move.w     62(a2),d1
ListInit_4:
  move.w     d1,62(a2)
  ext.l      d1
  add.l      44(a2),d1
  cmp.l      58(a2),d1
  ble.s      ListInit_5
  move.l     58(a2),d0
  move.w     62(a2),d2
  ext.l      d2
  sub.l      d2,d0
  move.l     d0,44(a2)
ListInit_5:
  moveq.l    #1,d1
  clr.w      d0
  suba.l     a0,a0
  jsr        SlidCreate
  move.l     a0,64(a2)
  move.l     a0,d0
  beq        ListInit_6
  move.w     26(a2),d1
  bgt.s      ListInit_7
  move.w     10(a2),d2
  add.w      14(a2),d2
  move.w     d2,26(a2)
ListInit_7:
  move.w     28(a2),d0
  bgt.s      ListInit_8
  move.w     12(a2),28(a2)
ListInit_8:
  move.w     30(a2),d0
  bgt.s      ListInit_9
  move.w     16(a2),30(a2)
ListInit_9:
  addq.w     #1,26(a2)
  move.w     30(a2),d2
  move.w     28(a2),d1
  move.w     26(a2),d0
  movea.l    64(a2),a0
  jsr        SlidExtents
  move.l     58(a2),d0
  move.w     62(a2),d1
  ext.l      d1
  sub.l      d1,d0
  movea.l    64(a2),a0
  jsr        SlidScale
  move.w     62(a2),d0
  movea.l    a2,a0
  jsr        ~_406(pc)
  move.l     44(a2),d0
  movea.l    a2,a0
  jsr        ~_404(pc)
  move.w     32(a2),d0
  ble        ListInit_10
  move.w     34(a2),d1
  suba.l     a0,a0
  moveq.l    #1,d0
  jsr        SlidCreate
  move.l     a0,68(a2)
  move.l     a0,d0
  bne.s      ListInit_11
  movea.l    64(a2),a0
  jsr        SlidDelete
ListInit_6:
  clr.w      d0
  bra        ListInit_12
ListInit_11:
  move.w     38(a2),d0
  bgt.s      ListInit_13
  move.w     10(a2),38(a2)
ListInit_13:
  move.w     40(a2),d0
  bgt.s      ListInit_14
  move.w     12(a2),d1
  add.w      16(a2),d1
  move.w     d1,40(a2)
ListInit_14:
  move.w     42(a2),d0
  bgt.s      ListInit_15
  move.w     14(a2),42(a2)
ListInit_15:
  addq.w     #1,40(a2)
  move.w     36(a2),d0
  add.w      14(a2),d0
  cmp.w      32(a2),d0
  ble.s      ListInit_16
  move.w     32(a2),d1
  sub.w      14(a2),d1
  move.w     d1,36(a2)
ListInit_16:
  move.w     42(a2),d2
  move.w     40(a2),d1
  move.w     38(a2),d0
  movea.l    68(a2),a0
  jsr        SlidExtents
  move.w     32(a2),d0
  sub.w      42(a2),d0
  ext.l      d0
  movea.l    68(a2),a0
  jsr        SlidScale
  move.w     42(a2),d0
  movea.l    a2,a0
  jsr        ~_407(pc)
  move.w     36(a2),d0
  ext.l      d0
  movea.l    a2,a0
  jsr        ~_405(pc)
  bra.s      ListInit_17
ListInit_10:
  clr.l      68(a2)
ListInit_17:
  move.l     (a2),d0
  beq        ListInit_18
  move.w     4(a2),d2
  ext.l      d2
  move.l     d2,d1
  add.l      d1,d1
  add.l      d2,d1
  lsl.l      #3,d1
  movea.l    d0,a0
  move.w     6(a2),d4
  ext.l      d4
  move.l     d4,d3
  add.l      d3,d3
  add.l      d4,d3
  lsl.l      #3,d3
  movea.l    d0,a1
  move.w     20(a0,d1.l),20(a1,d3.l)
  move.w     4(a2),d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  movea.l    (a2),a0
  move.w     6(a2),d3
  ext.l      d3
  move.l     d3,d2
  add.l      d2,d2
  add.l      d3,d2
  lsl.l      #3,d2
  movea.l    (a2),a1
  move.w     22(a0,d0.l),22(a1,d2.l)
  move.l     64(a2),d0
  beq.s      ListInit_19
  moveq.l    #-1,d1
  add.w      HandBXSize,d1
  move.w     6(a2),d3
  ext.l      d3
  move.l     d3,d2
  add.l      d2,d2
  add.l      d3,d2
  lsl.l      #3,d2
  movea.l    (a2),a0
  add.w      d1,20(a0,d2.l)
ListInit_19:
  move.l     68(a2),d0
  beq.s      ListInit_18
  moveq.l    #-1,d1
  add.w      HandBYSize,d1
  move.w     6(a2),d3
  ext.l      d3
  move.l     d3,d2
  add.l      d2,d2
  add.l      d3,d2
  lsl.l      #3,d2
  movea.l    (a2),a0
  add.w      d1,22(a0,d2.l)
ListInit_18:
  moveq.l    #1,d0
ListInit_12:
  movem.l    (a7)+,d3-d4/a2
  rts

~_413:
  movem.l    d3/a2-a5,-(a7)
  lea.l      -24(a7),a7
  movea.l    a0,a2
  movea.l    a1,a5
  lea.l      8(a7),a3
  lea.l      10(a2),a1
  movea.l    a3,a0
  move.l     (a1)+,(a0)+
  move.l     (a1)+,(a0)+
  lea.l      16(a7),a4
  pea.l      (a4)
  movea.l    a3,a1
  movea.l    a5,a0
  jsr        RectGInter
  addq.w     #4,a7
  tst.w      d0
  beq.s      ~_413_1
  move.l     (a2),d0
  beq.s      ~_413_2
  move.w     6(a4),-(a7)
  move.w     4(a4),-(a7)
  move.w     2(a4),-(a7)
  move.w     (a4),d2
  clr.w      d1
  move.w     4(a2),d0
  movea.l    (a2),a0
  jsr        objc_draw
  addq.w     #6,a7
  bra.s      ~_413_1
~_413_2:
  move.l     a2,-(a7)
  clr.w      -(a7)
  movea.l    a4,a1
  move.w     36(a2),d2
  move.w     2(a3),d1
  move.w     (a3),d0
  suba.l     a0,a0
  movea.l    52(a2),a2
  jsr        (a2)
  addq.w     #2,a7
  movea.l    (a7)+,a2
~_413_1:
  lea.l      10(a2),a0
  movea.l    a3,a1
  move.l     (a0)+,(a1)+
  move.l     (a0)+,(a1)+
  move.w     22(a2),4(a3)
  move.w     24(a2),6(a3)
  move.l     44(a2),d0
  movea.l    48(a2),a0
  jsr        ListIndex2List(pc)
  movea.l    a0,a5
  clr.w      d3
  bra.s      ~_413_3
~_413_5:
  pea.l      (a7)
  movea.l    a3,a1
  movea.l    a4,a0
  jsr        RectGInter
  addq.w     #4,a7
  tst.w      d0
  beq.s      ~_413_4
  move.l     a2,-(a7)
  moveq.l    #1,d0
  move.w     d0,-(a7)
  lea.l      6(a7),a1
  move.w     36(a2),d2
  move.w     2(a3),d1
  movea.l    a5,a0
  movea.l    52(a2),a2
  move.w     (a3),d0
  jsr        (a2)
  addq.w     #2,a7
  movea.l    (a7)+,a2
~_413_4:
  move.w     18(a2),d0
  add.w      d0,(a3)
  move.w     20(a2),d1
  add.w      d1,2(a3)
  movea.l    (a5),a5
  addq.w     #1,d3
~_413_3:
  cmp.w      62(a2),d3
  blt.s      ~_413_5
  lea.l      24(a7),a7
  movem.l    (a7)+,d3/a2-a5
  rts

ListWindDraw:
  movem.l    d3/a2-a5,-(a7)
  lea.l      -16(a7),a7
  movea.l    a0,a2
  movea.l    a1,a3
  move.w     d0,d3
  move.w     #$0100,d0
  suba.l     a0,a0
  jsr        GrafMouse
  move.w     8(a2),d0
  bge.s      ListWindDraw_1
  movea.l    a3,a1
  movea.l    a2,a0
  jsr        ~_413(pc)
  move.w     d3,-(a7)
  move.w     #$7FFF,-(a7)
  move.w     #$7FFF,d2
  clr.w      d1
  clr.w      d0
  movea.l    64(a2),a0
  jsr        SlidDraw
  addq.w     #4,a7
  movea.l    64(a2),a0
  jsr        SlidDrCompleted
  move.l     68(a2),d0
  beq        ListWindDraw_2
  move.w     d3,-(a7)
  move.w     #$7FFF,-(a7)
  move.w     #$7FFF,d2
  clr.w      d1
  movea.l    d0,a0
  clr.w      d0
  jsr        SlidDraw
  addq.w     #4,a7
  movea.l    68(a2),a0
  jsr        SlidDrCompleted
  bra        ListWindDraw_2
ListWindDraw_1:
  moveq.l    #1,d0
  jsr        WindUpdate
  lea.l      8(a7),a4
  lea.l      10(a7),a5
  pea.l      (a4)
  pea.l      (a5)
  pea.l      20(a7)
  pea.l      26(a7)
  moveq.l    #11,d1
  move.w     8(a2),d0
  jsr        wind_get
  lea.l      16(a7),a7
  bra.s      ListWindDraw_3
ListWindDraw_6:
  pea.l      6(a7)
  pea.l      8(a7)
  move.w     (a4),-(a7)
  move.w     (a5),-(a7)
  move.w     24(a7),-(a7)
  move.w     28(a7),-(a7)
  move.w     6(a3),-(a7)
  lea.l      20(a7),a1
  lea.l      18(a7),a0
  move.w     4(a3),d2
  move.w     2(a3),d1
  move.w     (a3),d0
  jsr        RectInter
  lea.l      18(a7),a7
  tst.w      d0
  beq.s      ListWindDraw_4
  lea.l      (a7),a1
  movea.l    a2,a0
  jsr        ~_413(pc)
ListWindDraw_4:
  pea.l      (a4)
  pea.l      (a5)
  pea.l      20(a7)
  pea.l      26(a7)
  moveq.l    #12,d1
  move.w     8(a2),d0
  jsr        wind_get
  lea.l      16(a7),a7
ListWindDraw_3:
  move.w     (a5),d0
  beq.s      ListWindDraw_5
  move.w     (a4),d1
  bne.s      ListWindDraw_6
ListWindDraw_5:
  clr.w      d0
  jsr        WindUpdate
ListWindDraw_2:
  suba.l     a0,a0
  move.w     #$0101,d0
  jsr        GrafMouse
  lea.l      16(a7),a7
  movem.l    (a7)+,d3/a2-a5
  rts

ListDraw:
  movem.l    a2-a6,-(a7)
  lea.l      -32(a7),a7
  movea.l    a0,a2
  move.w     #$0100,d0
  suba.l     a0,a0
  jsr        GrafMouse
  pea.l      6(a7)
  pea.l      8(a7)
  lea.l      10(a7),a1
  lea.l      8(a7),a0
  jsr        HandScreenSize
  addq.w     #8,a7
  lea.l      8(a7),a3
  lea.l      10(a2),a0
  movea.l    a3,a1
  move.l     (a0)+,(a1)+
  move.l     (a0)+,(a1)+
  move.w     8(a2),d0
  bge.s      ListDraw_1
  moveq.l    #1,d1
  move.w     d1,-(a7)
  move.w     8(a7),-(a7)
  move.w     8(a7),d2
  movea.l    64(a2),a0
  move.w     4(a7),d0
  move.w     6(a7),d1
  jsr        SlidDraw
  addq.w     #4,a7
  move.l     68(a2),d0
  beq.s      ListDraw_2
  moveq.l    #1,d1
  move.w     d1,-(a7)
  move.w     8(a7),-(a7)
  move.w     8(a7),d2
  movea.l    d0,a0
  move.w     4(a7),d0
  move.w     6(a7),d1
  jsr        SlidDraw
  addq.w     #4,a7
ListDraw_2:
  movea.l    a3,a1
  movea.l    a2,a0
  jsr        ~_413(pc)
  bra        ListDraw_3
ListDraw_1:
  moveq.l    #1,d0
  jsr        WindUpdate
  lea.l      16(a7),a4
  lea.l      18(a7),a5
  pea.l      (a4)
  pea.l      (a5)
  pea.l      28(a7)
  pea.l      34(a7)
  moveq.l    #11,d1
  move.w     8(a2),d0
  jsr        wind_get
  lea.l      16(a7),a7
  lea.l      24(a7),a6
  bra.s      ListDraw_4
ListDraw_7:
  pea.l      6(a6)
  pea.l      4(a6)
  move.w     (a4),-(a7)
  move.w     (a5),-(a7)
  move.w     32(a7),-(a7)
  move.w     36(a7),-(a7)
  move.w     6(a3),-(a7)
  lea.l      2(a6),a1
  movea.l    a6,a0
  move.w     4(a3),d2
  move.w     2(a3),d1
  move.w     (a3),d0
  jsr        RectInter
  lea.l      18(a7),a7
  tst.w      d0
  beq.s      ListDraw_5
  movea.l    a6,a1
  movea.l    a2,a0
  jsr        ~_413(pc)
ListDraw_5:
  pea.l      (a4)
  pea.l      (a5)
  pea.l      28(a7)
  pea.l      34(a7)
  moveq.l    #12,d1
  move.w     8(a2),d0
  jsr        wind_get
  lea.l      16(a7),a7
ListDraw_4:
  move.w     (a5),d0
  beq.s      ListDraw_6
  move.w     (a4),d1
  bne.s      ListDraw_7
ListDraw_6:
  clr.w      d0
  jsr        WindUpdate
ListDraw_3:
  suba.l     a0,a0
  move.w     #$0101,d0
  jsr        GrafMouse
  lea.l      32(a7),a7
  movem.l    (a7)+,a2-a6
  rts

~_414:
  movem.l    d3-d7/a2-a6,-(a7)
  lea.l      -58(a7),a7
  movea.l    a0,a2
  move.w     d0,24(a7)
  move.w     d1,22(a7)
  move.w     d2,20(a7)
  move.w     104(a7),d4
  clr.l      (a7)
  move.w     8(a2),d2
  bge.s      ~_414_1
  move.w     106(a7),-(a7)
  move.w     d4,-(a7)
  move.w     106(a7),-(a7)
  lea.l      6(a7),a0
  move.w     26(a7),d2
  jsr        RastBufCopy
  addq.w     #6,a7
  bra        ~_414_2
~_414_1:
  moveq.l    #1,d0
  jsr        WindUpdate
  lea.l      36(a7),a4
  pea.l      34(a7)
  pea.l      (a4)
  pea.l      46(a7)
  pea.l      52(a7)
  moveq.l    #11,d1
  move.w     8(a2),d0
  jsr        wind_get
  lea.l      16(a7),a7
  lea.l      26(a7),a5
  lea.l      28(a7),a6
  lea.l      42(a7),a3
  bra        ~_414_3
~_414_12:
  pea.l      (a5)
  pea.l      (a6)
  move.w     42(a7),-(a7)
  move.w     (a4),-(a7)
  move.w     50(a7),-(a7)
  move.w     54(a7),-(a7)
  move.w     118(a7),-(a7)
  lea.l      48(a7),a1
  lea.l      50(a7),a0
  move.w     38(a7),d2
  move.w     124(a7),d1
  move.w     d4,d0
  jsr        RectInter
  lea.l      18(a7),a7
  tst.w      d0
  beq        ~_414_4
  move.w     32(a7),d5
  sub.w      d4,d5
  add.w      24(a7),d5
  move.w     30(a7),d6
  sub.w      106(a7),d6
  add.w      22(a7),d6
  move.w     (a6),d3
  move.w     (a5),d7
  pea.l      50(a7)
  pea.l      56(a7)
  move.w     42(a7),-(a7)
  move.w     (a4),-(a7)
  move.w     50(a7),-(a7)
  move.w     54(a7),-(a7)
  move.w     d7,-(a7)
  lea.l      72(a7),a1
  lea.l      74(a7),a0
  move.w     d3,d2
  move.w     d6,d1
  move.w     d5,d0
  jsr        RectInter
  lea.l      18(a7),a7
  tst.w      d0
  beq        ~_414_5
  move.w     56(a7),d7
  sub.w      d5,d7
  add.w      32(a7),d7
  move.w     54(a7),d3
  sub.w      d6,d3
  add.w      30(a7),d3
  clr.w      d0
  move.w     32(a7),(a3)
  move.w     30(a7),2(a3)
  move.w     d0,6(a3)
  move.w     d0,4(a3)
  move.w     (a6),d1
  cmp.w      52(a7),d1
  ble.s      ~_414_6
  move.w     (a5),d2
  cmp.w      50(a7),d2
  ble.s      ~_414_7
  moveq.l    #1,d0
  bra.s      ~_414_8
~_414_7:
  clr.w      d0
~_414_8:
  move.w     (a6),d1
  sub.w      52(a7),d1
  move.w     d1,4(a3)
  move.w     (a5),6(a3)
  cmp.w      32(a7),d7
  bne.s      ~_414_9
  move.w     52(a7),d2
  add.w      d2,(a3)
  bra.s      ~_414_9
~_414_6:
  move.w     (a5),d1
  cmp.w      50(a7),d1
  ble.s      ~_414_9
  sub.w      50(a7),d1
  move.w     d1,6(a3)
  move.w     (a6),4(a3)
  cmp.w      30(a7),d3
  bne.s      ~_414_9
  move.w     50(a7),d2
  add.w      d2,2(a3)
~_414_9:
  tst.w      d0
  bne.s      ~_414_5
  move.w     d3,-(a7)
  move.w     d7,-(a7)
  move.w     54(a7),-(a7)
  lea.l      6(a7),a0
  move.w     58(a7),d2
  move.w     60(a7),d1
  move.w     62(a7),d0
  jsr        RastBufCopy
  addq.w     #6,a7
  bra.s      ~_414_10
~_414_5:
  move.w     32(a7),(a3)
  move.w     30(a7),2(a3)
  move.w     (a6),4(a3)
  move.w     (a5),6(a3)
~_414_10:
  move.w     4(a3),d0
  ble.s      ~_414_4
  move.w     6(a3),d1
  ble.s      ~_414_4
  movea.l    a3,a1
  movea.l    a2,a0
  jsr        ~_413(pc)
~_414_4:
  pea.l      34(a7)
  pea.l      (a4)
  pea.l      46(a7)
  pea.l      52(a7)
  moveq.l    #12,d1
  move.w     8(a2),d0
  jsr        wind_get
  lea.l      16(a7),a7
~_414_3:
  move.w     (a4),d0
  beq.s      ~_414_11
  move.w     34(a7),d1
  bne        ~_414_12
~_414_11:
  clr.w      d0
  jsr        WindUpdate
~_414_2:
  lea.l      58(a7),a7
  movem.l    (a7)+,d3-d7/a2-a6
  rts

ListVScroll:
  movem.l    d3-d5/a2-a3,-(a7)
  lea.l      -16(a7),a7
  movea.l    a0,a2
  move.l     d0,d3
  jsr        ListMoved
  move.l     44(a2),d5
  add.l      d3,d5
  move.w     62(a2),d0
  ext.l      d0
  add.l      d5,d0
  cmp.l      58(a2),d0
  ble.s      ListVScroll_1
  move.l     58(a2),d5
  move.w     62(a2),d1
  ext.l      d1
  sub.l      d1,d5
ListVScroll_1:
  tst.l      d5
  bge.s      ListVScroll_2
  moveq.l    #0,d5
ListVScroll_2:
  cmp.l      44(a2),d5
  beq        ListVScroll_3
  move.w     46(a2),d4
  sub.w      d5,d4
  move.l     44(a2),d0
  sub.l      d5,d0
  jsr        labs
  move.l     d0,d3
  move.l     d5,44(a2)
  move.l     d5,d0
  movea.l    a2,a0
  jsr        ~_404(pc)
  move.l     d3,d0
  jsr        labs
  move.w     62(a2),d5
  ext.l      d5
  sub.l      d0,d5
  lea.l      8(a7),a3
  lea.l      10(a2),a0
  movea.l    a3,a1
  move.l     (a0)+,(a1)+
  move.l     (a0)+,(a1)+
  movea.l    a3,a0
  jsr        RectClipWithScreen
  movea.l    a3,a0
  lea.l      (a7),a1
  move.l     (a0)+,(a1)+
  move.l     (a0)+,(a1)+
  move.w     HandAES,d0
  jsr        v_hide_c
  tst.l      d5
  ble        ListVScroll_4
  move.w     d5,d0
  muls.w     20(a2),d0
  move.w     d0,6(a3)
  move.w     62(a2),d1
  muls.w     20(a2),d1
  sub.w      16(a2),d1
  sub.w      d1,6(a3)
  move.w     6(a3),6(a7)
  tst.w      d4
  bge.s      ListVScroll_5
  move.w     d3,d2
  muls.w     20(a2),d2
  add.w      d2,2(a3)
  bra.s      ListVScroll_6
ListVScroll_5:
  move.w     d3,d0
  muls.w     20(a2),d0
  add.w      d0,2(a7)
ListVScroll_6:
  movea.l    a3,a0
  jsr        RectClipWithScreen
  move.w     6(a3),d5
  move.w     2(a7),-(a7)
  move.w     2(a7),-(a7)
  move.w     d5,-(a7)
  move.w     4(a3),d2
  move.w     2(a3),d1
  move.w     (a3),d0
  movea.l    a2,a0
  jsr        ~_414(pc)
  addq.w     #6,a7
  lea.l      10(a2),a0
  movea.l    a3,a1
  move.l     (a0)+,(a1)+
  move.l     (a0)+,(a1)+
  move.w     16(a2),d0
  sub.w      6(a7),d0
  move.w     d0,6(a3)
  tst.w      d4
  bge.s      ListVScroll_4
  add.w      d5,2(a3)
ListVScroll_4:
  clr.w      d0
  movea.l    a3,a1
  movea.l    a2,a0
  jsr        ListWindDraw(pc)
  moveq.l    #1,d1
  move.w     HandAES,d0
  jsr        v_show_c
ListVScroll_3:
  lea.l      16(a7),a7
  movem.l    (a7)+,d3-d5/a2-a3
  rts

ListHScroll:
  movem.l    d3-d5/a2-a3,-(a7)
  lea.l      -16(a7),a7
  movea.l    a0,a2
  move.w     d0,d3
  jsr        ListMoved
  move.w     36(a2),d5
  add.w      d3,d5
  move.w     d5,d0
  add.w      14(a2),d0
  cmp.w      32(a2),d0
  ble.s      ListHScroll_1
  move.w     32(a2),d5
  sub.w      14(a2),d5
ListHScroll_1:
  tst.w      d5
  bge.s      ListHScroll_2
  clr.w      d5
ListHScroll_2:
  cmp.w      36(a2),d5
  beq        ListHScroll_3
  move.w     36(a2),d4
  sub.w      d5,d4
  move.w     d4,d0
  jsr        abs
  move.w     d0,d3
  move.w     d5,36(a2)
  move.w     d5,d0
  ext.l      d0
  movea.l    a2,a0
  jsr        ~_405(pc)
  move.w     d3,d0
  jsr        abs
  move.w     14(a2),d5
  sub.w      d0,d5
  lea.l      8(a7),a3
  lea.l      10(a2),a0
  movea.l    a3,a1
  move.l     (a0)+,(a1)+
  move.l     (a0)+,(a1)+
  movea.l    a3,a0
  jsr        RectClipWithScreen
  movea.l    a3,a0
  lea.l      (a7),a1
  move.l     (a0)+,(a1)+
  move.l     (a0)+,(a1)+
  move.w     HandAES,d0
  jsr        v_hide_c
  tst.w      d5
  ble.s      ListHScroll_4
  move.w     d5,4(a3)
  move.w     d5,4(a7)
  tst.w      d4
  bge.s      ListHScroll_5
  add.w      d3,(a3)
  bra.s      ListHScroll_6
ListHScroll_5:
  add.w      d3,(a7)
ListHScroll_6:
  movea.l    a3,a0
  jsr        RectClipWithScreen
  lea.l      (a7),a0
  jsr        RectClipWithScreen
  move.w     4(a3),d0
  cmp.w      4(a7),d0
  ble.s      ListHScroll_7
  move.w     4(a7),d1
  bra.s      ListHScroll_8
ListHScroll_7:
  move.w     4(a3),d1
ListHScroll_8:
  move.w     d1,4(a3)
  move.w     d1,d5
  move.w     2(a7),-(a7)
  move.w     2(a7),-(a7)
  move.w     6(a3),-(a7)
  move.w     d1,d2
  move.w     (a3),d0
  movea.l    a2,a0
  move.w     2(a3),d1
  jsr        ~_414(pc)
  addq.w     #6,a7
  lea.l      10(a2),a0
  movea.l    a3,a1
  move.l     (a0)+,(a1)+
  move.l     (a0)+,(a1)+
  move.w     d3,4(a3)
  tst.w      d4
  bge.s      ListHScroll_4
  add.w      d5,(a3)
ListHScroll_4:
  clr.w      d0
  movea.l    a3,a1
  movea.l    a2,a0
  jsr        ListWindDraw(pc)
  moveq.l    #1,d1
  move.w     HandAES,d0
  jsr        v_show_c
ListHScroll_3:
  lea.l      16(a7),a7
  movem.l    (a7)+,d3-d5/a2-a3
  rts

~_415:
  movem.l    a2-a3/a5-a6,-(a7)
  lea.l      -36(a7),a7
  movea.l    a0,a2
  move.l     a1,16(a7)
  sub.w      46(a2),d0
  lea.l      8(a7),a3
  lea.l      10(a2),a1
  movea.l    a3,a0
  move.l     (a1)+,(a0)+
  move.l     (a1)+,(a0)+
  move.w     d0,d1
  muls.w     18(a2),d1
  add.w      d1,(a3)
  move.w     d0,d2
  muls.w     20(a2),d2
  add.w      d2,2(a3)
  move.w     22(a2),4(a3)
  move.w     24(a2),6(a3)
  movea.l    a3,a0
  lea.l      (a7),a1
  move.l     (a0)+,(a1)+
  move.l     (a0)+,(a1)+
  pea.l      (a3)
  lea.l      10(a2),a1
  lea.l      4(a7),a0
  jsr        RectGInter
  addq.w     #4,a7
  tst.w      d0
  beq        ~_415_1
  move.w     HandAES,d0
  jsr        v_hide_c
  move.w     8(a2),d0
  bge.s      ~_415_2
  move.l     a2,-(a7)
  clr.w      -(a7)
  movea.l    a3,a1
  move.w     36(a2),d2
  move.w     8(a7),d1
  movea.l    22(a7),a0
  movea.l    52(a2),a2
  move.w     6(a7),d0
  jsr        (a2)
  addq.w     #2,a7
  movea.l    (a7)+,a2
  bra        ~_415_3
~_415_2:
  moveq.l    #1,d0
  jsr        WindUpdate
  lea.l      28(a7),a6
  pea.l      (a6)
  pea.l      34(a7)
  pea.l      40(a7)
  pea.l      46(a7)
  moveq.l    #11,d1
  move.w     8(a2),d0
  jsr        wind_get
  lea.l      16(a7),a7
  lea.l      20(a7),a5
  bra.s      ~_415_4
~_415_7:
  pea.l      6(a5)
  pea.l      4(a5)
  move.w     (a6),-(a7)
  move.w     40(a7),-(a7)
  move.w     44(a7),-(a7)
  move.w     48(a7),-(a7)
  move.w     6(a3),-(a7)
  lea.l      2(a5),a1
  movea.l    a5,a0
  move.w     4(a3),d2
  move.w     2(a3),d1
  move.w     (a3),d0
  jsr        RectInter
  lea.l      18(a7),a7
  tst.w      d0
  beq.s      ~_415_5
  move.l     a2,-(a7)
  clr.w      -(a7)
  movea.l    a5,a1
  move.w     36(a2),d2
  move.w     8(a7),d1
  move.w     6(a7),d0
  movea.l    22(a7),a0
  movea.l    52(a2),a2
  jsr        (a2)
  addq.w     #2,a7
  movea.l    (a7)+,a2
~_415_5:
  pea.l      (a6)
  pea.l      34(a7)
  pea.l      40(a7)
  pea.l      46(a7)
  moveq.l    #12,d1
  move.w     8(a2),d0
  jsr        wind_get
  lea.l      16(a7),a7
~_415_4:
  move.w     30(a7),d0
  beq.s      ~_415_6
  move.w     (a6),d1
  bne.w      ~_415_7
~_415_6:
  clr.w      d0
  jsr        WindUpdate
~_415_3:
  moveq.l    #1,d1
  move.w     HandAES,d0
  jsr        v_show_c
~_415_1:
  lea.l      36(a7),a7
  movem.l    (a7)+,a2-a3/a5-a6
  rts

~_416:
  movem.l    d3/a2-a6,-(a7)
  lea.l      -32(a7),a7
  movea.l    a0,a2
  move.w     d0,d3
  move.w     HandAES,d0
  jsr        v_hide_c
  lea.l      8(a7),a3
  lea.l      10(a2),a0
  movea.l    a3,a1
  move.l     (a0)+,(a1)+
  move.l     (a0)+,(a1)+
  move.w     d3,d0
  muls.w     18(a2),d0
  add.w      d0,(a3)
  move.w     d3,d1
  muls.w     20(a2),d1
  add.w      d1,2(a3)
  move.w     22(a2),4(a3)
  move.w     24(a2),6(a3)
  movea.l    a3,a0
  lea.l      (a7),a1
  move.l     (a0)+,(a1)+
  move.l     (a0)+,(a1)+
  pea.l      (a3)
  lea.l      10(a2),a1
  lea.l      4(a7),a0
  jsr        RectGInter
  addq.w     #4,a7
  tst.w      d0
  beq        ~_416_1
  move.w     8(a2),d0
  bge.s      ~_416_2
  movea.l    a3,a1
  movea.l    a2,a0
  jsr        ~_413(pc)
  bra        ~_416_1
~_416_2:
  moveq.l    #1,d0
  jsr        WindUpdate
  lea.l      24(a7),a4
  lea.l      26(a7),a5
  pea.l      (a4)
  pea.l      (a5)
  pea.l      36(a7)
  pea.l      42(a7)
  moveq.l    #11,d1
  move.w     8(a2),d0
  jsr        wind_get
  lea.l      16(a7),a7
  lea.l      16(a7),a6
  bra.s      ~_416_3
~_416_6:
  pea.l      6(a6)
  pea.l      4(a6)
  move.w     (a4),-(a7)
  move.w     (a5),-(a7)
  move.w     40(a7),-(a7)
  move.w     44(a7),-(a7)
  move.w     6(a3),-(a7)
  lea.l      2(a6),a1
  movea.l    a6,a0
  move.w     4(a3),d2
  move.w     2(a3),d1
  move.w     (a3),d0
  jsr        RectInter
  lea.l      18(a7),a7
  tst.w      d0
  beq.s      ~_416_4
  movea.l    a6,a1
  movea.l    a2,a0
  jsr        ~_413(pc)
~_416_4:
  pea.l      (a4)
  pea.l      (a5)
  pea.l      36(a7)
  pea.l      42(a7)
  moveq.l    #12,d1
  move.w     8(a2),d0
  jsr        wind_get
  lea.l      16(a7),a7
~_416_3:
  move.w     (a5),d0
  beq.s      ~_416_5
  move.w     (a4),d1
  bne.s      ~_416_6
~_416_5:
  clr.w      d0
  jsr        WindUpdate
~_416_1:
  moveq.l    #1,d1
  move.w     HandAES,d0
  jsr        v_show_c
  lea.l      32(a7),a7
  movem.l    (a7)+,d3/a2-a6
  rts

ListUpdateEntry:
  move.l     d3,-(a7)
  move.l     a2,-(a7)
  movea.l    a0,a2
  move.l     d0,d3
  jsr        ListMoved
  move.l     d3,d0
  movea.l    a2,a0
  jsr        ~_409(pc)
  tst.w      d0
  beq.s      ListUpdateEntry_1
  move.w     d3,d0
  sub.w      46(a2),d0
  movea.l    a2,a0
  jsr        ~_416(pc)
ListUpdateEntry_1:
  movea.l    (a7)+,a2
  move.l     (a7)+,d3
  rts

ListInvertEntry:
  move.l     d3,-(a7)
  move.l     a2,-(a7)
  movea.l    a0,a2
  move.l     d0,d3
  jsr        ListMoved
  move.l     d3,d0
  movea.l    a2,a0
  jsr        ~_409(pc)
  tst.w      d0
  beq.s      ListInvertEntry_1
  move.l     d3,d0
  movea.l    48(a2),a0
  jsr        ListIndex2List(pc)
  movea.l    a0,a1
  movea.l    a2,a0
  move.l     d3,d0
  jsr        ~_415(pc)
ListInvertEntry_1:
  movea.l    (a7)+,a2
  move.l     (a7)+,d3
  rts

~_417:
  movem.l    d3-d4/a2,-(a7)
  movea.l    a0,a2
  move.l     d0,d4
  suba.l     a0,a0
  jsr        Super
  move.l     d0,d3
~_417_1:
  move.l     ($000004BA).w,d0
  sub.l      d4,d0
  moveq.l    #75,d1
  divs.w     62(a2),d1
  ext.l      d1
  cmp.l      d1,d0
  blt.s      ~_417_1
  movea.l    d3,a0
  jsr        Super
  movem.l    (a7)+,d3-d4/a2
  rts

~_418:
  move.l     d3,-(a7)
  move.l     d4,-(a7)
  suba.l     a0,a0
  jsr        Super
  move.l     d0,d3
  move.l     ($000004BA).w,d4
  movea.l    d3,a0
  jsr        Super
  move.l     d4,d0
  move.l     (a7)+,d4
  move.l     (a7)+,d3
  rts

ListMoved:
  movem.l    d3-d4/a2,-(a7)
  subq.w     #4,a7
  movea.l    a0,a2
  move.l     (a0),d0
  beq        ListMoved_1
  pea.l      (a7)
  lea.l      6(a7),a1
  move.w     4(a2),d0
  movea.l    (a0),a0
  jsr        ObjcOffset
  addq.w     #4,a7
  move.w     10(a2),d0
  cmp.w      2(a7),d0
  bne.s      ListMoved_2
  move.w     12(a2),d1
  cmp.w      (a7),d1
  beq        ListMoved_1
ListMoved_2:
  move.w     2(a7),d3
  sub.w      10(a2),d3
  move.w     (a7),d4
  sub.w      12(a2),d4
  add.w      d3,10(a2)
  add.w      d4,12(a2)
  add.w      d3,26(a2)
  add.w      d4,28(a2)
  movea.l    64(a2),a0
  clr.w      138(a0)
  move.w     30(a2),d2
  move.w     28(a2),d1
  move.w     26(a2),d0
  movea.l    64(a2),a0
  jsr        SlidExtents
  move.l     58(a2),d0
  move.w     62(a2),d1
  ext.l      d1
  sub.l      d1,d0
  movea.l    64(a2),a0
  jsr        SlidScale
  move.w     62(a2),d0
  movea.l    a2,a0
  jsr        ~_406(pc)
  move.l     44(a2),d0
  movea.l    a2,a0
  jsr        ~_404(pc)
  move.l     68(a2),d0
  beq.s      ListMoved_3
  add.w      d3,38(a2)
  add.w      d4,40(a2)
  movea.l    68(a2),a0
  clr.w      138(a0)
  move.w     42(a2),d2
  move.w     40(a2),d1
  move.w     38(a2),d0
  movea.l    68(a2),a0
  jsr        SlidExtents
  move.w     32(a2),d0
  sub.w      42(a2),d0
  ext.l      d0
  movea.l    68(a2),a0
  jsr        SlidScale
  move.w     42(a2),d0
  movea.l    a2,a0
  jsr        ~_407(pc)
  move.w     36(a2),d0
  ext.l      d0
  movea.l    a2,a0
  jsr        ~_405(pc)
ListMoved_3:
  moveq.l    #1,d0
  bra.s      ListMoved_4
ListMoved_1:
  clr.w      d0
ListMoved_4:
  addq.w     #4,a7
  movem.l    (a7)+,d3-d4/a2
  rts

ListClick:
  movem.l    d3-d7/a2-a3/a5-a6,-(a7)
  lea.l      -84(a7),a7
  movea.l    a0,a2
  move.w     d0,d7
  clr.w      d6
  jsr        ListMoved(pc)
  lea.l      4(a7),a5
  pea.l      2(a7)
  pea.l      4(a7)
  movea.l    a5,a1
  lea.l      14(a7),a0
  jsr        graf_mkstate
  addq.w     #8,a7
  move.l     64(a2),d0
  beq        ListClick_1
  move.w     8(a2),d1
  bge.s      ListClick_2
  moveq.l    #1,d2
  bra.s      ListClick_3
ListClick_2:
  clr.w      d2
ListClick_3:
  move.w     d2,-(a7)
  move.w     (a5),d1
  move.w     8(a7),d0
  movea.l    64(a2),a0
  move.w     d7,d2
  jsr        SlidClick
  addq.w     #2,a7
  move.l     d0,d3
  moveq.l    #-2,d1
  cmp.l      d0,d1
  bne.s      ListClick_4
  lea.l      10(a7),a1
  lea.l      8(a7),a0
  jsr        GrafGetForm
  suba.l     a0,a0
  moveq.l    #4,d0
  jsr        GrafMouse
ListClick_5:
  move.w     (a5),d1
  move.w     6(a7),d0
  movea.l    64(a2),a0
  jsr        SlidAdjustSlider
  move.l     d0,d3
  sub.l      44(a2),d3
  move.l     d3,d0
  movea.l    a2,a0
  jsr        ListVScroll(pc)
  pea.l      2(a7)
  pea.l      4(a7)
  movea.l    a5,a1
  lea.l      14(a7),a0
  jsr        graf_mkstate
  addq.w     #8,a7
  move.w     (a7),d0
  bne.s      ListClick_5
  lea.l      10(a7),a0
  move.w     8(a7),d0
  jsr        GrafMouse
  bra        ListClick_6
ListClick_4:
  moveq.l    #-1,d0
  cmp.l      d3,d0
  beq.s      ListClick_1
  sub.l      44(a2),d3
ListClick_8:
  lea.l      8(a7),a3
  jsr        ~_418(pc)
  move.l     d0,d4
  movea.l    a2,a0
  move.l     d3,d0
  jsr        ListVScroll(pc)
  moveq.l    #2,d0
  and.w      (a7),d0
  bne.s      ListClick_7
  movea.l    a2,a0
  move.l     d4,d0
  jsr        ~_417(pc)
ListClick_7:
  pea.l      (a3)
  pea.l      4(a7)
  movea.l    a3,a1
  movea.l    a3,a0
  jsr        graf_mkstate
  addq.w     #8,a7
  move.w     (a7),d0
  bne.s      ListClick_8
  movea.l    64(a2),a0
  jsr        SlidDeselect
  bra        ListClick_6
ListClick_1:
  move.l     68(a2),d0
  beq        ListClick_9
  move.w     8(a2),d1
  bge.s      ListClick_10
  moveq.l    #1,d2
  bra.s      ListClick_11
ListClick_10:
  clr.w      d2
ListClick_11:
  move.w     d2,-(a7)
  move.w     (a5),d1
  move.w     8(a7),d0
  movea.l    68(a2),a0
  move.w     d7,d2
  jsr        SlidClick
  addq.w     #2,a7
  move.l     d0,d3
  moveq.l    #-2,d1
  cmp.l      d0,d1
  bne.s      ListClick_12
  lea.l      10(a7),a1
  lea.l      8(a7),a0
  jsr        GrafGetForm
  suba.l     a0,a0
  moveq.l    #4,d0
  jsr        GrafMouse
ListClick_13:
  move.w     (a5),d1
  move.w     6(a7),d0
  movea.l    68(a2),a0
  jsr        SlidAdjustSlider
  move.l     d0,d3
  move.w     36(a2),d1
  ext.l      d1
  sub.l      d1,d3
  move.w     d3,d0
  movea.l    a2,a0
  jsr        ListHScroll(pc)
  pea.l      2(a7)
  pea.l      4(a7)
  movea.l    a5,a1
  lea.l      14(a7),a0
  jsr        graf_mkstate
  addq.w     #8,a7
  move.w     (a7),d0
  bne.s      ListClick_13
  lea.l      10(a7),a0
  move.w     8(a7),d0
  jsr        GrafMouse
  bra        ListClick_6
ListClick_12:
  moveq.l    #-1,d0
  cmp.l      d3,d0
  beq.s      ListClick_9
  move.w     36(a2),d1
  ext.l      d1
  sub.l      d1,d3
ListClick_15:
  lea.l      8(a7),a3
  jsr        ~_418(pc)
  move.l     d0,d4
  movea.l    a2,a0
  move.w     d3,d0
  jsr        ListHScroll(pc)
  moveq.l    #2,d0
  and.w      (a7),d0
  bne.s      ListClick_14
  movea.l    a2,a0
  move.l     d4,d0
  jsr        ~_417(pc)
ListClick_14:
  pea.l      (a3)
  pea.l      4(a7)
  movea.l    a3,a1
  movea.l    a3,a0
  jsr        graf_mkstate
  addq.w     #8,a7
  move.w     (a7),d0
  bne.s      ListClick_15
  movea.l    68(a2),a0
  jsr        SlidDeselect
  bra        ListClick_6
ListClick_9:
  move.w     (a5),-(a7)
  move.w     8(a7),-(a7)
  move.w     16(a2),-(a7)
  move.w     14(a2),d2
  move.w     12(a2),d1
  move.w     10(a2),d0
  jsr        RectInside
  addq.w     #6,a7
  tst.w      d0
  beq.w      ListClick_6
  move.w     56(a2),d0
  beq.w      ListClick_6
ListClick_34:
  move.w     (a5),d5
  sub.w      12(a2),d5
  ext.l      d5
  divs.w     20(a2),d5
  ext.l      d5
  jsr        ~_418(pc)
  move.l     d0,d4
  tst.w      d6
  beq.s      ListClick_16
  move.w     62(a2),d1
  ext.l      d1
  cmp.l      d1,d5
  blt.s      ListClick_17
  moveq.l    #-1,d5
  add.w      62(a2),d5
  ext.l      d5
  moveq.l    #2,d2
  and.w      (a7),d2
  bne.s      ListClick_18
  movea.l    a2,a0
  jsr        ~_417(pc)
ListClick_18:
  moveq.l    #1,d0
  movea.l    a2,a0
  jsr        ListVScroll(pc)
  bra.s      ListClick_19
ListClick_17:
  move.w     (a5),d0
  cmp.w      12(a2),d0
  bge.s      ListClick_16
  moveq.l    #0,d5
  moveq.l    #2,d1
  and.w      (a7),d1
  bne.s      ListClick_20
  movea.l    a2,a0
  move.l     d4,d0
  jsr        ~_417(pc)
ListClick_20:
  moveq.l    #-1,d0
  movea.l    a2,a0
  jsr        ListVScroll(pc)
ListClick_19:
  jsr        ~_418(pc)
  move.l     d0,d4
ListClick_16:
  add.l      44(a2),d5
  tst.l      d5
  blt.s      ListClick_6
  cmp.l      58(a2),d5
  blt.s      ListClick_21
ListClick_6:
  moveq.l    #-1,d0
  bra        ListClick_22
ListClick_21:
  move.l     d5,d0
  movea.l    48(a2),a0
  jsr        ListIndex2List(pc)
  movea.l    a0,a3
  moveq.l    #3,d0
  and.w      2(a7),d0
  beq.s      ListClick_23
  cmpi.w     #$0001,56(a2)
  bne.s      ListClick_24
ListClick_23:
  clr.w      d4
  movea.l    48(a2),a6
  bra.s      ListClick_25
ListClick_27:
  move.w     4(a6),d0
  moveq.l    #15,d1
  lsr.w      d1,d0
  and.w      #$0001,d0
  beq.s      ListClick_26
  cmpa.l     a6,a3
  beq.s      ListClick_26
  andi.w     #$7FFF,4(a6)
  move.w     d4,d0
  ext.l      d0
  movea.l    a2,a0
  jsr        ~_409(pc)
  tst.w      d0
  beq.s      ListClick_26
  move.w     d4,d0
  ext.l      d0
  movea.l    a6,a1
  movea.l    a2,a0
  jsr        ~_415(pc)
ListClick_26:
  addq.w     #1,d4
  movea.l    (a6),a6
ListClick_25:
  move.l     a6,d0
  bne.s      ListClick_27
ListClick_24:
  moveq.l    #3,d0
  and.w      2(a7),d0
  beq.s      ListClick_28
  move.w     4(a3),d0
  moveq.l    #15,d1
  lsr.w      d1,d0
  and.w      #$0001,d0
  moveq.l    #1,d2
  eor.w      d2,d0
  andi.w     #$7FFF,4(a3)
  and.w      #$0001,d0
  lsl.w      #8,d0
  lsl.w      #7,d0
  or.w       d0,4(a3)
  bra.s      ListClick_29
ListClick_28:
  move.w     4(a3),d0
  moveq.l    #15,d1
  lsr.w      d1,d0
  and.w      #$0001,d0
  bne.s      ListClick_30
  andi.w     #$7FFF,4(a3)
  ori.w      #$8000,4(a3)
ListClick_29:
  move.l     d5,d0
  movea.l    a3,a1
  movea.l    a2,a0
  jsr        ~_415(pc)
ListClick_30:
  move.w     d5,d4
  sub.w      46(a2),d4
  muls.w     18(a2),d4
  add.w      10(a2),d4
  move.w     d5,d3
  sub.w      46(a2),d3
  muls.w     20(a2),d3
  add.w      12(a2),d3
ListClick_32:
  pea.l      2(a7)
  pea.l      4(a7)
  movea.l    a5,a1
  lea.l      14(a7),a0
  jsr        graf_mkstate
  addq.w     #8,a7
  move.w     (a7),d0
  beq.s      ListClick_31
  move.w     (a5),-(a7)
  move.w     8(a7),-(a7)
  move.w     24(a2),-(a7)
  move.w     22(a2),d2
  move.w     d3,d1
  move.w     d4,d0
  jsr        RectInside
  addq.w     #6,a7
  tst.w      d0
  bne.s      ListClick_32
ListClick_31:
  moveq.l    #1,d6
  move.w     (a7),d0
  beq.s      ListClick_33
  cmpi.w     #$0001,56(a2)
  beq        ListClick_34
ListClick_33:
  cmpi.w     #$0002,56(a2)
  bge.s      ListClick_35
  move.l     d5,d0
  bra        ListClick_22
ListClick_35:
  move.l     d5,d3
  move.l     d5,d4
  bra        ListClick_36
ListClick_60:
  pea.l      2(a7)
  pea.l      4(a7)
  movea.l    a5,a1
  lea.l      14(a7),a0
  jsr        graf_mkstate
  addq.w     #8,a7
  move.w     18(a2),d0
  beq.s      ListClick_37
  move.w     6(a7),d1
  cmp.w      10(a2),d1
  blt.s      ListClick_38
  move.w     d1,d5
  sub.w      10(a2),d5
  ext.l      d5
  divs.w     d0,d5
  ext.l      d5
  bra.s      ListClick_39
ListClick_37:
  move.w     (a5),d0
  cmp.w      12(a2),d0
  bge.s      ListClick_40
ListClick_38:
  moveq.l    #-1,d5
  bra.s      ListClick_39
ListClick_40:
  move.w     (a5),d5
  sub.w      12(a2),d5
  ext.l      d5
  divs.w     20(a2),d5
  ext.l      d5
ListClick_39:
  add.l      44(a2),d5
  cmp.l      44(a2),d5
  bge.s      ListClick_41
  moveq.l    #-1,d0
  movea.l    a2,a0
  jsr        ListVScroll(pc)
  move.l     44(a2),d5
  bra.s      ListClick_42
ListClick_41:
  move.w     62(a2),d0
  ext.l      d0
  add.l      44(a2),d0
  cmp.l      d0,d5
  blt.s      ListClick_42
  movea.l    a2,a0
  moveq.l    #1,d0
  jsr        ListVScroll(pc)
  move.w     62(a2),d5
  ext.l      d5
  add.l      44(a2),d5
  subq.l     #1,d5
ListClick_42:
  cmp.l      d4,d3
  bge.s      ListClick_43
  move.l     d3,d0
  bra.s      ListClick_44
ListClick_43:
  move.l     d4,d0
ListClick_44:
  cmp.l      d0,d5
  ble.s      ListClick_45
  cmp.l      d4,d3
  bge.s      ListClick_46
  move.l     d3,d7
  bra.s      ListClick_47
ListClick_46:
  move.l     d4,d7
ListClick_47:
  bra.s      ListClick_48
ListClick_45:
  move.l     d5,d7
ListClick_48:
  cmp.l      d4,d3
  ble.s      ListClick_49
  move.l     d3,d0
  bra.s      ListClick_50
ListClick_49:
  move.l     d4,d0
ListClick_50:
  cmp.l      d0,d5
  bge.s      ListClick_51
  cmp.l      d4,d3
  ble.s      ListClick_52
  move.l     d3,d6
  bra.s      ListClick_53
ListClick_52:
  move.l     d4,d6
ListClick_53:
  bra.s      ListClick_54
ListClick_51:
  move.l     d5,d6
ListClick_54:
  move.l     d7,d0
  movea.l    48(a2),a0
  jsr        ListIndex2List(pc)
  movea.l    a0,a6
  bra        ListClick_55
ListClick_59:
  move.w     4(a6),d0
  moveq.l    #15,d1
  lsr.w      d1,d0
  and.w      #$0001,d0
  move.w     d0,8(a7)
  move.l     d7,d2
  move.l     d4,d0
  move.l     d3,d1
  jsr        ~_410(pc)
  tst.w      d0
  beq.s      ListClick_56
  move.w     4(a6),d0
  moveq.l    #15,d1
  lsr.w      d1,d0
  and.w      #$0001,d0
  moveq.l    #1,d2
  eor.w      d2,d0
  andi.w     #$7FFF,4(a6)
  and.w      #$0001,d0
  lsl.w      #8,d0
  lsl.w      #7,d0
  or.w       d0,4(a6)
ListClick_56:
  move.l     d7,d2
  move.l     d3,d1
  move.l     d5,d0
  jsr        ~_410(pc)
  tst.w      d0
  beq.s      ListClick_57
  move.w     4(a6),d0
  moveq.l    #15,d1
  lsr.w      d1,d0
  and.w      #$0001,d0
  moveq.l    #1,d2
  eor.w      d2,d0
  andi.w     #$7FFF,4(a6)
  and.w      #$0001,d0
  lsl.w      #8,d0
  lsl.w      #7,d0
  or.w       d0,4(a6)
ListClick_57:
  move.w     4(a6),d0
  moveq.l    #15,d1
  lsr.w      d1,d0
  and.w      #$0001,d0
  cmp.w      8(a7),d0
  beq.s      ListClick_58
  movea.l    a2,a0
  move.l     d7,d0
  jsr        ~_409(pc)
  tst.w      d0
  beq.s      ListClick_58
  move.l     d7,d0
  movea.l    a6,a1
  movea.l    a2,a0
  jsr        ~_415(pc)
ListClick_58:
  movea.l    (a6),a6
  addq.l     #1,d7
ListClick_55:
  cmp.l      d7,d6
  bge        ListClick_59
  move.l     d5,d4
ListClick_36:
  move.w     (a7),d0
  bne        ListClick_60
  moveq.l    #0,d0
ListClick_22:
  lea.l      84(a7),a7
  movem.l    (a7)+,d3-d7/a2-a3/a5-a6
  rts

ListExit:
  move.l     a2,-(a7)
  movea.l    a0,a2
  move.l     64(a2),d0
  beq.s      ListExit_1
  movea.l    d0,a0
  jsr        SlidDelete
  clr.l      64(a2)
ListExit_1:
  move.l     68(a2),d0
  beq.s      ListExit_2
  movea.l    d0,a0
  jsr        SlidDelete
  clr.l      68(a2)
ListExit_2:
  clr.w      d0
  move.w     d0,30(a2)
  move.w     d0,28(a2)
  move.w     d0,26(a2)
  clr.w      d1
  move.w     d1,42(a2)
  move.w     d1,40(a2)
  move.w     d1,38(a2)
  movea.l    (a7)+,a2
  rts

ListStdInit:
  move.l     a1,(a0)
  move.w     d0,4(a0)
  move.w     d1,6(a0)
  move.l     4(a7),52(a0)
  move.w     #$FFFF,8(a0)
  move.l     8(a7),48(a0)
  move.w     d2,32(a0)
  move.l     12(a7),44(a0)
  move.w     16(a7),56(a0)
  clr.w      d0
  move.w     d0,30(a0)
  move.w     d0,28(a0)
  move.w     d0,26(a0)
  clr.w      d1
  move.w     d1,36(a0)
  move.w     d1,42(a0)
  move.w     d1,40(a0)
  move.w     d1,38(a0)
  rts

ListScroll2Selection:
  move.l     d3,-(a7)
  move.l     a2,-(a7)
  movea.l    a0,a2
  clr.w      d0
  moveq.l    #-1,d1
  move.l     58(a2),d2
  move.w     62(a2),d3
  ext.l      d3
  cmp.l      d3,d2
  ble.w      ListScroll2Selection_1
  movea.l    48(a2),a0
  bra.s      ListScroll2Selection_2
ListScroll2Selection_5:
  move.w     4(a0),d2
  moveq.l    #15,d3
  lsr.w      d3,d2
  and.w      #$0001,d2
  beq.s      ListScroll2Selection_3
  move.w     d0,d1
ListScroll2Selection_3:
  movea.l    (a0),a0
  addq.w     #1,d0
ListScroll2Selection_2:
  move.l     a0,d2
  beq.s      ListScroll2Selection_4
  cmp.w      #$FFFF,d1
  beq.s      ListScroll2Selection_5
ListScroll2Selection_4:
  cmp.w      #$FFFF,d0
  beq.s      ListScroll2Selection_1
  move.w     d1,d0
  ext.l      d0
  cmp.l      44(a2),d0
  blt.s      ListScroll2Selection_6
  move.w     62(a2),d2
  ext.l      d2
  add.l      44(a2),d2
  cmp.l      d2,d0
  blt.s      ListScroll2Selection_1
ListScroll2Selection_6:
  move.w     d1,d0
  ext.l      d0
  move.l     d0,44(a2)
  move.w     d1,d2
  add.w      62(a2),d2
  ext.l      d2
  cmp.l      58(a2),d2
  ble.s      ListScroll2Selection_7
  move.l     58(a2),d1
  move.w     62(a2),d3
  ext.l      d3
  sub.l      d3,d1
  move.l     d1,44(a2)
ListScroll2Selection_7:
  move.l     44(a2),d0
  movea.l    a2,a0
  jsr        ~_404(pc)
ListScroll2Selection_1:
  movea.l    (a7)+,a2
  move.l     (a7)+,d3
  rts

ListPgDown:
  move.l     a2,-(a7)
  movea.l    a0,a2
  move.w     62(a2),d0
  ext.l      d0
  jsr        ListVScroll(pc)
  movea.l    (a7)+,a2
  rts

ListPgUp:
  move.l     a2,-(a7)
  movea.l    a0,a2
  move.w     62(a2),d0
  neg.w      d0
  ext.l      d0
  jsr        ListVScroll(pc)
  movea.l    (a7)+,a2
  rts

ListPgRight:
  move.l     a2,-(a7)
  movea.l    a0,a2
  move.w     14(a2),d0
  jsr        ListHScroll(pc)
  movea.l    (a7)+,a2
  rts

ListPgLeft:
  move.l     a2,-(a7)
  movea.l    a0,a2
  move.w     14(a2),d0
  neg.w      d0
  jsr        ListHScroll(pc)
  movea.l    (a7)+,a2
  rts

ListLnRight:
  move.l     a2,-(a7)
  movea.l    a0,a2
  move.w     34(a2),d0
  jsr        ListHScroll(pc)
  movea.l    (a7)+,a2
  rts

ListLnLeft:
  move.l     a2,-(a7)
  movea.l    a0,a2
  move.w     34(a2),d0
  neg.w      d0
  jsr        ListHScroll(pc)
  movea.l    (a7)+,a2
  rts

ListVSlide:
  move.l     d3,-(a7)
  move.l     a2,-(a7)
  movea.l    a0,a2
  move.w     d0,d3
  ext.l      d0
  movea.l    64(a2),a1
  move.l     4(a1),d1
  jsr        _lmul
  move.l     d0,d3
  move.l     #$000003E8,d1
  jsr        _ldiv
  move.l     d0,d3
  sub.l      44(a2),d0
  movea.l    a2,a0
  jsr        ListVScroll(pc)
  movea.l    (a7)+,a2
  move.l     (a7)+,d3
  rts

ListHSlide:
  move.l     d3,-(a7)
  move.l     a2,-(a7)
  movea.l    a0,a2
  move.w     d0,d3
  ext.l      d0
  movea.l    68(a2),a1
  move.l     4(a1),d1
  jsr        _lmul
  move.l     d0,d3
  move.l     #$000003E8,d1
  jsr        _ldiv
  move.l     d0,d3
  move.w     d3,d0
  sub.w      36(a2),d0
  movea.l    a2,a0
  jsr        ListHScroll(pc)
  movea.l    (a7)+,a2
  move.l     (a7)+,d3
  rts

~_419:
  movem.l    d3-d6/a2-a3/a5,-(a7)
  lea.l      -38(a7),a7
  movea.l    a0,a2
  move.w     d0,d6
  move.w     d1,d4
  move.w     d2,d5
  movea.l    a1,a5
  move.w     70(a7),d3
  movea.l    6(a2),a3
  addq.w     #4,a3
  lea.l      (a7),a1
  movea.l    a5,a0
  jsr        RectGRECT2VDI
  lea.l      DialWk,a5
  lea.l      (a7),a0
  moveq.l    #1,d1
  move.w     (a5),d0
  jsr        vs_clip
  move.l     a2,d0
  beq        ~_419_1
  moveq.l    #1,d1
  and.w      d3,d1
  beq.s      ~_419_2
  move.w     (a5),d0
  moveq.l    #2,d1
  jsr        vswr_mode
  lea.l      16(a7),a1
  lea.l      16(a7),a0
  moveq.l    #5,d2
  clr.w      d1
  move.w     (a5),d0
  jsr        vst_alignment
  clr.w      d1
  move.w     (a5),d0
  jsr        vst_effects
  movea.l    a3,a0
  move.w     d4,d2
  move.w     d6,d1
  sub.w      d5,d1
  add.w      HandXSize,d1
  move.w     (a5),d0
  jsr        v_gtext
~_419_2:
  move.w     4(a2),d0
  moveq.l    #15,d1
  lsr.w      d1,d0
  and.w      #$0001,d0
  bne.s      ~_419_3
  tst.w      d3
  bne.s      ~_419_4
  moveq.l    #1,d2
  bra.s      ~_419_5
~_419_4:
  clr.w      d2
~_419_5:
  and.w      #$0001,d2
  beq.s      ~_419_1
~_419_3:
  clr.l      18(a7)
  moveq.l    #8,d0
  lea.l      (a7),a1
  lea.l      8(a7),a0
  jsr        memcpy
  pea.l      18(a7)
  lea.l      22(a7),a1
  lea.l      4(a7),a0
  moveq.l    #10,d1
  move.w     (a5),d0
  jsr        vro_cpyfm
  addq.w     #4,a7
~_419_1:
  lea.l      (a7),a0
  clr.w      d1
  move.w     (a5),d0
  jsr        vs_clip
  lea.l      38(a7),a7
  movem.l    (a7)+,d3-d6/a2-a3/a5
  rts

~_420:
  movem.l    d3-d6/a2-a4,-(a7)
  lea.l      -46(a7),a7
  movea.l    a0,a4
  move.w     d0,d6
  move.w     d1,d4
  move.w     d2,d5
  movea.l    a1,a3
  move.w     78(a7),d3
  lea.l      8(a7),a2
  movea.l    a2,a1
  movea.l    a3,a0
  jsr        RectGRECT2VDI
  lea.l      DialWk,a3
  movea.l    a2,a0
  moveq.l    #1,d1
  move.w     (a3),d0
  jsr        vs_clip
  move.l     a4,d0
  beq        ~_420_1
  moveq.l    #1,d1
  and.w      d3,d1
  beq.s      ~_420_2
  move.w     8(a4),-(a7)
  lea.l      ~_423,a1
  lea.l      2(a7),a0
  jsr        sprintf
  addq.w     #2,a7
  moveq.l    #2,d1
  move.w     (a3),d0
  jsr        vswr_mode
  lea.l      24(a7),a1
  lea.l      24(a7),a0
  moveq.l    #5,d2
  clr.w      d1
  move.w     (a3),d0
  jsr        vst_alignment
  clr.w      d1
  move.w     (a3),d0
  jsr        vst_effects
  lea.l      (a7),a0
  move.w     d4,d2
  move.w     d6,d1
  sub.w      d5,d1
  add.w      HandXSize,d1
  move.w     (a3),d0
  jsr        v_gtext
~_420_2:
  move.w     4(a4),d0
  moveq.l    #15,d1
  lsr.w      d1,d0
  and.w      #$0001,d0
  bne.s      ~_420_3
  tst.w      d3
  bne.s      ~_420_4
  moveq.l    #1,d2
  bra.s      ~_420_5
~_420_4:
  clr.w      d2
~_420_5:
  and.w      #$0001,d2
  beq.s      ~_420_1
~_420_3:
  clr.l      26(a7)
  moveq.l    #8,d0
  movea.l    a2,a1
  lea.l      8(a2),a0
  jsr        memcpy
  pea.l      26(a7)
  lea.l      30(a7),a1
  movea.l    a2,a0
  moveq.l    #10,d1
  move.w     (a3),d0
  jsr        vro_cpyfm
  addq.w     #4,a7
~_420_1:
  movea.l    a2,a0
  clr.w      d1
  move.w     (a3),d0
  jsr        vs_clip
  lea.l      46(a7),a7
  movem.l    (a7)+,d3-d6/a2-a4
  rts

~_421:
  movem.l    d3-d6/a2-a3/a5,-(a7)
  lea.l      -22(a7),a7
  movea.l    a0,a3
  move.w     d0,d5
  move.w     d1,d4
  clr.w      d3
  move.w     d1,d0
  ext.l      d0
  moveq.l    #2,d1
  jsr        calloc
  movea.l    a0,a2
  move.l     a2,d0
  beq        ~_421_1
  lea.l      2(a7),a0
  move.w     (a3),d0
  jsr        vqt_attributes
  move.w     d5,d1
  move.w     (a3),d0
  jsr        vst_font
  moveq.l    #-1,d6
  add.w      d4,d6
  move.w     d5,d0
  movea.l    a3,a0
  jsr        FontIsFSM
  tst.w      d0
  bne.s      ~_421_2
  bra.s      ~_421_3
~_421_6:
  pea.l      (a7)
  pea.l      4(a7)
  pea.l      8(a7)
  lea.l      12(a7),a1
  move.w     d6,d2
  move.w     d5,d1
  move.w     (a3),d0
  movea.l    a3,a0
  jsr        FontSetPoint
  lea.l      12(a7),a7
  move.w     d0,d6
  tst.w      d0
  ble.s      ~_421_4
  ext.l      d0
  add.l      d0,d0
  move.w     0(a2,d0.l),d1
  bne.s      ~_421_5
  move.w     #$0001,0(a2,d0.l)
~_421_4:
  subq.w     #1,d6
~_421_3:
  tst.w      d6
  bgt.s      ~_421_6
  bra.s      ~_421_5
~_421_2:
  moveq.l    #1,d0
  move.w     d0,54(a2)
  move.w     d0,48(a2)
  move.w     d0,40(a2)
  move.w     d0,36(a2)
  move.w     d0,28(a2)
  move.w     d0,24(a2)
  move.w     d0,20(a2)
  move.w     d0,18(a2)
~_421_5:
  moveq.l    #10,d1
  move.w     d4,d0
  ext.l      d0
  jsr        calloc
  movea.l    a0,a5
  move.l     a5,d0
  bne.s      ~_421_7
  movea.l    a2,a0
  jsr        free
~_421_1:
  suba.l     a0,a0
  bra        ~_421_8
~_421_7:
  clr.w      d3
  move.w     d3,d6
  bra.s      ~_421_9
~_421_12:
  move.w     d6,d0
  ext.l      d0
  add.l      d0,d0
  move.w     0(a2,d0.l),d1
  beq.s      ~_421_10
  move.w     d6,d2
  ext.l      d2
  move.w     d3,d0
  ext.l      d0
  move.l     d0,d5
  lsl.l      #2,d5
  add.l      d0,d5
  add.l      d5,d5
  move.l     d2,6(a5,d5.l)
  andi.w     #$7FFF,4(a5,d5.l)
  clr.l      0(a5,d5.l)
  tst.w      d3
  beq.s      ~_421_11
  lea.l      0(a5,d5.l),a0
  moveq.l    #-1,d2
  add.w      d3,d2
  ext.l      d2
  move.l     d2,d1
  lsl.l      #2,d1
  add.l      d2,d1
  add.l      d1,d1
  move.l     a0,0(a5,d1.l)
~_421_11:
  addq.w     #1,d3
~_421_10:
  addq.w     #1,d6
~_421_9:
  cmp.w      d6,d4
  bgt.s      ~_421_12
  movea.l    a2,a0
  jsr        free
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #2,d0
  add.l      d1,d0
  add.l      d0,d0
  movea.l    a5,a0
  jsr        realloc
  movea.l    a0,a5
  move.w     2(a7),d1
  move.w     (a3),d0
  jsr        vst_font
  pea.l      (a7)
  pea.l      4(a7)
  pea.l      8(a7)
  lea.l      12(a7),a1
  move.w     28(a7),d2
  move.w     14(a7),d1
  move.w     (a3),d0
  movea.l    a3,a0
  jsr        FontSetPoint
  lea.l      12(a7),a7
  movea.l    a5,a0
~_421_8:
  lea.l      22(a7),a7
  movem.l    (a7)+,d3-d6/a2-a3/a5
  rts

~_422:
  movem.l    d3-d7/a2-a3,-(a7)
  subq.w     #2,a7
  movea.l    a0,a2
  move.w     d0,(a7)
  move.w     d1,d5
  clr.w      d3
  move.w     d3,d4
  bra.s      ~_422_1
~_422_4:
  tst.w      d5
  bne.s      ~_422_2
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #3,d0
  add.l      d1,d0
  add.l      d0,d0
  add.l      d1,d0
  add.l      d0,d0
  move.w     2(a2,d0.l),d2
  moveq.l    #15,d0
  lsr.w      d0,d2
  and.w      #$0001,d2
  bne.s      ~_422_3
~_422_2:
  addq.w     #1,d4
~_422_3:
  addq.w     #1,d3
~_422_1:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #3,d0
  add.l      d1,d0
  add.l      d0,d0
  add.l      d1,d0
  add.l      d0,d0
  cmpi.w     #$FFFF,0(a2,d0.l)
  bne.s      ~_422_4
  move.w     d3,d6
  move.w     d4,d0
  ext.l      d0
  moveq.l    #10,d1
  jsr        calloc
  movea.l    a0,a3
  move.l     a3,d0
  bne.s      ~_422_5
  suba.l     a0,a0
  bra        ~_422_6
~_422_5:
  clr.w      d3
  move.w     d3,d7
  bra        ~_422_7
~_422_11:
  tst.w      d5
  bne.s      ~_422_8
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #3,d0
  add.l      d1,d0
  add.l      d0,d0
  add.l      d1,d0
  add.l      d0,d0
  move.w     2(a2,d0.l),d2
  moveq.l    #15,d0
  lsr.w      d0,d2
  and.w      #$0001,d2
  bne        ~_422_9
~_422_8:
  move.w     d7,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #2,d0
  add.l      d1,d0
  add.l      d0,d0
  andi.w     #$7FFF,4(a3,d0.l)
  move.w     d3,d0
  ext.l      d0
  move.l     d0,d2
  lsl.l      #3,d2
  add.l      d0,d2
  add.l      d2,d2
  add.l      d0,d2
  add.l      d2,d2
  move.w     0(a2,d2.l),d1
  cmp.w      (a7),d1
  bne.s      ~_422_10
  move.w     d7,d2
  ext.l      d2
  move.l     d2,d1
  lsl.l      #2,d1
  add.l      d2,d1
  add.l      d1,d1
  andi.w     #$7FFF,4(a3,d1.l)
  ori.w      #$8000,4(a3,d1.l)
~_422_10:
  move.w     d3,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #3,d0
  add.l      d1,d0
  add.l      d0,d0
  add.l      d1,d0
  add.l      d0,d0
  lea.l      0(a2,d0.l),a0
  move.w     d7,d0
  ext.l      d0
  move.l     d0,d2
  lsl.l      #2,d2
  add.l      d0,d2
  add.l      d2,d2
  move.l     a0,6(a3,d2.l)
  moveq.l    #1,d2
  add.w      d7,d2
  ext.l      d2
  move.l     d2,d1
  lsl.l      #2,d1
  add.l      d2,d1
  add.l      d1,d1
  lea.l      0(a3,d1.l),a1
  move.w     d7,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #2,d0
  add.l      d1,d0
  add.l      d0,d0
  move.l     a1,0(a3,d0.l)
  addq.w     #1,d7
~_422_9:
  addq.w     #1,d3
~_422_7:
  cmp.w      d3,d6
  bgt        ~_422_11
  moveq.l    #-1,d1
  add.w      d4,d1
  ext.l      d1
  move.l     d1,d0
  lsl.l      #2,d0
  add.l      d1,d0
  add.l      d0,d0
  clr.l      0(a3,d0.l)
  movea.l    a3,a0
~_422_6:
  addq.w     #2,a7
  movem.l    (a7)+,d3-d7/a2-a3
  rts

FontShowFont:
  movem.l    d3-d5/a2-a5,-(a7)
  lea.l      -62(a7),a7
  movea.l    a0,a3
  movea.l    a1,a5
  move.w     d0,d5
  move.w     d1,d3
  move.w     d2,d4
  clr.l      42(a7)
  lea.l      22(a7),a2
  movea.l    a2,a0
  move.w     (a3),d0
  jsr        vqt_attributes
  move.w     d3,d1
  move.w     (a3),d0
  jsr        vst_font
  lea.l      20(a7),a4
  pea.l      (a4)
  pea.l      (a4)
  pea.l      (a4)
  movea.l    a4,a1
  move.w     d4,d2
  move.w     d3,d1
  move.w     (a3),d0
  movea.l    a3,a0
  jsr        FontSetPoint
  lea.l      12(a7),a7
  movea.l    a4,a1
  movea.l    a4,a0
  moveq.l    #3,d2
  clr.w      d1
  move.w     (a3),d0
  jsr        vst_alignment
  pea.l      16(a7)
  lea.l      22(a7),a1
  move.w     d5,d0
  movea.l    a5,a0
  jsr        ObjcOffset
  addq.w     #4,a7
  move.w     d5,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  move.w     22(a5,d0.l),-(a7)
  lea.l      2(a7),a0
  move.w     20(a5,d0.l),d2
  move.w     20(a7),d0
  move.w     18(a7),d1
  jsr        RectAES2VDI
  addq.w     #2,a7
  lea.l      (a7),a0
  moveq.l    #1,d1
  move.w     (a3),d0
  jsr        vs_clip
  suba.l     a0,a0
  move.w     #$0100,d0
  jsr        GrafMouse
  moveq.l    #8,d0
  lea.l      (a7),a1
  lea.l      8(a7),a0
  jsr        memcpy
  pea.l      42(a7)
  lea.l      46(a7),a1
  lea.l      4(a7),a0
  clr.w      d1
  move.w     (a3),d0
  jsr        vro_cpyfm
  addq.w     #4,a7
  clr.w      -(a7)
  clr.w      -(a7)
  clr.w      -(a7)
  movea.l    100(a7),a0
  move.w     22(a7),d2
  move.w     d5,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  add.w      22(a5,d0.l),d2
  subq.w     #1,d2
  move.w     (a3),d0
  move.w     24(a7),d1
  jsr        v_justified
  addq.w     #6,a7
  suba.l     a0,a0
  move.w     #$0101,d0
  jsr        GrafMouse
  lea.l      (a7),a0
  clr.w      d1
  move.w     (a3),d0
  jsr        vs_clip
  move.w     (a2),d1
  move.w     (a3),d0
  jsr        vst_font
  pea.l      (a4)
  pea.l      (a4)
  pea.l      (a4)
  movea.l    a4,a1
  move.w     14(a2),d2
  move.w     (a2),d1
  move.w     (a3),d0
  movea.l    a3,a0
  jsr        FontSetPoint
  lea.l      12(a7),a7
  movea.l    a4,a1
  movea.l    a4,a0
  move.w     8(a2),d2
  move.w     6(a2),d1
  move.w     (a3),d0
  jsr        vst_alignment
  lea.l      62(a7),a7
  movem.l    (a7)+,d3-d5/a2-a5
  rts

FontSelectSize:
  movem.l    d3-d5/a2-a4,-(a7)
  movea.l    a0,a2
  movea.l    a1,a4
  move.w     d0,d5
  movea.l    48(a2),a3
  move.w     #$03E8,d3
  moveq.l    #0,d4
  bra.s      FontSelectSize_1
FontSelectSize_3:
  move.w     (a4),d0
  sub.w      8(a3),d0
  jsr        abs
  cmp.w      d0,d3
  ble.s      FontSelectSize_2
  move.w     d0,d3
FontSelectSize_2:
  movea.l    (a3),a3
FontSelectSize_1:
  move.l     a3,d0
  bne.s      FontSelectSize_3
  movea.l    48(a2),a3
  bra.s      FontSelectSize_4
FontSelectSize_7:
  move.w     (a4),d0
  sub.w      8(a3),d0
  jsr        abs
  cmp.w      d0,d3
  bne.s      FontSelectSize_5
  clr.w      d3
  andi.w     #$7FFF,4(a3)
  ori.w      #$8000,4(a3)
  move.w     8(a3),(a4)
  tst.w      d5
  beq.s      FontSelectSize_6
  move.l     d4,d0
  movea.l    a2,a0
  jsr        ListUpdateEntry
  move.l     d4,d0
  sub.l      44(a2),d0
  movea.l    a2,a0
  jsr        ListVScroll
  bra.s      FontSelectSize_6
FontSelectSize_5:
  move.w     4(a3),d0
  moveq.l    #15,d1
  lsr.w      d1,d0
  and.w      #$0001,d0
  beq.s      FontSelectSize_6
  andi.w     #$7FFF,4(a3)
  tst.w      d5
  beq.s      FontSelectSize_6
  move.l     d4,d0
  movea.l    a2,a0
  jsr        ListUpdateEntry
FontSelectSize_6:
  movea.l    (a3),a3
  addq.l     #1,d4
FontSelectSize_4:
  move.l     a3,d0
  bne.s      FontSelectSize_7
  movem.l    (a7)+,d3-d5/a2-a4
  rts

FontSelInit:
  movem.l    d3-d7/a2-a6,-(a7)
  subq.w     #2,a7
  movea.l    a0,a3
  movea.l    a1,a2
  movea.l    46(a7),a4
  move.w     d0,d4
  move.w     d1,d5
  move.w     d2,d6
  move.w     50(a7),d7
  movea.l    60(a7),a5
  movea.l    64(a7),a6
  moveq.l    #33,d3
  muls.w     HandXSize,d3
  move.l     a1,158(a3)
  move.l     54(a7),162(a3)
  move.l     a4,144(a3)
  move.w     d0,148(a3)
  move.w     d1,150(a3)
  move.w     d2,152(a3)
  move.w     d7,154(a3)
  move.w     52(a7),156(a3)
  movea.l    158(a3),a0
  move.l     8(a0),d0
  bne.s      FontSelInit_1
  clr.w      d0
  bra        FontSelInit_2
FontSelInit_1:
  moveq.l    #1,d0
  move.w     d0,-(a7)
  clr.l      -(a7)
  move.w     64(a7),d1
  move.w     (a5),d0
  movea.l    158(a3),a0
  movea.l    8(a0),a0
  jsr        ~_422(pc)
  move.l     a0,-(a7)
  pea.l      ~_419(pc)
  move.w     d4,d1
  ext.l      d1
  move.l     d1,d0
  add.l      d0,d0
  add.l      d1,d0
  lsl.l      #3,d0
  cmp.w      20(a4,d0.l),d3
  bne.s      FontSelInit_3
  clr.w      d2
  bra.s      FontSelInit_4
FontSelInit_3:
  move.w     d3,d2
FontSelInit_4:
  move.w     d5,d1
  move.w     d4,d0
  movea.l    a4,a1
  movea.l    a3,a0
  jsr        ListStdInit
  lea.l      14(a7),a7
  move.w     #$0008,34(a3)
  movea.l    a3,a0
  jsr        ListInit
  movea.l    a3,a0
  jsr        ListScroll2Selection
  moveq.l    #1,d0
  move.w     d0,-(a7)
  clr.l      -(a7)
  moveq.l    #50,d1
  move.w     (a5),d0
  movea.l    a2,a0
  jsr        ~_421(pc)
  move.l     a0,-(a7)
  pea.l      ~_420(pc)
  move.w     d7,d1
  move.w     d6,d0
  movea.l    a4,a1
  lea.l      72(a3),a0
  clr.w      d2
  jsr        ListStdInit
  lea.l      14(a7),a7
  move.w     (a6),(a7)
  clr.w      d0
  lea.l      (a7),a1
  lea.l      72(a3),a0
  jsr        FontSelectSize(pc)
  move.w     (a5),d0
  movea.l    a2,a0
  jsr        FontIsFSM
  tst.w      d0
  bne.s      FontSelInit_5
  move.w     (a7),(a6)
FontSelInit_5:
  lea.l      72(a3),a0
  jsr        ListInit
  lea.l      72(a3),a0
  jsr        ListScroll2Selection
  moveq.l    #1,d0
FontSelInit_2:
  addq.w     #2,a7
  movem.l    (a7)+,d3-d7/a2-a6
  rts

FontClFont:
  movem.l    d3/a2-a4,-(a7)
  subq.w     #2,a7
  movea.l    a0,a3
  move.w     d0,d3
  movea.l    a1,a4
  movea.l    22(a7),a2
  move.w     (a2),(a7)
  jsr        ListClick
  move.w     d0,d3
  tst.w      d0
  blt        FontClFont_1
  ext.l      d0
  movea.l    48(a3),a0
  jsr        ListIndex2List
  movea.l    6(a0),a1
  move.w     (a1),d3
  cmp.w      (a4),d3
  beq        FontClFont_1
  move.w     d3,(a4)
  movea.l    120(a3),a0
  jsr        free
  lea.l      72(a3),a0
  jsr        ListExit
  moveq.l    #1,d0
  move.w     d0,-(a7)
  clr.l      -(a7)
  moveq.l    #50,d1
  move.w     (a4),d0
  movea.l    158(a3),a0
  jsr        ~_421(pc)
  move.l     a0,-(a7)
  pea.l      ~_420(pc)
  move.w     154(a3),d1
  move.w     152(a3),d0
  movea.l    144(a3),a1
  lea.l      72(a3),a0
  clr.w      d2
  jsr        ListStdInit
  lea.l      14(a7),a7
  lea.l      72(a3),a0
  jsr        ListInit
  clr.w      d0
  lea.l      (a7),a1
  lea.l      72(a3),a0
  jsr        FontSelectSize(pc)
  move.w     (a4),d0
  movea.l    158(a3),a0
  jsr        FontIsFSM
  tst.w      d0
  bne.s      FontClFont_2
  move.w     (a7),(a2)
FontClFont_2:
  lea.l      72(a3),a0
  jsr        ListScroll2Selection
  lea.l      72(a3),a0
  jsr        ListDraw
  move.l     162(a3),-(a7)
  move.w     (a2),d2
  move.w     (a4),d1
  move.w     156(a3),d0
  movea.l    144(a3),a1
  movea.l    158(a3),a0
  jsr        FontShowFont(pc)
  addq.w     #4,a7
FontClFont_1:
  move.w     d3,d0
  addq.w     #2,a7
  movem.l    (a7)+,d3/a2-a4
  rts

FontClSize:
  movem.l    d3/a2-a4,-(a7)
  movea.l    a0,a2
  move.w     d0,d3
  movea.l    a1,a4
  movea.l    20(a7),a3
  lea.l      72(a2),a0
  jsr        ListClick
  move.w     d0,d3
  tst.w      d0
  blt.s      FontClSize_1
  ext.l      d0
  move.l     d0,d1
  lsl.l      #2,d1
  add.l      d0,d1
  add.l      d1,d1
  movea.l    120(a2),a0
  move.w     8(a0,d1.l),(a3)
  move.l     162(a2),-(a7)
  move.w     (a3),d2
  move.w     (a4),d1
  move.w     156(a2),d0
  movea.l    144(a2),a1
  movea.l    158(a2),a0
  jsr        FontShowFont(pc)
  addq.w     #4,a7
FontClSize_1:
  move.w     d3,d0
  movem.l    (a7)+,d3/a2-a4
  rts

FontSelDraw:
  movem.l    d3-d4/a2,-(a7)
  movea.l    a0,a2
  move.w     d0,d4
  move.w     d1,d3
  jsr        ListDraw
  lea.l      72(a2),a0
  jsr        ListDraw
  move.l     162(a2),-(a7)
  move.w     d3,d2
  move.w     d4,d1
  move.w     156(a2),d0
  movea.l    144(a2),a1
  movea.l    158(a2),a0
  jsr        FontShowFont(pc)
  addq.w     #4,a7
  movem.l    (a7)+,d3-d4/a2
  rts

FontSelExit:
  move.l     a2,-(a7)
  movea.l    a0,a2
  movea.l    48(a2),a0
  jsr        free
  movea.l    120(a2),a0
  jsr        free
  movea.l    a2,a0
  jsr        ListExit
  lea.l      72(a2),a0
  jsr        ListExit
  movea.l    (a7)+,a2
  rts

	.data
[0000711a]                           dc.b '#:\CLIPBRD\',0
[00007126]                           dc.w $5c00
[00007128]                           dc.b 'CLIPBRD',0
[00007130]                           dc.b 'SCRAP.',0
[00007137]                           dc.b $2a
[00007138]                           dc.b $00
[00007139]                           dc.b $00
~_238:
[0000713a]                           dc.b $00
[0000713b]                           dc.b $00
[0000713c]                           dc.b $00
[0000713d]                           dc.b $00
[0000713e]                           dc.b $00
[0000713f]                           dc.b $00
[00007140]                           dc.b $00
[00007141]                           dc.b $00
~_240:
[00007142]                           dc.b $00
[00007143]                           dc.b $00
~_241:
[00007144]                           dc.b $00
[00007145]                           dc.b $00
~_244:
[00007146]                           dc.b $00
[00007147]                           dc.b $01
AlertTree:
[00007148]                           dc.w $ffff
[0000714a]                           dc.b $00
[0000714b]                           dc.b $01
[0000714c]                           dc.b $00
[0000714d]                           dc.b $02
[0000714e]                           dc.b $00
[0000714f]                           dc.b $14
[00007150]                           dc.b $00
[00007151]                           dc.b $00
[00007152]                           dc.b $00
[00007153]                           dc.b $10
[00007154]                           dc.b $00
[00007155]                           dc.b $02
[00007156]                           dc.w $1100
[00007158]                           dc.b $00
[00007159]                           dc.b $00
[0000715a]                           dc.b $00
[0000715b]                           dc.b $00
[0000715c]                           dc.b $00
[0000715d]                           dc.b $37
[0000715e]                           dc.b $00
[0000715f]                           dc.b $0c
[00007160]                           dc.b $00
[00007161]                           dc.b $02
[00007162]                           dc.w $ffff
[00007164]                           dc.w $ffff
[00007166]                           dc.b $00
[00007167]                           dc.b $17
[00007168]                           dc.b $00
[00007169]                           dc.b $00
[0000716a]                           dc.b $00
[0000716b]                           dc.b $00
[0000716c]                           dc.b $00
[0000716d]                           dc.b $00
[0000716e]                           dc.b $00
[0000716f]                           dc.b $00
[00007170]                           dc.b $00
[00007171]                           dc.b $01
[00007172]                           dc.b $00
[00007173]                           dc.b $01
[00007174]                           dc.b $00
[00007175]                           dc.b $00
[00007176]                           dc.b $00
[00007177]                           dc.b $00
[00007178]                           dc.b $00
[00007179]                           dc.b $00
[0000717a]                           dc.w $ffff
[0000717c]                           dc.w $ffff
[0000717e]                           dc.w $1119
[00007180]                           dc.b $00
[00007181]                           dc.b $40
[00007182]                           dc.b $00
[00007183]                           dc.b $12
[00007184]                           dc.b $00
[00007185]                           dc.b $fe
[00007186]                           dc.w $1101
[00007188]                           dc.b $00
[00007189]                           dc.b $00
[0000718a]                           dc.b $00
[0000718b]                           dc.b $00
[0000718c]                           dc.b $00
[0000718d]                           dc.b $01
[0000718e]                           dc.b $00
[0000718f]                           dc.b $01
[00007190]                           dc.b $00
[00007191]                           dc.b $00
[00007192]                           dc.w $ffff
[00007194]                           dc.w $ffff
[00007196]                           dc.w $121a
[00007198]                           dc.b $00
[00007199]                           dc.b $05
[0000719a]                           dc.b $00
[0000719b]                           dc.b $00
[0000719c]                           dc.b $00
[0000719d]                           dc.b $00
[0000719e]                           dc.b $00
[0000719f]                           dc.b $00
[000071a0]                           dc.b $00
[000071a1]                           dc.b $00
[000071a2]                           dc.b $00
[000071a3]                           dc.b $00
[000071a4]                           dc.b $00
[000071a5]                           dc.b $01
[000071a6]                           dc.b $00
[000071a7]                           dc.b $01
[000071a8]                           dc.b $00
[000071a9]                           dc.b $00
[000071aa]                           dc.w $ffff
[000071ac]                           dc.w $ffff
[000071ae]                           dc.w $121a
[000071b0]                           dc.b $00
[000071b1]                           dc.b $05
[000071b2]                           dc.b $00
[000071b3]                           dc.b $00
[000071b4]                           dc.b $00
[000071b5]                           dc.b $00
[000071b6]                           dc.b $00
[000071b7]                           dc.b $00
[000071b8]                           dc.b $00
[000071b9]                           dc.b $00
[000071ba]                           dc.b $00
[000071bb]                           dc.b $00
[000071bc]                           dc.b $00
[000071bd]                           dc.b $00
[000071be]                           dc.b $00
[000071bf]                           dc.b $00
[000071c0]                           dc.b $00
[000071c1]                           dc.b $00
[000071c2]                           dc.w $ffff
[000071c4]                           dc.w $ffff
[000071c6]                           dc.w $121a
[000071c8]                           dc.b $00
[000071c9]                           dc.b $05
[000071ca]                           dc.b $00
[000071cb]                           dc.b $00
[000071cc]                           dc.b $00
[000071cd]                           dc.b $00
[000071ce]                           dc.b $00
[000071cf]                           dc.b $00
[000071d0]                           dc.b $00
[000071d1]                           dc.b $00
[000071d2]                           dc.b $00
[000071d3]                           dc.b $00
[000071d4]                           dc.b $00
[000071d5]                           dc.b $00
[000071d6]                           dc.b $00
[000071d7]                           dc.b $00
[000071d8]                           dc.b $00
[000071d9]                           dc.b $00
[000071da]                           dc.w $ffff
[000071dc]                           dc.w $ffff
[000071de]                           dc.w $121a
[000071e0]                           dc.b $00
[000071e1]                           dc.b $05
[000071e2]                           dc.b $00
[000071e3]                           dc.b $00
[000071e4]                           dc.b $00
[000071e5]                           dc.b $00
[000071e6]                           dc.b $00
[000071e7]                           dc.b $00
[000071e8]                           dc.b $00
[000071e9]                           dc.b $00
[000071ea]                           dc.b $00
[000071eb]                           dc.b $00
[000071ec]                           dc.b $00
[000071ed]                           dc.b $00
[000071ee]                           dc.b $00
[000071ef]                           dc.b $00
[000071f0]                           dc.b $00
[000071f1]                           dc.b $00
[000071f2]                           dc.w $ffff
[000071f4]                           dc.w $ffff
[000071f6]                           dc.w $121a
[000071f8]                           dc.b $00
[000071f9]                           dc.b $05
[000071fa]                           dc.b $00
[000071fb]                           dc.b $00
[000071fc]                           dc.b $00
[000071fd]                           dc.b $00
[000071fe]                           dc.b $00
[000071ff]                           dc.b $00
[00007200]                           dc.b $00
[00007201]                           dc.b $00
[00007202]                           dc.b $00
[00007203]                           dc.b $00
[00007204]                           dc.b $00
[00007205]                           dc.b $00
[00007206]                           dc.b $00
[00007207]                           dc.b $00
[00007208]                           dc.b $00
[00007209]                           dc.b $7c
[0000720a]                           dc.b $00
[0000720b]                           dc.b $00
DialWk:
[0000720c]                           dc.b $00
[0000720d]                           dc.b $00
~_257:
[0000720e]                           dc.b $00
[0000720f]                           dc.b $01
[00007210]                           dc.b $00
[00007211]                           dc.b $01
[00007212]                           dc.b $00
[00007213]                           dc.b $01
[00007214]                           dc.b $00
[00007215]                           dc.b $01
[00007216]                           dc.b $00
[00007217]                           dc.b $01
[00007218]                           dc.b $00
[00007219]                           dc.b $01
[0000721a]                           dc.b $00
[0000721b]                           dc.b $01
[0000721c]                           dc.b $00
[0000721d]                           dc.b $01
[0000721e]                           dc.b $00
[0000721f]                           dc.b $01
[00007220]                           dc.b $00
[00007221]                           dc.b $01
[00007222]                           dc.b $00
[00007223]                           dc.b $02
~_258:
[00007224]                           dc.b 'VSCRFLYD'
[0000722c]                           dc.w $0100
[0000722e]                           dc.b $00
[0000722f]                           dc.b $00
[00007230]                           dc.w $013f
[00007232]                           dc.w $0280
[00007234]                           dc.w $0140
~_272:
[00007236]                           dc.w $ffff
~_273:
[00007238]                           dc.b $00
[00007239]                           dc.b $00
[0000723a]                           dc.b $00
[0000723b]                           dc.b $00
~_274:
[0000723c]                           dc.b $00
[0000723d]                           dc.b $00
[0000723e]                           dc.b $00
[0000723f]                           dc.b $00
~_275:
[00007240]                           dc.b $00
[00007241]                           dc.b $00
[00007242]                           dc.b $00
[00007243]                           dc.b $00
[00007244]                           dc.w $2000
~_294:
[00007246]                           dc.b $00
[00007247]                           dc.b $00
[00007248]                           dc.w $03c0
[0000724a]                           dc.w $0c30
[0000724c]                           dc.w $1008
[0000724e]                           dc.w $2004
[00007250]                           dc.w $2004
[00007252]                           dc.w $4002
[00007254]                           dc.w $4002
[00007256]                           dc.w $4002
[00007258]                           dc.w $4002
[0000725a]                           dc.w $2004
[0000725c]                           dc.w $2004
[0000725e]                           dc.w $1008
[00007260]                           dc.w $0c30
[00007262]                           dc.w $03c0
[00007264]                           dc.b $00
[00007265]                           dc.b $00
~_295:
[00007266]                           dc.b $00
[00007267]                           dc.b $00
[00007268]                           dc.w $03c0
[0000726a]                           dc.w $0c30
[0000726c]                           dc.w $1188
[0000726e]                           dc.w $27e4
[00007270]                           dc.w $2ff4
[00007272]                           dc.w $4ff2
[00007274]                           dc.w $5ffa
[00007276]                           dc.w $5ffa
[00007278]                           dc.w $4ff2
[0000727a]                           dc.w $2ff4
[0000727c]                           dc.w $27e4
[0000727e]                           dc.w $1188
[00007280]                           dc.w $0c30
[00007282]                           dc.w $03c0
[00007284]                           dc.b $00
[00007285]                           dc.b $00
~_296:
[00007286]                           dc.b $00
[00007287]                           dc.b $00
[00007288]                           dc.b $00
[00007289]                           dc.b $00
[0000728a]                           dc.b $00
[0000728b]                           dc.b $10
[0000728c]                           dc.b $00
[0000728d]                           dc.b $10
[0000728e]                           dc.b $00
[0000728f]                           dc.b $01
[00007290]                           dc.b $00
[00007291]                           dc.b $00
[00007292]                           dc.b $00
[00007293]                           dc.b $01
[00007294]                           dc.b $00
[00007295]                           dc.b $00
[00007296]                           dc.b $00
[00007297]                           dc.b $00
[00007298]                           dc.b $00
[00007299]                           dc.b $00
~_297:
[0000729a]                           dc.b $00
[0000729b]                           dc.b $00
[0000729c]                           dc.b $00
[0000729d]                           dc.b $00
[0000729e]                           dc.b $00
[0000729f]                           dc.b $10
[000072a0]                           dc.b $00
[000072a1]                           dc.b $10
[000072a2]                           dc.b $00
[000072a3]                           dc.b $01
[000072a4]                           dc.b $00
[000072a5]                           dc.b $00
[000072a6]                           dc.b $00
[000072a7]                           dc.b $01
[000072a8]                           dc.b $00
[000072a9]                           dc.b $00
[000072aa]                           dc.b $00
[000072ab]                           dc.b $00
[000072ac]                           dc.b $00
[000072ad]                           dc.b $00
~_298:
[000072ae]                           dc.w $07e0
[000072b0]                           dc.w $381c
[000072b2]                           dc.w $4002
[000072b4]                           dc.w $8001
[000072b6]                           dc.w $8001
[000072b8]                           dc.w $4002
[000072ba]                           dc.w $381c
[000072bc]                           dc.w $07e0
~_299:
[000072be]                           dc.w $07e0
[000072c0]                           dc.w $381c
[000072c2]                           dc.w $47e2
[000072c4]                           dc.w $bffd
[000072c6]                           dc.w $bffd
[000072c8]                           dc.w $47e2
[000072ca]                           dc.w $381c
[000072cc]                           dc.w $07e0
~_300:
[000072ce]                           dc.b $00
[000072cf]                           dc.b $00
[000072d0]                           dc.b $00
[000072d1]                           dc.b $00
[000072d2]                           dc.b $00
[000072d3]                           dc.b $10
[000072d4]                           dc.b $00
[000072d5]                           dc.b $08
[000072d6]                           dc.b $00
[000072d7]                           dc.b $01
[000072d8]                           dc.b $00
[000072d9]                           dc.b $00
[000072da]                           dc.b $00
[000072db]                           dc.b $01
[000072dc]                           dc.b $00
[000072dd]                           dc.b $00
[000072de]                           dc.b $00
[000072df]                           dc.b $00
[000072e0]                           dc.b $00
[000072e1]                           dc.b $00
~_301:
[000072e2]                           dc.b $00
[000072e3]                           dc.b $00
[000072e4]                           dc.b $00
[000072e5]                           dc.b $00
[000072e6]                           dc.b $00
[000072e7]                           dc.b $10
[000072e8]                           dc.b $00
[000072e9]                           dc.b $08
[000072ea]                           dc.b $00
[000072eb]                           dc.b $01
[000072ec]                           dc.b $00
[000072ed]                           dc.b $00
[000072ee]                           dc.b $00
[000072ef]                           dc.b $01
[000072f0]                           dc.b $00
[000072f1]                           dc.b $00
[000072f2]                           dc.b $00
[000072f3]                           dc.b $00
[000072f4]                           dc.b $00
[000072f5]                           dc.b $00
~_302:
[000072f6]                           dc.b $00
[000072f7]                           dc.b $00
[000072f8]                           dc.b $00
[000072f9]                           dc.b $00
[000072fa]                           dc.w $13c0
[000072fc]                           dc.w $1c30
[000072fe]                           dc.w $1c08
[00007300]                           dc.b $00
[00007301]                           dc.b $08
[00007302]                           dc.w $2004
[00007304]                           dc.w $2004
[00007306]                           dc.w $2004
[00007308]                           dc.w $2004
[0000730a]                           dc.w $1000
[0000730c]                           dc.w $1038
[0000730e]                           dc.w $0c38
[00007310]                           dc.w $03c8
[00007312]                           dc.b $00
[00007313]                           dc.b $00
[00007314]                           dc.b $00
[00007315]                           dc.b $00
~_303:
[00007316]                           dc.w $27e0
[00007318]                           dc.w $381c
[0000731a]                           dc.w $3000
[0000731c]                           dc.b $00
[0000731d]                           dc.b $00
[0000731e]                           dc.b $00
[0000731f]                           dc.b $00
[00007320]                           dc.b $00
[00007321]                           dc.b $0c
[00007322]                           dc.w $381c
[00007324]                           dc.w $07e4
~_304:
[00007326]                           dc.b $00
[00007327]                           dc.b $00
[00007328]                           dc.b $00
[00007329]                           dc.b $00
[0000732a]                           dc.b $00
[0000732b]                           dc.b $10
[0000732c]                           dc.b $00
[0000732d]                           dc.b $10
[0000732e]                           dc.b $00
[0000732f]                           dc.b $01
[00007330]                           dc.b $00
[00007331]                           dc.b $00
[00007332]                           dc.b $00
[00007333]                           dc.b $01
[00007334]                           dc.b $00
[00007335]                           dc.b $00
[00007336]                           dc.b $00
[00007337]                           dc.b $00
[00007338]                           dc.b $00
[00007339]                           dc.b $00
~_305:
[0000733a]                           dc.b $00
[0000733b]                           dc.b $00
[0000733c]                           dc.b $00
[0000733d]                           dc.b $00
[0000733e]                           dc.b $00
[0000733f]                           dc.b $10
[00007340]                           dc.b $00
[00007341]                           dc.b $08
[00007342]                           dc.b $00
[00007343]                           dc.b $01
[00007344]                           dc.b $00
[00007345]                           dc.b $00
[00007346]                           dc.b $00
[00007347]                           dc.b $01
[00007348]                           dc.b $00
[00007349]                           dc.b $00
[0000734a]                           dc.b $00
[0000734b]                           dc.b $00
[0000734c]                           dc.b $00
[0000734d]                           dc.b $00
~_306:
[0000734e]                           dc.b $00
[0000734f]                           dc.b $00
[00007350]                           dc.b $00
[00007351]                           dc.b $00
[00007352]                           dc.b $00
[00007353]                           dc.b $00
[00007354]                           dc.b $00
[00007355]                           dc.b $00
[00007356]                           dc.b $00
[00007357]                           dc.b $08
[00007358]                           dc.b $00
[00007359]                           dc.b $10
[0000735a]                           dc.b $00
[0000735b]                           dc.b $00
[0000735c]                           dc.b $00
[0000735d]                           dc.b $00
[0000735e]                           dc.b $00
[0000735f]                           dc.b $00
[00007360]                           dc.b $00
[00007361]                           dc.b $00
[00007362]                           dc.b $00
[00007363]                           dc.b $08
[00007364]                           dc.b $00
[00007365]                           dc.b $08
~_307:
[00007366]                           dc.b $00
[00007367]                           dc.b $00
[00007368]                           dc.b $00
[00007369]                           dc.b $00
[0000736a]                           dc.b $00
[0000736b]                           dc.b $00
[0000736c]                           dc.b $00
[0000736d]                           dc.b $00
[0000736e]                           dc.b $00
[0000736f]                           dc.b $08
[00007370]                           dc.b $00
[00007371]                           dc.b $10
[00007372]                           dc.b $00
[00007373]                           dc.b $00
[00007374]                           dc.b $00
[00007375]                           dc.b $00
[00007376]                           dc.b $00
[00007377]                           dc.b $00
[00007378]                           dc.b $00
[00007379]                           dc.b $00
[0000737a]                           dc.b $00
[0000737b]                           dc.b $08
[0000737c]                           dc.b $00
[0000737d]                           dc.b $08
~_308:
[0000737e]                           dc.b $00
[0000737f]                           dc.b $00
[00007380]                           dc.b $00
[00007381]                           dc.b $00
[00007382]                           dc.b $00
[00007383]                           dc.b $00
[00007384]                           dc.b $00
[00007385]                           dc.b $00
[00007386]                           dc.b $00
[00007387]                           dc.b $00
[00007388]                           dc.b $00
[00007389]                           dc.b $00
[0000738a]                           dc.b $00
[0000738b]                           dc.b $00
[0000738c]                           dc.b $00
[0000738d]                           dc.b $00
[0000738e]                           dc.b $00
[0000738f]                           dc.b $00
[00007390]                           dc.b $00
[00007391]                           dc.b $00
~_309:
[00007392]                           dc.b $00
[00007393]                           dc.b $00
[00007394]                           dc.b $00
[00007395]                           dc.b $00
[00007396]                           dc.b $00
[00007397]                           dc.b $00
[00007398]                           dc.b $00
[00007399]                           dc.b $00
~_310:
[0000739a]                           dc.b $00
[0000739b]                           dc.b $01
[0000739c]                           dc.b $00
[0000739d]                           dc.b $00
~_311:
[0000739e]                           dc.b $00
[0000739f]                           dc.b $00
[000073a0]                           dc.b $00
[000073a1]                           dc.b $00
~_312:
[000073a2]                           dc.b $00
[000073a3]                           dc.b $01
[000073a4]                           dc.b $00
[000073a5]                           dc.b $00
~_313:
[000073a6]                           dc.b $00
[000073a7]                           dc.b $01
[000073a8]                           dc.b $00
[000073a9]                           dc.b $00
~_314:
[000073aa]                           dc.b $00
[000073ab]                           dc.b $00
[000073ac]                           dc.b $00
[000073ad]                           dc.b $38
[000073ae]                           dc.b $00
[000073af]                           dc.b $00
~_325:
[000073b0]                           dc.b $00
[000073b1]                           dc.b $00
[000073b2]                           dc.b $00
[000073b3]                           dc.b $00
[000073b4]                           dc.b $00
[000073b5]                           dc.b $00
[000073b6]                           dc.b $00
[000073b7]                           dc.b $00
~_327:
[000073b8]                           dc.b '@(#)Fliegende Dialoge 0.31, Copyright (c)  Julian F. Reschke, Apr 02 1991',0
~_328:
[00007402]                           dc.w $ffff
~_329:
[00007404]                           dc.w $ffff
~_330:
[00007406]                           dc.w $ffff
~_331:
[00007408]                           dc.w $ffff
~_332:
[0000740a]                           dc.w $ffff
~_333:
[0000740c]                           dc.w $ffff
[0000740e]                           dc.w $2020
[00007410]                           dc.b $00
[00007411]                           dc.b '6x6 system font',0
[00007421]                           dc.b 'System font',0
[0000742d]                           dc.b $00
~_342:
[0000742e]                           dc.b $00
[0000742f]                           dc.b $00
~_343:
[00007430]                           dc.b $00
[00007431]                           dc.b $00
~_347:
[00007432]                           dc.b $00
[00007433]                           dc.b $00
[00007434]                           dc.b $00
[00007435]                           dc.b $00
[00007436]                           dc.b $00
[00007437]                           dc.b $1f
[00007438]                           dc.w $fe00
[0000743a]                           dc.b $00
[0000743b]                           dc.b $7f
[0000743c]                           dc.w $ff80
[0000743e]                           dc.b $00
[0000743f]                           dc.b $ff
[00007440]                           dc.w $ffc0
[00007442]                           dc.w $01ff
[00007444]                           dc.w $ffe0
[00007446]                           dc.w $01f8
[00007448]                           dc.w $07e0
[0000744a]                           dc.w $01f0
[0000744c]                           dc.w $03e0
[0000744e]                           dc.w $01f0
[00007450]                           dc.w $03e0
[00007452]                           dc.b $00
[00007453]                           dc.b $e0
[00007454]                           dc.w $03e0
[00007456]                           dc.b $00
[00007457]                           dc.b $00
[00007458]                           dc.w $07c0
[0000745a]                           dc.b $00
[0000745b]                           dc.b $00
[0000745c]                           dc.w $0fc0
[0000745e]                           dc.b $00
[0000745f]                           dc.b $00
[00007460]                           dc.w $1f80
[00007462]                           dc.b $00
[00007463]                           dc.b $00
[00007464]                           dc.w $3f00
[00007466]                           dc.b $00
[00007467]                           dc.b $00
[00007468]                           dc.w $7e00
[0000746a]                           dc.b $00
[0000746b]                           dc.b $00
[0000746c]                           dc.w $fc00
[0000746e]                           dc.b $00
[0000746f]                           dc.b $01
[00007470]                           dc.w $f800
[00007472]                           dc.b $00
[00007473]                           dc.b $03
[00007474]                           dc.w $f000
[00007476]                           dc.b $00
[00007477]                           dc.b $03
[00007478]                           dc.w $e000
[0000747a]                           dc.b $00
[0000747b]                           dc.b $07
[0000747c]                           dc.w $c000
[0000747e]                           dc.b $00
[0000747f]                           dc.b $07
[00007480]                           dc.w $c000
[00007482]                           dc.b $00
[00007483]                           dc.b $07
[00007484]                           dc.w $c000
[00007486]                           dc.b $00
[00007487]                           dc.b $07
[00007488]                           dc.w $c000
[0000748a]                           dc.b $00
[0000748b]                           dc.b $07
[0000748c]                           dc.w $c000
[0000748e]                           dc.b $00
[0000748f]                           dc.b $03
[00007490]                           dc.w $8000
[00007492]                           dc.b $00
[00007493]                           dc.b $00
[00007494]                           dc.b $00
[00007495]                           dc.b $00
[00007496]                           dc.b $00
[00007497]                           dc.b $00
[00007498]                           dc.b $00
[00007499]                           dc.b $00
[0000749a]                           dc.b $00
[0000749b]                           dc.b $00
[0000749c]                           dc.b $00
[0000749d]                           dc.b $00
[0000749e]                           dc.b $00
[0000749f]                           dc.b $07
[000074a0]                           dc.w $c000
[000074a2]                           dc.b $00
[000074a3]                           dc.b $0f
[000074a4]                           dc.w $e000
[000074a6]                           dc.b $00
[000074a7]                           dc.b $0f
[000074a8]                           dc.w $e000
[000074aa]                           dc.b $00
[000074ab]                           dc.b $07
[000074ac]                           dc.w $c000
[000074ae]                           dc.b $00
[000074af]                           dc.b $00
[000074b0]                           dc.b $00
[000074b1]                           dc.b $00
~_348:
[000074b2]                           dc.b $00
[000074b3]                           dc.b $00
[000074b4]                           dc.b $00
[000074b5]                           dc.b $00
[000074b6]                           dc.b $00
[000074b7]                           dc.b $04
[000074b8]                           dc.b $00
[000074b9]                           dc.b $20
[000074ba]                           dc.b $00
[000074bb]                           dc.b $00
[000074bc]                           dc.b $00
[000074bd]                           dc.b $00
[000074be]                           dc.b $00
[000074bf]                           dc.b $01
~_349:
[000074c0]                           dc.b $00
[000074c1]                           dc.b $00
~_351:
[000074c2]                           dc.b $00
[000074c3]                           dc.b $00
[000074c4]                           dc.b $00
[000074c5]                           dc.b $00
[000074c6]                           dc.b $00
[000074c7]                           dc.b $01
[000074c8]                           dc.w $c000
[000074ca]                           dc.b $00
[000074cb]                           dc.b $73
[000074cc]                           dc.w $e000
[000074ce]                           dc.b $00
[000074cf]                           dc.b $fb
[000074d0]                           dc.w $e700
[000074d2]                           dc.b $00
[000074d3]                           dc.b $fb
[000074d4]                           dc.w $ef80
[000074d6]                           dc.w $1cfb
[000074d8]                           dc.w $ef80
[000074da]                           dc.w $3efb
[000074dc]                           dc.w $ef80
[000074de]                           dc.w $3efb
[000074e0]                           dc.w $ef80
[000074e2]                           dc.w $3efb
[000074e4]                           dc.w $ef80
[000074e6]                           dc.w $3efb
[000074e8]                           dc.w $ef80
[000074ea]                           dc.w $3efb
[000074ec]                           dc.w $ef80
[000074ee]                           dc.w $3efb
[000074f0]                           dc.w $ef80
[000074f2]                           dc.w $3efb
[000074f4]                           dc.w $ef9c
[000074f6]                           dc.w $3efb
[000074f8]                           dc.w $efbc
[000074fa]                           dc.w $3efb
[000074fc]                           dc.w $efbc
[000074fe]                           dc.w $3fff
[00007500]                           dc.w $ff7c
[00007502]                           dc.w $3fff
[00007504]                           dc.w $ff7c
[00007506]                           dc.w $3fff
[00007508]                           dc.w $ff7c
[0000750a]                           dc.w $3fff
[0000750c]                           dc.w $fefc
[0000750e]                           dc.w $3fff
[00007510]                           dc.w $f7f8
[00007512]                           dc.w $3fff
[00007514]                           dc.w $dff8
[00007516]                           dc.w $3fff
[00007518]                           dc.w $7ff0
[0000751a]                           dc.w $3fff
[0000751c]                           dc.w $fff0
[0000751e]                           dc.w $3ffd
[00007520]                           dc.w $ffe0
[00007522]                           dc.w $1ffd
[00007524]                           dc.w $ffc0
[00007526]                           dc.w $0fff
[00007528]                           dc.w $ff80
[0000752a]                           dc.w $07ff
[0000752c]                           dc.w $ff00
[0000752e]                           dc.w $03ff
[00007530]                           dc.w $fe00
[00007532]                           dc.w $03ff
[00007534]                           dc.w $fe00
[00007536]                           dc.w $03ff
[00007538]                           dc.w $fe00
[0000753a]                           dc.w $03ff
[0000753c]                           dc.w $fe00
[0000753e]                           dc.b $00
[0000753f]                           dc.b $00
[00007540]                           dc.b $00
[00007541]                           dc.b $00
~_352:
[00007542]                           dc.b $00
[00007543]                           dc.b $00
[00007544]                           dc.b $00
[00007545]                           dc.b $00
[00007546]                           dc.b $00
[00007547]                           dc.b $04
[00007548]                           dc.b $00
[00007549]                           dc.b $20
[0000754a]                           dc.b $00
[0000754b]                           dc.b $00
[0000754c]                           dc.b $00
[0000754d]                           dc.b $00
[0000754e]                           dc.b $00
[0000754f]                           dc.b $01
~_353:
[00007550]                           dc.b $00
[00007551]                           dc.b $00
~_355:
[00007552]                           dc.w $3fff
[00007554]                           dc.w $fffc
[00007556]                           dc.w $7fff
[00007558]                           dc.w $fffe
[0000755a]                           dc.w $7ffc
[0000755c]                           dc.w $3ffe
[0000755e]                           dc.w $7ff8
[00007560]                           dc.w $1ffe
[00007562]                           dc.w $7ff0
[00007564]                           dc.w $0ffe
[00007566]                           dc.w $7ff0
[00007568]                           dc.w $0ffe
[0000756a]                           dc.w $7ff0
[0000756c]                           dc.w $0ffe
[0000756e]                           dc.w $7ff8
[00007570]                           dc.w $1ffe
[00007572]                           dc.w $7ffc
[00007574]                           dc.w $3ffe
[00007576]                           dc.w $7fff
[00007578]                           dc.w $fffe
[0000757a]                           dc.w $7fff
[0000757c]                           dc.w $fffe
[0000757e]                           dc.w $7f80
[00007580]                           dc.w $0ffe
[00007582]                           dc.w $7f80
[00007584]                           dc.w $0ffe
[00007586]                           dc.w $7ff0
[00007588]                           dc.w $0ffe
[0000758a]                           dc.w $7ff0
[0000758c]                           dc.w $0ffe
[0000758e]                           dc.w $7ff0
[00007590]                           dc.w $0ffe
[00007592]                           dc.w $7ff0
[00007594]                           dc.w $0ffe
[00007596]                           dc.w $7ff0
[00007598]                           dc.w $0ffe
[0000759a]                           dc.w $7ff0
[0000759c]                           dc.w $0ffe
[0000759e]                           dc.w $7ff0
[000075a0]                           dc.w $0ffe
[000075a2]                           dc.w $7ff0
[000075a4]                           dc.w $0ffe
[000075a6]                           dc.w $7ff0
[000075a8]                           dc.w $0ffe
[000075aa]                           dc.w $7ff0
[000075ac]                           dc.w $0ffe
[000075ae]                           dc.w $7ff0
[000075b0]                           dc.w $0ffe
[000075b2]                           dc.w $7ff0
[000075b4]                           dc.w $0ffe
[000075b6]                           dc.w $7ff0
[000075b8]                           dc.w $0ffe
[000075ba]                           dc.w $7ff0
[000075bc]                           dc.w $0ffe
[000075be]                           dc.w $7f80
[000075c0]                           dc.w $01fe
[000075c2]                           dc.w $7f80
[000075c4]                           dc.w $01fe
[000075c6]                           dc.w $7fff
[000075c8]                           dc.w $fffe
[000075ca]                           dc.w $3fff
[000075cc]                           dc.w $fffc
[000075ce]                           dc.b $00
[000075cf]                           dc.b $00
[000075d0]                           dc.b $00
[000075d1]                           dc.b $00
~_356:
[000075d2]                           dc.b $00
[000075d3]                           dc.b $00
[000075d4]                           dc.b $00
[000075d5]                           dc.b $00
[000075d6]                           dc.b $00
[000075d7]                           dc.b $04
[000075d8]                           dc.b $00
[000075d9]                           dc.b $20
[000075da]                           dc.b $00
[000075db]                           dc.b $00
[000075dc]                           dc.b $00
[000075dd]                           dc.b $00
[000075de]                           dc.b $00
[000075df]                           dc.b $01
~_357:
[000075e0]                           dc.b $00
[000075e1]                           dc.b $00
~_359:
[000075e2]                           dc.b $00
[000075e3]                           dc.b $00
[000075e4]                           dc.b $00
[000075e5]                           dc.b $00
[000075e6]                           dc.b $00
[000075e7]                           dc.b $00
[000075e8]                           dc.b $00
[000075e9]                           dc.b $00
[000075ea]                           dc.b $00
[000075eb]                           dc.b $00
[000075ec]                           dc.w $0700
[000075ee]                           dc.b $00
[000075ef]                           dc.b $00
[000075f0]                           dc.w $0f80
[000075f2]                           dc.b $00
[000075f3]                           dc.b $00
[000075f4]                           dc.w $0f80
[000075f6]                           dc.b $00
[000075f7]                           dc.b $00
[000075f8]                           dc.w $0f80
[000075fa]                           dc.b $00
[000075fb]                           dc.b $00
[000075fc]                           dc.w $0f80
[000075fe]                           dc.b $00
[000075ff]                           dc.b $00
[00007600]                           dc.w $0f80
[00007602]                           dc.b $00
[00007603]                           dc.b $00
[00007604]                           dc.w $0f80
[00007606]                           dc.b $00
[00007607]                           dc.b $00
[00007608]                           dc.w $0f80
[0000760a]                           dc.b $00
[0000760b]                           dc.b $00
[0000760c]                           dc.w $0f80
[0000760e]                           dc.b $00
[0000760f]                           dc.b $00
[00007610]                           dc.w $0f80
[00007612]                           dc.b $00
[00007613]                           dc.b $79
[00007614]                           dc.w $ef9c
[00007616]                           dc.w $0efb
[00007618]                           dc.w $efbc
[0000761a]                           dc.w $1efb
[0000761c]                           dc.w $efbc
[0000761e]                           dc.w $1efb
[00007620]                           dc.w $ef7c
[00007622]                           dc.w $16aa
[00007624]                           dc.w $af7c
[00007626]                           dc.w $1efb
[00007628]                           dc.w $ef7c
[0000762a]                           dc.w $0d75
[0000762c]                           dc.w $dcbc
[0000762e]                           dc.w $038e
[00007630]                           dc.w $37f8
[00007632]                           dc.w $1fff
[00007634]                           dc.w $dff8
[00007636]                           dc.w $1fff
[00007638]                           dc.w $7ff0
[0000763a]                           dc.w $1fff
[0000763c]                           dc.w $fff0
[0000763e]                           dc.w $1ffd
[00007640]                           dc.w $ffe0
[00007642]                           dc.w $1fff
[00007644]                           dc.w $ffc0
[00007646]                           dc.w $0ffd
[00007648]                           dc.w $ff80
[0000764a]                           dc.w $07ff
[0000764c]                           dc.w $fe00
[0000764e]                           dc.w $01ff
[00007650]                           dc.w $f400
[00007652]                           dc.w $015f
[00007654]                           dc.w $fc00
[00007656]                           dc.w $01ff
[00007658]                           dc.w $fc00
[0000765a]                           dc.w $01ff
[0000765c]                           dc.w $fc00
[0000765e]                           dc.b $00
[0000765f]                           dc.b $00
[00007660]                           dc.b $00
[00007661]                           dc.b $00
~_360:
[00007662]                           dc.b $00
[00007663]                           dc.b $00
[00007664]                           dc.b $00
[00007665]                           dc.b $00
[00007666]                           dc.b $00
[00007667]                           dc.b $04
[00007668]                           dc.b $00
[00007669]                           dc.b $20
[0000766a]                           dc.b $00
[0000766b]                           dc.b $00
[0000766c]                           dc.b $00
[0000766d]                           dc.b $00
[0000766e]                           dc.b $00
[0000766f]                           dc.b $01
~_361:
[00007670]                           dc.b $00
[00007671]                           dc.b $00
~_363:
[00007672]                           dc.b $00
[00007673]                           dc.b $00
[00007674]                           dc.b $00
[00007675]                           dc.b $00
[00007676]                           dc.b $00
[00007677]                           dc.b $00
[00007678]                           dc.b $00
[00007679]                           dc.b $00
[0000767a]                           dc.b $00
[0000767b]                           dc.b $00
[0000767c]                           dc.b $00
[0000767d]                           dc.b $00
[0000767e]                           dc.b $00
[0000767f]                           dc.b $00
[00007680]                           dc.b $00
[00007681]                           dc.b $00
[00007682]                           dc.b $00
[00007683]                           dc.b $00
[00007684]                           dc.b $00
[00007685]                           dc.b $00
[00007686]                           dc.b $00
[00007687]                           dc.b $00
[00007688]                           dc.b $00
[00007689]                           dc.b $00
[0000768a]                           dc.b $00
[0000768b]                           dc.b $00
[0000768c]                           dc.w $c790
[0000768e]                           dc.b $00
[0000768f]                           dc.b $00
[00007690]                           dc.w $f844
[00007692]                           dc.b $00
[00007693]                           dc.b $3d
[00007694]                           dc.w $f830
[00007696]                           dc.w $01ff
[00007698]                           dc.w $fcb2
[0000769a]                           dc.w $07ff
[0000769c]                           dc.w $fc00
[0000769e]                           dc.w $0fff
[000076a0]                           dc.w $f848
[000076a2]                           dc.w $1f3f
[000076a4]                           dc.w $f800
[000076a6]                           dc.w $1e67
[000076a8]                           dc.w $f800
[000076aa]                           dc.w $3fcf
[000076ac]                           dc.w $fc00
[000076ae]                           dc.w $3cff
[000076b0]                           dc.w $fc00
[000076b2]                           dc.w $3c9f
[000076b4]                           dc.w $fc00
[000076b6]                           dc.w $7f9f
[000076b8]                           dc.w $fe00
[000076ba]                           dc.w $7fff
[000076bc]                           dc.w $fe00
[000076be]                           dc.w $7fff
[000076c0]                           dc.w $fe00
[000076c2]                           dc.w $7fff
[000076c4]                           dc.w $fe00
[000076c6]                           dc.w $3fff
[000076c8]                           dc.w $fc00
[000076ca]                           dc.w $3fff
[000076cc]                           dc.w $fc00
[000076ce]                           dc.w $3fff
[000076d0]                           dc.w $fc00
[000076d2]                           dc.w $1fff
[000076d4]                           dc.w $f800
[000076d6]                           dc.w $1fff
[000076d8]                           dc.w $f800
[000076da]                           dc.w $0fff
[000076dc]                           dc.w $f000
[000076de]                           dc.w $07ff
[000076e0]                           dc.w $e000
[000076e2]                           dc.w $01ff
[000076e4]                           dc.w $8000
[000076e6]                           dc.b $00
[000076e7]                           dc.b $3c
[000076e8]                           dc.b $00
[000076e9]                           dc.b $00
[000076ea]                           dc.b $00
[000076eb]                           dc.b $00
[000076ec]                           dc.b $00
[000076ed]                           dc.b $00
[000076ee]                           dc.b $00
[000076ef]                           dc.b $00
[000076f0]                           dc.b $00
[000076f1]                           dc.b $00
~_364:
[000076f2]                           dc.b $00
[000076f3]                           dc.b $00
[000076f4]                           dc.b $00
[000076f5]                           dc.b $00
[000076f6]                           dc.b $00
[000076f7]                           dc.b $04
[000076f8]                           dc.b $00
[000076f9]                           dc.b $20
[000076fa]                           dc.b $00
[000076fb]                           dc.b $00
[000076fc]                           dc.b $00
[000076fd]                           dc.b $00
[000076fe]                           dc.b $00
[000076ff]                           dc.b $01
~_365:
[00007700]                           dc.b $00
[00007701]                           dc.b $00
~_367:
[00007702]                           dc.b $00
[00007703]                           dc.b $00
[00007704]                           dc.b $00
[00007705]                           dc.b $00
[00007706]                           dc.b $00
[00007707]                           dc.b $00
[00007708]                           dc.w $8000
[0000770a]                           dc.b $00
[0000770b]                           dc.b $01
[0000770c]                           dc.w $c000
[0000770e]                           dc.b $00
[0000770f]                           dc.b $03
[00007710]                           dc.w $e000
[00007712]                           dc.b $00
[00007713]                           dc.b $03
[00007714]                           dc.w $f000
[00007716]                           dc.b $00
[00007717]                           dc.b $07
[00007718]                           dc.w $f800
[0000771a]                           dc.b $00
[0000771b]                           dc.b $07
[0000771c]                           dc.w $fc00
[0000771e]                           dc.b $00
[0000771f]                           dc.b $17
[00007720]                           dc.w $fe00
[00007722]                           dc.b $00
[00007723]                           dc.b $37
[00007724]                           dc.w $ff00
[00007726]                           dc.b $00
[00007727]                           dc.b $6f
[00007728]                           dc.w $ff00
[0000772a]                           dc.b $00
[0000772b]                           dc.b $df
[0000772c]                           dc.w $fe00
[0000772e]                           dc.w $01bf
[00007730]                           dc.w $fe00
[00007732]                           dc.w $037f
[00007734]                           dc.w $fc00
[00007736]                           dc.w $01bf
[00007738]                           dc.w $fd00
[0000773a]                           dc.w $02df
[0000773c]                           dc.w $fd80
[0000773e]                           dc.w $036f
[00007740]                           dc.w $fb00
[00007742]                           dc.w $03b7
[00007744]                           dc.w $f680
[00007746]                           dc.w $03db
[00007748]                           dc.w $ed80
[0000774a]                           dc.w $03ed
[0000774c]                           dc.w $db80
[0000774e]                           dc.w $03f6
[00007750]                           dc.w $b780
[00007752]                           dc.w $03fb
[00007754]                           dc.w $6f80
[00007756]                           dc.w $01fd
[00007758]                           dc.w $df00
[0000775a]                           dc.b $00
[0000775b]                           dc.b $fe
[0000775c]                           dc.w $bec0
[0000775e]                           dc.b $00
[0000775f]                           dc.b $7f
[00007760]                           dc.w $7dc0
[00007762]                           dc.b $00
[00007763]                           dc.b $3f
[00007764]                           dc.w $7dc0
[00007766]                           dc.b $00
[00007767]                           dc.b $1f
[00007768]                           dc.w $7d80
[0000776a]                           dc.b $00
[0000776b]                           dc.b $0f
[0000776c]                           dc.w $7800
[0000776e]                           dc.b $00
[0000776f]                           dc.b $07
[00007770]                           dc.w $7000
[00007772]                           dc.b $00
[00007773]                           dc.b $03
[00007774]                           dc.w $6000
[00007776]                           dc.b $00
[00007777]                           dc.b $01
[00007778]                           dc.w $4000
[0000777a]                           dc.b $00
[0000777b]                           dc.b $00
[0000777c]                           dc.b $00
[0000777d]                           dc.b $00
[0000777e]                           dc.b $00
[0000777f]                           dc.b $00
[00007780]                           dc.b $00
[00007781]                           dc.b $00
~_368:
[00007782]                           dc.b $00
[00007783]                           dc.b $00
[00007784]                           dc.b $00
[00007785]                           dc.b $00
[00007786]                           dc.b $00
[00007787]                           dc.b $04
[00007788]                           dc.b $00
[00007789]                           dc.b $20
[0000778a]                           dc.b $00
[0000778b]                           dc.b $00
[0000778c]                           dc.b $00
[0000778d]                           dc.b $00
[0000778e]                           dc.b $00
[0000778f]                           dc.b $01
~_369:
[00007790]                           dc.b $00
[00007791]                           dc.b $00
~_371:
[00007792]                           dc.b $00
[00007793]                           dc.b $00
[00007794]                           dc.b $00
[00007795]                           dc.b $00
[00007796]                           dc.b $00
[00007797]                           dc.b $00
[00007798]                           dc.b $00
[00007799]                           dc.b $00
[0000779a]                           dc.b $00
[0000779b]                           dc.b $00
[0000779c]                           dc.w $2000
[0000779e]                           dc.b $00
[0000779f]                           dc.b $00
[000077a0]                           dc.w $7000
[000077a2]                           dc.b $00
[000077a3]                           dc.b $00
[000077a4]                           dc.w $f800
[000077a6]                           dc.b $00
[000077a7]                           dc.b $01
[000077a8]                           dc.w $fc00
[000077aa]                           dc.b $00
[000077ab]                           dc.b $02
[000077ac]                           dc.w $fe00
[000077ae]                           dc.b $00
[000077af]                           dc.b $04
[000077b0]                           dc.w $7f00
[000077b2]                           dc.b $00
[000077b3]                           dc.b $08
[000077b4]                           dc.w $3f80
[000077b6]                           dc.b $00
[000077b7]                           dc.b $10
[000077b8]                           dc.w $3fc0
[000077ba]                           dc.b $00
[000077bb]                           dc.b $20
[000077bc]                           dc.w $7fe0
[000077be]                           dc.b $00
[000077bf]                           dc.b $43
[000077c0]                           dc.w $e7c0
[000077c2]                           dc.b $00
[000077c3]                           dc.b $87
[000077c4]                           dc.w $c3a0
[000077c6]                           dc.b $00
[000077c7]                           dc.b $87
[000077c8]                           dc.w $c160
[000077ca]                           dc.w $0147
[000077cc]                           dc.w $c2e0
[000077ce]                           dc.w $01a3
[000077d0]                           dc.w $85e0
[000077d2]                           dc.w $01d0
[000077d4]                           dc.w $0be0
[000077d6]                           dc.b $00
[000077d7]                           dc.b $e8
[000077d8]                           dc.w $17e0
[000077da]                           dc.w $0134
[000077dc]                           dc.w $2fc0
[000077de]                           dc.w $019a
[000077e0]                           dc.w $5f80
[000077e2]                           dc.w $018d
[000077e4]                           dc.w $bf00
[000077e6]                           dc.b $00
[000077e7]                           dc.b $c6
[000077e8]                           dc.w $7e00
[000077ea]                           dc.b $00
[000077eb]                           dc.b $66
[000077ec]                           dc.w $fc00
[000077ee]                           dc.b $00
[000077ef]                           dc.b $32
[000077f0]                           dc.w $f800
[000077f2]                           dc.b $00
[000077f3]                           dc.b $1c
[000077f4]                           dc.w $f000
[000077f6]                           dc.b $00
[000077f7]                           dc.b $0e
[000077f8]                           dc.w $e000
[000077fa]                           dc.b $00
[000077fb]                           dc.b $06
[000077fc]                           dc.w $c000
[000077fe]                           dc.b $00
[000077ff]                           dc.b $02
[00007800]                           dc.w $8000
[00007802]                           dc.b $00
[00007803]                           dc.b $00
[00007804]                           dc.b $00
[00007805]                           dc.b $00
[00007806]                           dc.b $00
[00007807]                           dc.b $00
[00007808]                           dc.b $00
[00007809]                           dc.b $00
[0000780a]                           dc.b $00
[0000780b]                           dc.b $00
[0000780c]                           dc.b $00
[0000780d]                           dc.b $00
[0000780e]                           dc.b $00
[0000780f]                           dc.b $00
[00007810]                           dc.b $00
[00007811]                           dc.b $00
~_372:
[00007812]                           dc.b $00
[00007813]                           dc.b $00
[00007814]                           dc.b $00
[00007815]                           dc.b $00
[00007816]                           dc.b $00
[00007817]                           dc.b $04
[00007818]                           dc.b $00
[00007819]                           dc.b $20
[0000781a]                           dc.b $00
[0000781b]                           dc.b $00
[0000781c]                           dc.b $00
[0000781d]                           dc.b $00
[0000781e]                           dc.b $00
[0000781f]                           dc.b $01
~_373:
[00007820]                           dc.b $00
[00007821]                           dc.b $00
~_375:
[00007822]                           dc.b $00
[00007823]                           dc.b $00
[00007824]                           dc.b $00
[00007825]                           dc.b $00
[00007826]                           dc.b $00
[00007827]                           dc.b $00
[00007828]                           dc.b $00
[00007829]                           dc.b $00
[0000782a]                           dc.w $3fff
[0000782c]                           dc.w $f780
[0000782e]                           dc.w $7e00
[00007830]                           dc.w $1fc0
[00007832]                           dc.w $7e03
[00007834]                           dc.w $9fe0
[00007836]                           dc.w $7e03
[00007838]                           dc.w $9fe0
[0000783a]                           dc.w $7e03
[0000783c]                           dc.w $9fe0
[0000783e]                           dc.w $7e03
[00007840]                           dc.w $9fe0
[00007842]                           dc.w $7e03
[00007844]                           dc.w $9fe0
[00007846]                           dc.w $7e03
[00007848]                           dc.w $9fe0
[0000784a]                           dc.w $7f00
[0000784c]                           dc.w $3fe0
[0000784e]                           dc.w $7fff
[00007850]                           dc.w $ffe0
[00007852]                           dc.w $7fff
[00007854]                           dc.w $ffe0
[00007856]                           dc.w $7fff
[00007858]                           dc.w $ffe0
[0000785a]                           dc.w $7000
[0000785c]                           dc.b $00
[0000785d]                           dc.b $e0
[0000785e]                           dc.w $7000
[00007860]                           dc.b $00
[00007861]                           dc.b $e0
[00007862]                           dc.w $73c0
[00007864]                           dc.b $00
[00007865]                           dc.b $e0
[00007866]                           dc.w $7000
[00007868]                           dc.b $00
[00007869]                           dc.b $e0
[0000786a]                           dc.w $73fd
[0000786c]                           dc.w $80e0
[0000786e]                           dc.w $7000
[00007870]                           dc.b $00
[00007871]                           dc.b $e0
[00007872]                           dc.w $7390
[00007874]                           dc.b $00
[00007875]                           dc.b $e0
[00007876]                           dc.w $7000
[00007878]                           dc.b $00
[00007879]                           dc.b $e0
[0000787a]                           dc.w $73fe
[0000787c]                           dc.w $60e0
[0000787e]                           dc.w $7000
[00007880]                           dc.b $00
[00007881]                           dc.b $e0
[00007882]                           dc.w $537c
[00007884]                           dc.w $c0e0
[00007886]                           dc.w $5000
[00007888]                           dc.b $00
[00007889]                           dc.b $e0
[0000788a]                           dc.w $7000
[0000788c]                           dc.b $00
[0000788d]                           dc.b $e0
[0000788e]                           dc.w $3fff
[00007890]                           dc.w $ffc0
[00007892]                           dc.b $00
[00007893]                           dc.b $00
[00007894]                           dc.b $00
[00007895]                           dc.b $00
[00007896]                           dc.b $00
[00007897]                           dc.b $00
[00007898]                           dc.b $00
[00007899]                           dc.b $00
[0000789a]                           dc.b $00
[0000789b]                           dc.b $00
[0000789c]                           dc.b $00
[0000789d]                           dc.b $00
[0000789e]                           dc.b $00
[0000789f]                           dc.b $00
[000078a0]                           dc.b $00
[000078a1]                           dc.b $00
~_376:
[000078a2]                           dc.b $00
[000078a3]                           dc.b $00
[000078a4]                           dc.b $00
[000078a5]                           dc.b $00
[000078a6]                           dc.b $00
[000078a7]                           dc.b $04
[000078a8]                           dc.b $00
[000078a9]                           dc.b $20
[000078aa]                           dc.b $00
[000078ab]                           dc.b $00
[000078ac]                           dc.b $00
[000078ad]                           dc.b $00
[000078ae]                           dc.b $00
[000078af]                           dc.b $01
~_377:
[000078b0]                           dc.b $00
[000078b1]                           dc.b $00
~_379:
[000078b2]                           dc.b $00
[000078b3]                           dc.b $03
[000078b4]                           dc.w $c000
[000078b6]                           dc.b $00
[000078b7]                           dc.b $06
[000078b8]                           dc.w $6000
[000078ba]                           dc.b $00
[000078bb]                           dc.b $0d
[000078bc]                           dc.w $b000
[000078be]                           dc.b $00
[000078bf]                           dc.b $1b
[000078c0]                           dc.w $d800
[000078c2]                           dc.b $00
[000078c3]                           dc.b $37
[000078c4]                           dc.w $ec00
[000078c6]                           dc.b $00
[000078c7]                           dc.b $6f
[000078c8]                           dc.w $f600
[000078ca]                           dc.b $00
[000078cb]                           dc.b $dc
[000078cc]                           dc.w $3b00
[000078ce]                           dc.w $01bc
[000078d0]                           dc.w $3d80
[000078d2]                           dc.w $037c
[000078d4]                           dc.w $3ec0
[000078d6]                           dc.w $06fc
[000078d8]                           dc.w $3f60
[000078da]                           dc.w $0dfc
[000078dc]                           dc.w $3fb0
[000078de]                           dc.w $1bfc
[000078e0]                           dc.w $3fd8
[000078e2]                           dc.w $37fc
[000078e4]                           dc.w $3fec
[000078e6]                           dc.w $6ffc
[000078e8]                           dc.w $3ff6
[000078ea]                           dc.w $dffc
[000078ec]                           dc.w $3ffb
[000078ee]                           dc.w $bffc
[000078f0]                           dc.w $3ffd
[000078f2]                           dc.w $bffc
[000078f4]                           dc.w $3ffd
[000078f6]                           dc.w $dffc
[000078f8]                           dc.w $3ffb
[000078fa]                           dc.w $6ffc
[000078fc]                           dc.w $3ff6
[000078fe]                           dc.w $37fc
[00007900]                           dc.w $3fec
[00007902]                           dc.w $1bff
[00007904]                           dc.w $ffd8
[00007906]                           dc.w $0dff
[00007908]                           dc.w $ffb0
[0000790a]                           dc.w $06fc
[0000790c]                           dc.w $3f60
[0000790e]                           dc.w $037c
[00007910]                           dc.w $3ec0
[00007912]                           dc.w $01bc
[00007914]                           dc.w $3d80
[00007916]                           dc.b $00
[00007917]                           dc.b $dc
[00007918]                           dc.w $3b00
[0000791a]                           dc.b $00
[0000791b]                           dc.b $6f
[0000791c]                           dc.w $f600
[0000791e]                           dc.b $00
[0000791f]                           dc.b $37
[00007920]                           dc.w $ec00
[00007922]                           dc.b $00
[00007923]                           dc.b $1b
[00007924]                           dc.w $d800
[00007926]                           dc.b $00
[00007927]                           dc.b $0d
[00007928]                           dc.w $b000
[0000792a]                           dc.b $00
[0000792b]                           dc.b $06
[0000792c]                           dc.w $6000
[0000792e]                           dc.b $00
[0000792f]                           dc.b $03
[00007930]                           dc.w $c000
~_380:
[00007932]                           dc.b $00
[00007933]                           dc.b $00
[00007934]                           dc.b $00
[00007935]                           dc.b $00
[00007936]                           dc.b $00
[00007937]                           dc.b $04
[00007938]                           dc.b $00
[00007939]                           dc.b $20
[0000793a]                           dc.b $00
[0000793b]                           dc.b $00
[0000793c]                           dc.b $00
[0000793d]                           dc.b $00
[0000793e]                           dc.b $00
[0000793f]                           dc.b $01
~_381:
[00007940]                           dc.b $00
[00007941]                           dc.b $00
~_383:
[00007942]                           dc.w $3fff
[00007944]                           dc.w $fffc
[00007946]                           dc.w $c000
[00007948]                           dc.b $00
[00007949]                           dc.b $03
[0000794a]                           dc.w $9fff
[0000794c]                           dc.w $fff9
[0000794e]                           dc.w $bfff
[00007950]                           dc.w $fffd
[00007952]                           dc.w $dff8
[00007954]                           dc.w $3ffb
[00007956]                           dc.w $5fe0
[00007958]                           dc.w $0ffa
[0000795a]                           dc.w $6fc0
[0000795c]                           dc.w $07f6
[0000795e]                           dc.w $2f83
[00007960]                           dc.w $83f4
[00007962]                           dc.w $3787
[00007964]                           dc.w $c3ec
[00007966]                           dc.w $1787
[00007968]                           dc.w $c3e8
[0000796a]                           dc.w $1bff
[0000796c]                           dc.w $83d8
[0000796e]                           dc.w $0bff
[00007970]                           dc.w $07d0
[00007972]                           dc.w $0dfe
[00007974]                           dc.w $0fb0
[00007976]                           dc.w $05fc
[00007978]                           dc.w $1fa0
[0000797a]                           dc.w $06fc
[0000797c]                           dc.w $3f60
[0000797e]                           dc.w $02fc
[00007980]                           dc.w $3f40
[00007982]                           dc.w $037c
[00007984]                           dc.w $3ec0
[00007986]                           dc.w $017c
[00007988]                           dc.w $3e80
[0000798a]                           dc.w $01bf
[0000798c]                           dc.w $fd80
[0000798e]                           dc.b $00
[0000798f]                           dc.b $bf
[00007990]                           dc.w $fd00
[00007992]                           dc.b $00
[00007993]                           dc.b $dc
[00007994]                           dc.w $3b00
[00007996]                           dc.b $00
[00007997]                           dc.b $5c
[00007998]                           dc.w $3a00
[0000799a]                           dc.b $00
[0000799b]                           dc.b $6c
[0000799c]                           dc.w $3600
[0000799e]                           dc.b $00
[0000799f]                           dc.b $2f
[000079a0]                           dc.w $f400
[000079a2]                           dc.b $00
[000079a3]                           dc.b $37
[000079a4]                           dc.w $ec00
[000079a6]                           dc.b $00
[000079a7]                           dc.b $17
[000079a8]                           dc.w $e800
[000079aa]                           dc.b $00
[000079ab]                           dc.b $1b
[000079ac]                           dc.w $d800
[000079ae]                           dc.b $00
[000079af]                           dc.b $0b
[000079b0]                           dc.w $d000
[000079b2]                           dc.b $00
[000079b3]                           dc.b $0d
[000079b4]                           dc.w $b000
[000079b6]                           dc.b $00
[000079b7]                           dc.b $05
[000079b8]                           dc.w $a000
[000079ba]                           dc.b $00
[000079bb]                           dc.b $06
[000079bc]                           dc.w $6000
[000079be]                           dc.b $00
[000079bf]                           dc.b $03
[000079c0]                           dc.w $c000
~_384:
[000079c2]                           dc.b $00
[000079c3]                           dc.b $00
[000079c4]                           dc.b $00
[000079c5]                           dc.b $00
[000079c6]                           dc.b $00
[000079c7]                           dc.b $04
[000079c8]                           dc.b $00
[000079c9]                           dc.b $20
[000079ca]                           dc.b $00
[000079cb]                           dc.b $00
[000079cc]                           dc.b $00
[000079cd]                           dc.b $00
[000079ce]                           dc.b $00
[000079cf]                           dc.b $01
~_385:
[000079d0]                           dc.b $00
[000079d1]                           dc.b $00
~_387:
[000079d2]                           dc.b $00
[000079d3]                           dc.b $7f
[000079d4]                           dc.w $fe00
[000079d6]                           dc.b $00
[000079d7]                           dc.b $c0
[000079d8]                           dc.w $0300
[000079da]                           dc.w $01bf
[000079dc]                           dc.w $fd80
[000079de]                           dc.w $037f
[000079e0]                           dc.w $fec0
[000079e2]                           dc.w $06ff
[000079e4]                           dc.w $ff60
[000079e6]                           dc.w $0dff
[000079e8]                           dc.w $ffb0
[000079ea]                           dc.w $1bff
[000079ec]                           dc.w $ffd8
[000079ee]                           dc.w $37ff
[000079f0]                           dc.w $ffec
[000079f2]                           dc.w $6fff
[000079f4]                           dc.w $fff6
[000079f6]                           dc.w $dfff
[000079f8]                           dc.w $fffb
[000079fa]                           dc.w $b181
[000079fc]                           dc.w $860d
[000079fe]                           dc.w $a081
[00007a00]                           dc.w $0205
[00007a02]                           dc.w $a4e7
[00007a04]                           dc.w $3265
[00007a06]                           dc.w $a7e7
[00007a08]                           dc.w $3265
[00007a0a]                           dc.w $a3e7
[00007a0c]                           dc.w $3265
[00007a0e]                           dc.w $b1e7
[00007a10]                           dc.w $3205
[00007a12]                           dc.w $b8e7
[00007a14]                           dc.w $320d
[00007a16]                           dc.w $bce7
[00007a18]                           dc.w $327d
[00007a1a]                           dc.w $a4e7
[00007a1c]                           dc.w $327d
[00007a1e]                           dc.w $a0e7
[00007a20]                           dc.w $027d
[00007a22]                           dc.w $b1e7
[00007a24]                           dc.w $867d
[00007a26]                           dc.w $bfff
[00007a28]                           dc.w $fffd
[00007a2a]                           dc.w $dfff
[00007a2c]                           dc.w $fffb
[00007a2e]                           dc.w $6fff
[00007a30]                           dc.w $fff6
[00007a32]                           dc.w $37ff
[00007a34]                           dc.w $ffec
[00007a36]                           dc.w $1bff
[00007a38]                           dc.w $ffd8
[00007a3a]                           dc.w $0dff
[00007a3c]                           dc.w $ffb0
[00007a3e]                           dc.w $06ff
[00007a40]                           dc.w $ff60
[00007a42]                           dc.w $037f
[00007a44]                           dc.w $fec0
[00007a46]                           dc.w $01bf
[00007a48]                           dc.w $fd80
[00007a4a]                           dc.b $00
[00007a4b]                           dc.b $c0
[00007a4c]                           dc.w $0300
[00007a4e]                           dc.b $00
[00007a4f]                           dc.b $7f
[00007a50]                           dc.w $fe00
~_388:
[00007a52]                           dc.b $00
[00007a53]                           dc.b $00
[00007a54]                           dc.b $00
[00007a55]                           dc.b $00
[00007a56]                           dc.b $00
[00007a57]                           dc.b $04
[00007a58]                           dc.b $00
[00007a59]                           dc.b $20
[00007a5a]                           dc.b $00
[00007a5b]                           dc.b $00
[00007a5c]                           dc.b $00
[00007a5d]                           dc.b $00
[00007a5e]                           dc.b $00
[00007a5f]                           dc.b $01
~_389:
[00007a60]                           dc.b $00
[00007a61]                           dc.b $00
~_391:
[00007a62]                           dc.w $3fff
[00007a64]                           dc.w $fffc
[00007a66]                           dc.w $7fff
[00007a68]                           dc.w $fffe
[00007a6a]                           dc.w $7ff8
[00007a6c]                           dc.w $1ffe
[00007a6e]                           dc.w $7fe0
[00007a70]                           dc.w $07fe
[00007a72]                           dc.w $7f80
[00007a74]                           dc.w $01fe
[00007a76]                           dc.w $7f00
[00007a78]                           dc.b $00
[00007a79]                           dc.b $fe
[00007a7a]                           dc.w $7e00
[00007a7c]                           dc.b $00
[00007a7d]                           dc.b $7e
[00007a7e]                           dc.w $7e01
[00007a80]                           dc.w $c07e
[00007a82]                           dc.w $7e03
[00007a84]                           dc.w $c07e
[00007a86]                           dc.w $7f07
[00007a88]                           dc.w $80fe
[00007a8a]                           dc.w $7fff
[00007a8c]                           dc.w $01fe
[00007a8e]                           dc.w $7ffe
[00007a90]                           dc.w $01fe
[00007a92]                           dc.w $7ffc
[00007a94]                           dc.w $03fe
[00007a96]                           dc.w $7ff8
[00007a98]                           dc.w $07fe
[00007a9a]                           dc.w $7ff8
[00007a9c]                           dc.w $07fe
[00007a9e]                           dc.w $7ff0
[00007aa0]                           dc.w $0ffe
[00007aa2]                           dc.w $7ff0
[00007aa4]                           dc.w $0ffe
[00007aa6]                           dc.w $7ff0
[00007aa8]                           dc.w $0ffe
[00007aaa]                           dc.w $7ff8
[00007aac]                           dc.w $1ffe
[00007aae]                           dc.w $7ffc
[00007ab0]                           dc.w $3ffe
[00007ab2]                           dc.w $7fff
[00007ab4]                           dc.w $fffe
[00007ab6]                           dc.w $7fff
[00007ab8]                           dc.w $fffe
[00007aba]                           dc.w $7ffc
[00007abc]                           dc.w $3ffe
[00007abe]                           dc.w $7ff8
[00007ac0]                           dc.w $1ffe
[00007ac2]                           dc.w $7ff0
[00007ac4]                           dc.w $0ffe
[00007ac6]                           dc.w $7ff0
[00007ac8]                           dc.w $0ffe
[00007aca]                           dc.w $7ff0
[00007acc]                           dc.w $0ffe
[00007ace]                           dc.w $7ff8
[00007ad0]                           dc.w $1ffe
[00007ad2]                           dc.w $7ffc
[00007ad4]                           dc.w $3ffe
[00007ad6]                           dc.w $7fff
[00007ad8]                           dc.w $fffe
[00007ada]                           dc.w $3fff
[00007adc]                           dc.w $fffc
[00007ade]                           dc.b $00
[00007adf]                           dc.b $00
[00007ae0]                           dc.b $00
[00007ae1]                           dc.b $00
~_392:
[00007ae2]                           dc.b $00
[00007ae3]                           dc.b $00
[00007ae4]                           dc.b $00
[00007ae5]                           dc.b $00
[00007ae6]                           dc.b $00
[00007ae7]                           dc.b $04
[00007ae8]                           dc.b $00
[00007ae9]                           dc.b $20
[00007aea]                           dc.b $00
[00007aeb]                           dc.b $00
[00007aec]                           dc.b $00
[00007aed]                           dc.b $00
[00007aee]                           dc.b $00
[00007aef]                           dc.b $01
~_393:
[00007af0]                           dc.b $00
[00007af1]                           dc.b $00
~_395:
[00007af2]                           dc.w $3fff
[00007af4]                           dc.w $fffc
[00007af6]                           dc.w $7fff
[00007af8]                           dc.w $fffe
[00007afa]                           dc.w $7ff8
[00007afc]                           dc.w $1ffe
[00007afe]                           dc.w $7ff0
[00007b00]                           dc.w $0ffe
[00007b02]                           dc.w $7ff0
[00007b04]                           dc.w $0ffe
[00007b06]                           dc.w $7ff0
[00007b08]                           dc.w $0ffe
[00007b0a]                           dc.w $7ff0
[00007b0c]                           dc.w $0ffe
[00007b0e]                           dc.w $7ff0
[00007b10]                           dc.w $0ffe
[00007b12]                           dc.w $7ff0
[00007b14]                           dc.w $0ffe
[00007b16]                           dc.w $7ff0
[00007b18]                           dc.w $0ffe
[00007b1a]                           dc.w $7ff0
[00007b1c]                           dc.w $0ffe
[00007b1e]                           dc.w $7ff0
[00007b20]                           dc.w $0ffe
[00007b22]                           dc.w $7ff0
[00007b24]                           dc.w $0ffe
[00007b26]                           dc.w $7ff0
[00007b28]                           dc.w $0ffe
[00007b2a]                           dc.w $7ff0
[00007b2c]                           dc.w $0ffe
[00007b2e]                           dc.w $7ff0
[00007b30]                           dc.w $0ffe
[00007b32]                           dc.w $7ff0
[00007b34]                           dc.w $0ffe
[00007b36]                           dc.w $7ff0
[00007b38]                           dc.w $0ffe
[00007b3a]                           dc.w $7ff8
[00007b3c]                           dc.w $1ffe
[00007b3e]                           dc.w $7ffc
[00007b40]                           dc.w $3ffe
[00007b42]                           dc.w $7fff
[00007b44]                           dc.w $fffe
[00007b46]                           dc.w $7fff
[00007b48]                           dc.w $fffe
[00007b4a]                           dc.w $7ffc
[00007b4c]                           dc.w $3ffe
[00007b4e]                           dc.w $7ff8
[00007b50]                           dc.w $1ffe
[00007b52]                           dc.w $7ff0
[00007b54]                           dc.w $0ffe
[00007b56]                           dc.w $7ff0
[00007b58]                           dc.w $0ffe
[00007b5a]                           dc.w $7ff0
[00007b5c]                           dc.w $0ffe
[00007b5e]                           dc.w $7ff8
[00007b60]                           dc.w $1ffe
[00007b62]                           dc.w $7ffc
[00007b64]                           dc.w $3ffe
[00007b66]                           dc.w $7fff
[00007b68]                           dc.w $fffe
[00007b6a]                           dc.w $3fff
[00007b6c]                           dc.w $fffc
[00007b6e]                           dc.b $00
[00007b6f]                           dc.b $00
[00007b70]                           dc.b $00
[00007b71]                           dc.b $00
~_396:
[00007b72]                           dc.b $00
[00007b73]                           dc.b $00
[00007b74]                           dc.b $00
[00007b75]                           dc.b $00
[00007b76]                           dc.b $00
[00007b77]                           dc.b $04
[00007b78]                           dc.b $00
[00007b79]                           dc.b $20
[00007b7a]                           dc.b $00
[00007b7b]                           dc.b $00
[00007b7c]                           dc.b $00
[00007b7d]                           dc.b $00
[00007b7e]                           dc.b $00
[00007b7f]                           dc.b $01
~_397:
[00007b80]                           dc.b $00
[00007b81]                           dc.b $00
~_399:
[00007b82]                           dc.b $00
[00007b83]                           dc.b $00
[00007b84]                           dc.b $00
[00007b85]                           dc.b $00
[00007b86]                           dc.b $00
[00007b87]                           dc.b $00
[00007b88]                           dc.b $00
[00007b89]                           dc.b $be
[00007b8a]                           dc.b $00
[00007b8b]                           dc.b $00
[00007b8c]                           dc.w $0530
[00007b8e]                           dc.b $00
[00007b8f]                           dc.b $00
[00007b90]                           dc.w $01be
[00007b92]                           dc.b $00
[00007b93]                           dc.b $00
[00007b94]                           dc.w $0218
~_401:
[00007b96]                           dc.b $00
[00007b97]                           dc.b $00
[00007b98]                           dc.b $00
[00007b99]                           dc.b $00
[00007b9a]                           dc.b $00
[00007b9b]                           dc.b $00
[00007b9c]                           dc.b $00
[00007b9d]                           dc.b $be
[00007b9e]                           dc.b $00
[00007b9f]                           dc.b $00
[00007ba0]                           dc.w $0530
[00007ba2]                           dc.b $00
[00007ba3]                           dc.b $00
[00007ba4]                           dc.w $01be
[00007ba6]                           dc.b $00
[00007ba7]                           dc.b $00
[00007ba8]                           dc.w $0218
~_403:
[00007baa]                           dc.w $ffff
[00007bac]                           dc.b $00
[00007bad]                           dc.b $01
[00007bae]                           dc.b $00
[00007baf]                           dc.b $04
[00007bb0]                           dc.b $00
[00007bb1]                           dc.b $14
[00007bb2]                           dc.b $00
[00007bb3]                           dc.b $00
[00007bb4]                           dc.b $00
[00007bb5]                           dc.b $00
[00007bb6]                           dc.b $00
[00007bb7]                           dc.b $01
[00007bb8]                           dc.w $1110
[00007bba]                           dc.b $00
[00007bbb]                           dc.b $00
[00007bbc]                           dc.b $00
[00007bbd]                           dc.b $00
[00007bbe]                           dc.b $00
[00007bbf]                           dc.b $25
[00007bc0]                           dc.b $00
[00007bc1]                           dc.b $01
[00007bc2]                           dc.b $00
[00007bc3]                           dc.b $02
[00007bc4]                           dc.w $ffff
[00007bc6]                           dc.w $ffff
[00007bc8]                           dc.b $00
[00007bc9]                           dc.b $1b
[00007bca]                           dc.b $00
[00007bcb]                           dc.b $00
[00007bcc]                           dc.b $00
[00007bcd]                           dc.b $00
[00007bce]                           dc.w $0401
[00007bd0]                           dc.w $1101
[00007bd2]                           dc.b $00
[00007bd3]                           dc.b $00
[00007bd4]                           dc.b $00
[00007bd5]                           dc.b $00
[00007bd6]                           dc.b $00
[00007bd7]                           dc.b $04
[00007bd8]                           dc.b $00
[00007bd9]                           dc.b $01
[00007bda]                           dc.b $00
[00007bdb]                           dc.b $04
[00007bdc]                           dc.b $00
[00007bdd]                           dc.b $03
[00007bde]                           dc.b $00
[00007bdf]                           dc.b $03
[00007be0]                           dc.b $00
[00007be1]                           dc.b $14
[00007be2]                           dc.b $00
[00007be3]                           dc.b $00
[00007be4]                           dc.b $00
[00007be5]                           dc.b $00
[00007be6]                           dc.b $00
[00007be7]                           dc.b $01
[00007be8]                           dc.w $1111
[00007bea]                           dc.b $00
[00007beb]                           dc.b $04
[00007bec]                           dc.b $00
[00007bed]                           dc.b $00
[00007bee]                           dc.b $00
[00007bef]                           dc.b $1d
[00007bf0]                           dc.b $00
[00007bf1]                           dc.b $01
[00007bf2]                           dc.b $00
[00007bf3]                           dc.b $02
[00007bf4]                           dc.w $ffff
[00007bf6]                           dc.w $ffff
[00007bf8]                           dc.b $00
[00007bf9]                           dc.b $14
[00007bfa]                           dc.b $00
[00007bfb]                           dc.b $00
[00007bfc]                           dc.b $00
[00007bfd]                           dc.b $00
[00007bfe]                           dc.b $00
[00007bff]                           dc.b $01
[00007c00]                           dc.w $1100
[00007c02]                           dc.b $00
[00007c03]                           dc.b $0b
[00007c04]                           dc.b $00
[00007c05]                           dc.b $00
[00007c06]                           dc.b $00
[00007c07]                           dc.b $06
[00007c08]                           dc.b $00
[00007c09]                           dc.b $01
[00007c0a]                           dc.b $00
[00007c0b]                           dc.b $00
[00007c0c]                           dc.w $ffff
[00007c0e]                           dc.w $ffff
[00007c10]                           dc.b $00
[00007c11]                           dc.b $1b
[00007c12]                           dc.b $00
[00007c13]                           dc.b $20
[00007c14]                           dc.b $00
[00007c15]                           dc.b $00
[00007c16]                           dc.w $0301
[00007c18]                           dc.w $1101
[00007c1a]                           dc.b $00
[00007c1b]                           dc.b $21
[00007c1c]                           dc.b $00
[00007c1d]                           dc.b $00
[00007c1e]                           dc.b $00
[00007c1f]                           dc.b $04
[00007c20]                           dc.b $00
[00007c21]                           dc.b $01
[00007c22]                           dc.b ' %2d',0
[00007c27]                           dc.b $00
;
         u _GemParBlk
         u _AesCtrl
         u v_bar
         u vqt_width
         u vst_unload_fonts
         u vst_rotation
         u vst_point
         u vqt_name
         u vswr_mode
         u vst_load_fonts
         u v_show_c
         u vqt_fontinfo
         u vst_font
         u vrt_cpyfm
         u vst_effects
         u vqt_attributes
         u vst_alignment
         u strcpy
         u v_opnvwk
         u strcat
         u strstr
         u strchr
         u Super
         u wind_update
         u v_pline
         u vsl_udsty
         u strcmp
         u toupper
         u wind_set
         u wind_get
         u vsl_type
         u strlen
         u vro_cpyfm
         u strtok
         u v_justified
         u vsl_color
         u vsf_style
         u vsf_perimeter
         u sprintf
         u v_gtext
         u vsf_interior
         u v_clsvwk
         u v_hide_c
         u strncpy
         u strncmp
         u vsf_color
         u scrp_write
         u scrp_read
         u vq_extnd
         u vr_trnfm
         u vs_clip
         u rsrc_obfix
         u vq_gdos
         u vr_recfl
         u memcpy
         u memset
         u labs
         u realloc
         u Keytbl
         u objc_draw
         u objc_find
         u objc_change
         u objc_offset
         u objc_edit
         u getenv
         u Fsnext
         u free
         u form_dial
         u form_center
         u calloc
         u Fsfirst
         u evnt_button
         u evnt_multi
         u abs
         u Dcreate
         u evnt_keybd
         u Fdelete
         u Fsetdta
         u Fgetdta
         u graf_mouse
         u graf_slidebox
         u graf_mkstate
         u graf_handle
         u Bconout
         u _ldiv
         u _lmul
         u _lmod
         u Blitmode
00000000 t ~_231
00000026 t ~_232
00000040 T ClipFindFile
00000128 T ClipClear
000001be t ~_235
00000248 T MenuSet2ThinLine
00000268 t ~_236
000002ec T MenuTune
0000033a T WindUpdate
000003ae T WindRestoreControl
000003d0 t ~_242
0000042e T DialAlert
00000a02 T DialAnimAlert
00000a2c T DialSuccess
00000a3c t ~_252
00000a7c t ~_253
00000adc t ~_254
00000b04 t ~_255
00000b2c T DialExStart
00000c82 T DialStart
00000c8a T DialEnd
00000d3a T DialMove
00001200 T DialDo
000012e4 T DialDraw
0000130a T DialCenter
00001460 T DialInit
000014f0 T DialExit
00001506 t ~_261
0000153e T FormSetValidator
0000154c t ~_262
000018ae t ~_263
000018e2 t ~_264
0000190a t ~_265
000019cc t ~_266
00001af4 t ~_267
00001b4a t ~_268
00001ba6 t ~_269
00001bbe t ~_270
00001c24 T FormButton
00001ce2 T FormKeybd
00001df2 T FormSetFormKeybd
00001dfa T FormGetFormKeybd
00001e02 T FormDo
00001e12 T FormXDo
00002052 t ~_277
000020bc t ~_278
00002110 t ~_279
00002542 t ~_280
00002588 T JazzSelect
000026c6 T JazzUp
000026de t ~_281
0000275c t ~_282
000027ee t ~_283
000028ce t ~_284
000028ec t ~_285
00002918 t ~_286
00002962 t ~_287
00002a0e T ObjcAnimImage
00002b08 t ~_288
00002ba8 t ~_289
00002be0 t ~_290
00002c72 T ObjcMyButton
00002ff6 t ~_291
000030f0 t ~_292
00003210 T ObjcInit
000032fe T ObjcTreeInit
0000360e T ObjcRemoveTree
000036a0 T ObjcDeepDraw
000036a8 T ObjcGParent
000036fc T ObjcOffset
0000373c T ObjcDraw
00003752 T ObjcXywh
00003784 T ObjcChange
000037a4 T ObjcToggle
000037f6 T ObjcSel
0000381c T ObjcDsel
00003842 T ObjcVStretch
0000388a T ObjcGetObspec
000038c8 T RastSize
0000392e T RastSave
0000398a T RastRestore
000039ee T RastBufCopy
00003a46 T RastDrawRect
00003a90 T RastSetDotStyle
00003acc T RastDotRect
00003b86 t ~_321
00003ba4 T RastTrans
00003bec T RectAES2VDI
00003c08 T RectGRECT2VDI
00003c26 T RectInter
00003c98 T RectGInter
00003d10 T RectOnScreen
00003d6c T RectInside
00003da0 T RectClipWithScreen
00003de8 T HandFast
00003e30 T HandScreenSize
00003e7e T HandInit
00003ea4 T HandClip
00003f1e t ~_338
00004000 t ~_339
00004052 T FontLoad
0000408c T FontUnLoad
000040d0 T FontGetList
000042a6 T FontSetPoint
00004340 T FontIsFSM
00004394 T GrafGetForm
000043b2 T GrafMouse
00004424 T ImQuestionMark
00004450 T ImHand
0000447c T ImInfo
000044a8 T ImFinger
000044d4 T ImBomb
00004500 T ImPrinter
0000452c T ImDrive
00004558 T ImDisk
00004584 T ImExclamation
000045b0 T ImSignQuestion
000045dc T ImSignStop
00004608 T ImSqQuestionMark
00004634 T ImSqExclamation
00004660 T evnt_event
000046b8 T vdi
000046c4 T vst_arbpt
0000471e T vqt_devinfo
00004778 T SlidDraw
00004926 T SlidDrCompleted
0000493a T SlidSlidSize
000049b4 T SlidScale
000049ce T SlidPos
00004a26 T SlidCreate
00004ab2 T SlidDelete
00004aba T SlidExtents
00004b74 T SlidClick
00004d3c T SlidAdjustSlider
00004e10 T SlidDeselect
00004e7e t ~_404
00004ee6 t ~_405
00004f4e t ~_406
00004fb0 t ~_407
00005014 t ~_408
0000508c t ~_409
000050aa t ~_410
000050d6 t ~_411
000050e4 T ListIndex2List
000050f0 t ~_412
00005180 T ListInit
00005470 t ~_413
0000555c T ListWindDraw
00005686 T ListDraw
000057ca t ~_414
000059d0 T ListVScroll
00005b12 T ListHScroll
00005c34 t ~_415
00005d9a t ~_416
00005ec4 T ListUpdateEntry
00005ef0 T ListInvertEntry
00005f24 t ~_417
00005f56 t ~_418
00005f78 T ListMoved
00006078 T ListClick
000065c4 T ListExit
0000660c T ListStdInit
0000665a T ListScroll2Selection
000066ec T ListPgDown
000066fe T ListPgUp
00006712 T ListPgRight
00006722 T ListPgLeft
00006734 T ListLnRight
00006744 T ListLnLeft
00006756 T ListVSlide
0000678e T ListHSlide
000067c8 t ~_419
000068a8 t ~_420
0000699a t ~_421
00006b14 t ~_422
00006c58 T FontShowFont
00006db8 T FontSelectSize
00006e5c T FontSelInit
00006f7e T FontClFont
00007060 T FontClSize
000070b2 T FontSelDraw
000070ec T FontSelExit
00000000 d ~_233
0000000c d ~_234
00000020 d ~_237
00000028 d ~_239
0000002c d ~_243
000000ee d ~_245
000000f2 d ~_256
0000011c d ~_271
0000012a d ~_276
0000012c d ~_293
00000292 d ~_315
00000296 d ~_324
0000029e d ~_326
000002f4 d ~_340
00000314 d ~_341
00000318 d ~_346
000003a8 d ~_350
00000438 d ~_354
000004c8 d ~_358
00000558 d ~_362
000005e8 d ~_366
00000678 d ~_370
00000708 d ~_374
00000798 d ~_378
00000828 d ~_382
000008b8 d ~_386
00000948 d ~_390
000009d8 d ~_394
00000a68 d ~_398
00000a7c d ~_400
00000a90 d ~_402
00000b08 d ~_423
0000713a d ~_238
00007142 d ~_240
00007144 d ~_241
00007146 d ~_244
00007148 D AlertTree
0000720c D DialWk
0000720e d ~_257
00007224 d ~_258
00007236 d ~_272
00007238 d ~_273
0000723c d ~_274
00007240 d ~_275
00007246 d ~_294
00007266 d ~_295
00007286 d ~_296
0000729a d ~_297
000072ae d ~_298
000072be d ~_299
000072ce d ~_300
000072e2 d ~_301
000072f6 d ~_302
00007316 d ~_303
00007326 d ~_304
0000733a d ~_305
0000734e d ~_306
00007366 d ~_307
0000737e d ~_308
00007392 d ~_309
0000739a d ~_310
0000739e d ~_311
000073a2 d ~_312
000073a6 d ~_313
000073aa d ~_314
000073b0 d ~_325
000073b8 d ~_327
00007402 d ~_328
00007404 d ~_329
00007406 d ~_330
00007408 d ~_331
0000740a d ~_332
0000740c d ~_333
0000742e d ~_342
00007430 d ~_343
00007432 d ~_347
000074b2 d ~_348
000074c0 d ~_349
000074c2 d ~_351
00007542 d ~_352
00007550 d ~_353
00007552 d ~_355
000075d2 d ~_356
000075e0 d ~_357
000075e2 d ~_359
00007662 d ~_360
00007670 d ~_361
00007672 d ~_363
000076f2 d ~_364
00007700 d ~_365
00007702 d ~_367
00007782 d ~_368
00007790 d ~_369
00007792 d ~_371
00007812 d ~_372
00007820 d ~_373
00007822 d ~_375
000078a2 d ~_376
000078b0 d ~_377
000078b2 d ~_379
00007932 d ~_380
00007940 d ~_381
00007942 d ~_383
000079c2 d ~_384
000079d0 d ~_385
000079d2 d ~_387
00007a52 d ~_388
00007a60 d ~_389
00007a62 d ~_391
00007ae2 d ~_392
00007af0 d ~_393
00007af2 d ~_395
00007b72 d ~_396
00007b80 d ~_397
00007b82 d ~_399
00007b96 d ~_401
00007baa d ~_403
00000000 b ~_246
00000070 b ~_259
000000ea b ~_316
0000011a b ~_322
0000012e b ~_334
0000013e b ~_344
00007c28 b ~_247
00007c88 b ~_248
00007c92 b ~_249
00007c94 b ~_250
00007c96 b ~_251
00007c98 B dialmalloc
00007c9c B dialfree
00007ca0 b ~_260
00007d12 b ~_317
00007d1e b ~_318
00007d2a b ~_319
00007d2e b ~_320
00007d42 b ~_323
00007d56 B HandAES
00007d58 B HandXSize
00007d5a B HandYSize
00007d5c B HandBXSize
00007d5e B HandBYSize
00007d60 b ~_335
00007d62 b ~_336
00007d64 b ~_337
00007d66 b ~_345
;
