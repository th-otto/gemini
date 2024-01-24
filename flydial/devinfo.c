#include "flydial.h"
#include "vdiext.h"

/*
 * only needed for old Turbo-C library
 */

#if !defined(__PORTVDI_H__) && !defined(_GEMLIB_H_) && (defined(__TURBOC__))

static VDIPB vdipb = { _GemParBlk.contrl, _GemParBlk.intin, _GemParBlk.ptsin, _GemParBlk.intout, _GemParBlk.ptsout };

void vqt_devinfo(int handle, int devnum, int *devexists, char *devstr)
{
	int i;
	
	_GemParBlk.contrl[6] = handle;
	_GemParBlk.intin[0] = devnum;
	_GemParBlk.contrl[0] = 248;
	_GemParBlk.contrl[1] = 0;
	_GemParBlk.contrl[3] = 1;
	vdi(&vdipb);
	*devexists = _GemParBlk.ptsout[0];
	if (*devexists)
	{
		for (i = 0; i <= _GemParBlk.contrl[4]; i++)
			devstr[i] = _GemParBlk.intout[i];
	}
}

#endif
