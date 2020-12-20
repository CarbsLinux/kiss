. ./config.rc

# Extensionless name of file
fn="${1%.*}"

case "$1" in
    all) redo-ifchange src/cpt-lib bin/all docs/cpt.info ;;
    dist)
        redo clean
        redo "cpt-$VERSION.tar.xz"
        ;;
    src/cpt-lib)
        redo-ifchange "$1.in"
        sed "s|@VERSION@|$VERSION|g" < "$1.in" > "$3"
        ;;
    bin/cpt-readlink|bin/cpt-stat)
        redo-ifchange "$1.o"
        "$CC" -o "$3" $LDFLAGS "$1.o" $LIBS
        ;;
    *.o)
        [ -f "${1%.o}.c" ] || exit 99
        redo-ifchange "$fn.c"
        "$CC" -c -o "$3" $CFLAGS "$fn.c"
        ;;
    "cpt-$VERSION.tar.xz")
        redo docs/cpt.info
        rm -rf -- "cpt-$VERSION"
        mkdir -p "cpt-$VERSION"
        { git ls-tree -r HEAD --name-only && echo docs/cpt.info ;} |
            while read -r file; do
                [ "${file##*/*}" ] ||
                    mkdir -p "cpt-$VERSION/${file%/*}"
                cp "$file" "cpt-$VERSION/$file"
            done
        tar cf "cpt-$VERSION.tar" "cpt-$VERSION"
        xz -z "cpt-$VERSION.tar"
        rm -rf -- "cpt-$VERSION"
        mv "$1" "$3"
        ;;
    test)
        redo src/test bin/test
        ;;
    src/clean)
        rm -f src/cpt-lib
        PHONY
        ;;
    *)
        echo "Unknown target $1"
        exit 99
esac
