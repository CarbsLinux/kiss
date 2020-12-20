. ./config.rc
redo bin/clean
redo_clean
rm -f "cpt-$VERSION.tar.xz"
find doc -name '*.info' -exec rm -f -- {} +
