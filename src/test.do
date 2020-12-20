. ../config.rc
redo-ifchange cpt-lib
shellcheck -x -f gcc ./cpt* ../contrib/*
PHONY
