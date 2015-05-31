# $FreeBSD$

KMOD=	if_iwm
SRCS=	if_iwm.c if_iwm_pcie_trans.c

SRCS+=	device_if.h bus_if.h pci_if.h opt_wlan.h

CFLAGS+= -DIWM_DEBUG
DEBUG=-g
DEBUG_FLAGS=-g

.include <bsd.kmod.mk>
