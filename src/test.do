. ../config.rc
redo-ifchange cpt-lib
exec >&2
find . ../contrib -name 'cpt-*' ! -name '*.*' -exec shellcheck -x -f gcc {} +
PHONY
