# Carbs Packaging Tools
VERSION = 6.0.0

# Installation paths
PREFIX    = /usr/local
BINDIR    = ${PREFIX}/bin
SHAREDIR  = ${PREFIX}/share
INFODIR   = ${SHAREDIR}/info
DOCDIR    = ${SHAREDIR}/doc
CPTDOC    = ${DOCDIR}/cpt
MANPREFIX = ${SHAREDIR}/man
MAN1      = ${MANPREFIX}/man1

EMACS     = emacs
MAKEINFO  = makeinfo

# Comment or change if you don't want to build/install the documentation
DOCS = yes

# Files to be added into the distribution tarball
DISTFILES = contrib docs man spec src tests tools \
            .dir-locals.el CHANGELOG.md LICENSE \
            Makefile README config.mk cpt-base
