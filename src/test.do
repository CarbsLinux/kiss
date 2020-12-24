SRC_ROOT=..
. ${SRC_ROOT}/config.rc

redo-ifchange cpt-lib
exec >&2
find . ../contrib -name 'cpt-*' ! -name '*.*' -exec shellcheck -e 2119 -x -f gcc {} +
PHONY
