/*
	@(#)FlyDial/evntevnt.c
	@(#)Julian F. Reschke, 30. M„rz 1991

	bitte aufmerksam den GEN-File durchlesen!

	Reconstructed from flydial.lib of gemini, Jan 2024, Th. Otto
*/

#include "flydial.h"
#include "evntevnt.h"
#include <string.h>

/******************************************************************************/
/*** ---------------------------------------------------------------------- ***/
/******************************************************************************/

#if defined(__PORTAES_H__)

/*
 * using new library
 */
int evnt_event(MEVENT *event)
{
	memcpy(_AesParBlk.intin, &event->e_flags, 14 * sizeof(_AesParBlk.intin[0]));
	_AesParBlk.addrin[0] = event->e_mepbuf;
	_AesParBlk.intin[14] = (int)(event->e_time & 0xffff);
	_AesParBlk.intin[15] = (int)(event->e_time >> 16);
	_AesParBlk.control[0] = 25;
	_AesParBlk.control[1] = 16;
	_AesParBlk.control[2] = 7;
	_AesParBlk.control[3] = 1;
	_AesParBlk.control[4] = 0;
	_AesParBlk.control[5] = 0;
	aes(&_AesParBlk);
	memcpy(&event->e_mx, &_AesParBlk.intout[1], 6 * sizeof(_AesParBlk.intout[0]));
	return _AesParBlk.intout[0];
}

#elif defined(__AES__) && defined(AP_TERM)
/*
 * using original Pure-C library
 */

extern AESPB AES_pb;

int evnt_event(MEVENT *event)
{
	memcpy(AES_pb.intin, &event->e_flags, 14 * sizeof(AES_pb.intin[0]));
	AES_pb.addrin[0] = event->e_mepbuf;
	AES_pb.intin[14] = (int)(event->e_time & 0xffff);
	AES_pb.intin[15] = (int)(event->e_time >> 16);
	AES_pb.control[0] = 25;
	AES_pb.control[1] = 16;
	AES_pb.control[2] = 7;
	AES_pb.control[3] = 1;
	AES_pb.control[4] = 0;
	AES_pb.control[5] = 0;
	_crystal(&AES_pb);
	memcpy(&event->e_mx, &AES_pb.intout[1], 6 * sizeof(AES_pb.intout[0]));
	return AES_pb.intout[0];
}

#elif defined(__AES__) && !defined(AP_TERM)
/*
 * using old Turbo-C library
 */
void _AesCtrl(int);

int evnt_event(MEVENT *event)
{
	memcpy(_GemParBlk.intin, &event->e_flags, 14 * sizeof(_GemParBlk.intin[0]));
	_GemParBlk.addrin[0] = event->e_mepbuf;
	_GemParBlk.intin[14] = (int)(event->e_time & 0xffff);
	_GemParBlk.intin[15] = (int)(event->e_time >> 16);
	_AesCtrl(25);
	memcpy(&event->e_mx, &_GemParBlk.intout[1], 6 * sizeof(_GemParBlk.intout[0]));
	return _GemParBlk.intout[0];
}

#else
/*
 * using some other library
 */

int evnt_event(MEVENT *event)
{
	return evnt_multi(
		event->e_flags, event->e_bclk, event->e_bmsk, event->e_bst,
		event->e_m1flags, event->e_m1.g_x, event->e_m1.g_y, event->e_m1.g_w, event->e_m1.g_h,
		event->e_m2flags, event->e_m2.g_x, event->e_m2.g_y, event->e_m2.g_w, event->e_m2.g_h,
		event->e_mepbuf,
		event->e_time,
		&event->e_mx, &event->e_my, &event->e_mb, &event->e_ks, &event->e_kr, &event->e_br);
}

#endif
