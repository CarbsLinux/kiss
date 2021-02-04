# shellcheck shell=sh

pkgnum() {
    i=0
    cd "$CPT_ROOT/var/db/cpt/installed" || { printf '%s\n' 0; return 1 ;}
    for pkg in ./*; do
        [ -d "$pkg" ] || break
        i=$(( i + 1 ))
    done
    printf '%s\n' "$i"
}

getfirstpkg() {
    cd "$CPT_ROOT/var/db/cpt/installed" || return 1
    for pkg in ./*; do
        [ -d "$pkg" ] || return 1
        printf '%s\n' "${pkg##*/}"
        break
    done
}
