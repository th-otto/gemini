/*
	@(#)FlyDial/rast.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"

static MFDB screen_mfdb;

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

unsigned long RastSize(int w, int h, MFDB *TheBuf)
{
	int workout[57];
	int wd;
	
	vq_extnd(DialWk, 1, workout);
	wd = (w + 15) >> 4; /* BUG: signed shift */
	screen_mfdb.fd_addr = NULL;
	TheBuf->fd_w = w;
	TheBuf->fd_h = h;
	TheBuf->fd_wdwidth = wd;
	TheBuf->fd_nplanes = workout[4];
	TheBuf->fd_stand = 0;
	return h * ((long)wd * 2) * workout[4];
}

/*** ---------------------------------------------------------------------- ***/

void RastSave(int x, int y, int w, int h, int dx, int dy, MFDB *TheBuf)
{
	int pxy[8];
	
	RectAES2VDI(x, y, w, h, &pxy[0]);
	RectAES2VDI(dx, dy, w, h, &pxy[4]);
	vro_cpyfm(DialWk, S_ONLY, pxy, &screen_mfdb, TheBuf);
}

/*** ---------------------------------------------------------------------- ***/

void RastRestore(int x, int y, int w, int h, int sx, int sy, MFDB *TheBuf)
{
	int pxy[8];
	
	RectAES2VDI(sx, sy, w, h, &pxy[0]);
	RectAES2VDI(x, y, w, h, &pxy[4]);
	vro_cpyfm(DialWk, S_ONLY, pxy, TheBuf, &screen_mfdb);
}

/*** ---------------------------------------------------------------------- ***/

void RastBufCopy(int sx, int sy, int w, int h, int dx, int dy, MFDB *TheBuf)
{
	int pxy[8];
	
	RectAES2VDI(sx, sy, w, h, &pxy[0]);
	RectAES2VDI(dx, dy, w, h, &pxy[4]);
	vro_cpyfm(DialWk, S_ONLY, pxy, TheBuf, TheBuf);
}

/*** ---------------------------------------------------------------------- ***/

void RastDrawRect(int ha, int x, int y, int w, int h)
{
	int pxy[10];
	int *p = pxy;
	int x2 = x + w - 1;
	int y2 = y + h - 1;
	
	*p++ = x;
	*p++ = y;
	*p++ = x;
	*p++ = y2;
	*p++ = x2;
	*p++ = y2;
	*p++ = x2;
	*p++ = y;
	*p++ = x + 1;
	*p = y;
	v_pline(ha, 5, pxy);
}

/*** ---------------------------------------------------------------------- ***/

void RastSetDotStyle(int handle, int *xy)
{
	int mask;
	
	mask = 0xaaaa;
	if ((xy[0] + xy[1]) & 1)
		mask = 0x5555;
	if (xy[0] == xy[2] || !(xy[0] & 1))
		mask ^= 0xffff;
	vsl_udsty(handle, mask);
	/* FIXME: should also do vsl_type(handle, USERLINE); */
}

/*** ---------------------------------------------------------------------- ***/

void RastDotRect(int handle, int x, int y, int w, int h)
{
	int pxy[4];
	
	vsl_type(handle, USERLINE);
	pxy[0] = x;
	pxy[1] = y;
	pxy[2] = x + w - 1;
	pxy[3] = y;
	RastSetDotStyle(handle, pxy);
	v_pline(handle, 2, pxy);
	pxy[1] += h - 1;
	pxy[3] = pxy[1];
	RastSetDotStyle(handle, pxy);
	v_pline(handle, 2, pxy);
	pxy[0] = pxy[2];
	pxy[1] = y + 1;
	pxy[3] = y + h - 2; /* BUG */
	RastSetDotStyle(handle, pxy);
	v_pline(handle, 2, pxy);
	pxy[2] = x;
	pxy[0] = x;
	RastSetDotStyle(handle, pxy);
	v_pline(handle, 2, pxy);
	vsl_type(handle, SOLID);
}

/*** ---------------------------------------------------------------------- ***/

static void init_mfdb(MFDB *fdb, void *addr, int wb, int h)
{
	fdb->fd_wdwidth = wb >> 1; /* BUG: must be rounded up */
	fdb->fd_w = wb << 3;
	fdb->fd_h = h;
	fdb->fd_nplanes = 1;
	fdb->fd_addr = addr;
}

/*** ---------------------------------------------------------------------- ***/

void RastTrans(void *saddr, int swb, int h, int handle)
{
	MFDB src;
	MFDB dst;
	
	init_mfdb(&src, saddr, swb, h);
	src.fd_stand = 1;
	init_mfdb(&dst, saddr, swb, h);
	dst.fd_stand = 0;
	vr_trnfm(handle, &src, &dst);
}
