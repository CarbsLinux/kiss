# Carbs Packaging Tools Documentation
include ../config.mk
INSTALL_SH = ../tools/install.sh

all: cpt.txt cpt.texi cpt.info

.SUFFIXES: .info .texi .org .txt
.org.texi:
	rm -f $@
	${EMACS} $< --batch --eval "(require 'vc)" -f org-texinfo-export-to-texinfo

.texi.info:
	${MAKEINFO} $< -o $@

.org.txt:
	rm -f $@
	${EMACS} $< --batch --eval "(require 'vc)" -f org-ascii-export-to-ascii

clean:
	rm -f cpt.info

all-clean: clean
	rm -f cpt.texi cpt.txt

install: all
	${INSTALL_SH} -Dm644 cpt.txt ${DESTDIR}${CPTDOC}/cpt.txt
	${INSTALL_SH} -Dm644 cpt.info ${DESTDIR}${INFODIR}/cpt.info

uninstall:
	rm -rf ${DESTDIR}${CPTDOC}
	rm -f  ${DESTDIR}${INFODIR}/cpt.info

.PHONY: all clean all-clean install uninstall
