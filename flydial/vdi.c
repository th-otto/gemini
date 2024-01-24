#include "flydial.h"
#include "vdiext.h"

/*
 * only needed for old Turbo-C library
 */

#if !defined(__PORTVDI_H__) && !defined(_GEMLIB_H_) && (defined(__TURBOC__))

static void vdi1(void) 0x222f; /* move.l     4(a7),d1 */
static void vdi2(void) 0x0004;
static void vdi3(void) 0x303c; /* move.w     #$0073,d0 */
static void vdi4(void) 0x0073;
static void vdi5(void) 0x4e42; /* trap       #2 */
static void vdi6(void) 0x4e75; /* rts */


void cdecl vdi(VDIPB *pb)
{
	/* BUG: does not preserve A2, which might be trashed by call */
	(void)pb;
	vdi1();
	vdi2();
	vdi3();
	vdi4();
	vdi5();
}

#endif
