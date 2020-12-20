. ./config.rc

# Extensionless name of file
fn="${1%.*}"

case "$1" in
    bin/cpt-readlink|bin/cpt-stat)
        redo-ifchange "$1.o"
        "$CC" -o "$3" $LDFLAGS "$1.o" $LIBS
        ;;
    *.o)
        [ -f "${1%.o}.c" ] || exit 99
        redo-ifchange "$fn.c"
        "$CC" -c -o "$3" $CFLAGS "$fn.c"
        ;;
    *.info)
        redo-ifchange "$fn.texi"
        $MAKEINFO "$fn.texi" -o "$3"
        ;;
    *.texi)
        [ -f "$fn.org" ] || exit 99
        redo-ifchange "$fn.org"
        $EMACS "$fn.org" --batch -f org-texinfo-export-to-texinfo
        mv "$1" "$3"
        ;;
    "cpt-$VERSION.tar.xz")
        redo doc/cpt.info
        rm -rf -- "cpt-$VERSION"
        find . -type f ! -name '.*' ! -path './.*' |
            while read -r file; do
                mkdir -p "cpt-$VERSION/${file%/*}"
                cp "$file" "cpt-$VERSION/$file"
            done
        tar cf "cpt-$VERSION.tar" "cpt-$VERSION"
        xz -z "cpt-$VERSION.tar"
        rm -rf -- "cpt-$VERSION"
        mv "$1" "$3"
        ;;
    *)
        echo "Unknown target $1"
        exit 99
esac
