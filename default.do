. ./config.rc

case "$1" in
    all) redo-ifchange src/cpt-lib docs/all ;;
    dist)
        redo clean
        redo "cpt-$VERSION.tar.xz"
        ;;
    src/cpt-lib)
        redo-ifchange "$1.in"
        sed -e "s|@VERSION@|$VERSION|g" \
            -e "s|@DOCSTRING@|Call functions from the library|g" < "$1.in" > "$3"
        chmod +x "$3"
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
        redo src/test
        ;;
    src/clean)
        rm -f src/cpt-lib
        PHONY
        ;;
    *)
        echo "Unknown target $1"
        exit 99
esac
