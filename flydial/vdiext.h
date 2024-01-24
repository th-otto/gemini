#if !defined(__PORTVDI_H__) && !defined(_GEMLIB_H_) && (defined(__TURBOC__))

#ifndef __VDIPB
#define __VDIPB
typedef struct
{
    int    *contrl;
    int    *intin;
    int    *ptsin;
    int    *intout;
    int    *ptsout;
} VDIPB;
#endif

void cdecl vdi(VDIPB *pb);
#endif
