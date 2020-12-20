. ../config.rc

# Extensionless name of file
fn="${1%.*}"

case "$1" in
    all)  redo-ifchange info ;;
    info) redo-ifchange cpt.info ;;
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
    *)
        echo "Unknown target $1"
        exit 99
esac

PHONY all info html
