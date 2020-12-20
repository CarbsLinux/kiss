# See LICENSE for copyright information
VERSION = 5.1.1

# Paths
PREFIX    = /usr/local
BINDIR    = ${PREFIX}/bin
SHAREDIR  = ${PREFIX}/share
DOCDIR    = ${SHAREDIR}/doc
CPTDOC    = ${DOCDIR}/cpt
MANPREFIX = ${SHAREDIR}/man
MAN1      = ${MANPREFIX}/man1

# Flags
CFLAGS  = -std=c99 -Wpedantic -Wall -Os
CFLAGS += -D_XOPEN_SOURCE=700
LDFLAGS = -s -static
LIBS    = -lc

# C compiler and linker
CC = cc
LD = ${CC}

# Documentation tools
EMACS = emacs
MAKEINFO = makeinfo
