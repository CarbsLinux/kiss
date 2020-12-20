. ../config.rc
redo all
exec >&2

./cpt-readlink .
./cpt-readlink ..
./cpt-readlink /bin
./cpt-stat /bin
./cpt-stat cpt-readlink.o

PHONY
