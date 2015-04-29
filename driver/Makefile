# $FreeBSD$

KMOD=	if_iwm
SRCS=	if_iwm.c device_if.h bus_if.h pci_if.h

.include <bsd.kmod.mk>
CFLAGS+= -ferror-limit=10000 -Wno-error=unused-variable
