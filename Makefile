# Carbs Packaging Tools
include config.mk

INSTALL_SH = ./tools/install.sh
BIN    = `find contrib src -name 'cpt*' ! -name '*.*'`
LIB        = src/cpt-lib
LIB_IN     = ${LIB:=.in}

all: src/cpt-lib
	test "${DOCS}" != yes || ${MAKE} -C docs all

src/cpt-lib: src/cpt-lib.in
	sed -e "s|@VERSION@|${VERSION}|g" \
		-e "s|@DOCSTRING@|Call functions from the library|g" < src/cpt-lib.in > $@
	chmod 755 $@

test: all
	shellspec
	cd src; find . ../contrib -name 'cpt*' ! -name '*.*' -exec shellcheck -e 2119 -x -f gcc {} +

dist: docs/cpt.info
	mkdir "cpt-${VERSION}"
	cp -r ${DISTFILES} "cpt-${VERSION}"
	tar cf "cpt-${VERSION}.tar" "cpt-${VERSION}"
	xz -z "cpt-${VERSION}.tar"
	rm -rf -- "cpt-${VERSION}"

install: all
	test "${DOCS}" != yes || ${MAKE} -C docs install
	${INSTALL_SH} -Dm755 -t ${DESTDIR}${BINDIR} ${BIN}
	${INSTALL_SH} -Dm644 -t ${DESTDIR}${MAN1} man/*.1

uninstall:
	test "${DOCS}" != yes || ${MAKE} -C docs uninstall
	for bin in ${BIN}; do \
		rm -f ${DESTDIR}${BINDIR}/$${bin##*/}; done
	for man in man/*.1; do rm -f ${DESTDIR}${MAN1}/$${man##*/}; done

clean:
	test "${DOCS}" != yes || ${MAKE} -C docs clean
	rm -rf src/cpt-lib "cpt-${VERSION}.tar.xz" coverage report

.PHONY: all dist clean install uninstall
