. ./config.rc
redo src/clean
redo_clean
rm -f "cpt-$VERSION.tar.xz"
find docs -name '*.info' -exec rm -f -- {} +
