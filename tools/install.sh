#!/bin/sh -e
# Portable install version that supports -D -m and -t
usage() {
    printf '%s\n' "usage: $0 [-D] [-m mode] source dest" \
                  "   or: $0 [-D] [-m mode] [-t dir] [source...]" >&2
    exit 1
}

die() { printf '%s\n' "$@" >&2; exit 1;}

mkdirp=''
target=''
mode=''
REST=''
parse() {
    OPTIND=$(($#+1))
    while OPTARG= && [ $# -gt 0 ]; do
        case $1 in
            -[tm]?*) OPTARG=$1; shift
                     eval 'set -- "${OPTARG%"${OPTARG#??}"}" "${OPTARG#??}"' ${1+'"$@"'}
                     ;;
            -[!-]?*) OPTARG=$1; shift
                     eval 'set -- "${OPTARG%"${OPTARG#??}"}" -"${OPTARG#??}"' ${1+'"$@"'}
                     OPTARG= ;;
        esac
        case $1 in
            '-D')
                [ "${OPTARG:-}" ] && OPTARG=${OPTARG#*\=} && set "noarg" "$1" && break
                eval '[ ${OPTARG+x} ] &&:' && OPTARG='1' || OPTARG=''
                mkdirp="$OPTARG"
                ;;
            '-t')
                [ $# -le 1 ] && set "required" "$1" && break
                OPTARG=$2
                target="$OPTARG"
                shift ;;
            '-m')
                [ $# -le 1 ] && set "required" "$1" && break
                OPTARG=$2
                mode="$OPTARG"
                shift ;;
            '-h'|'--help')
                usage
                exit 0 ;;
            --)
                shift
                while [ $# -gt 0 ]; do
                    REST="${REST} \"\${$((OPTIND-$#))}\""
                    shift
                done
                break ;;
            [-]?*) set "unknown" "$1"; break ;;
            *)
                REST="${REST} \"\${$((OPTIND-$#))}\""
        esac
        shift
    done
    [ $# -eq 0 ] && { OPTIND=1; unset OPTARG; return 0; }
    case $1 in
        unknown) set "Unrecognized option: $2" "$@" ;;
        noarg) set "Does not allow an argument: $2" "$@" ;;
        required) set "Requires an argument: $2" "$@" ;;
        pattern:*) set "Does not match the pattern (${1#*:}): $2" "$@" ;;
        notcmd) set "Not a command: $2" "$@" ;;
        *) set "Validation error ($1): $2" "$@"
    esac
    echo "$1" >&2
    exit 1
}

parse "$@" && eval set -- "$REST"

if [ "$target" ]; then
    [ "$mkdirp" ] || [ -d "$target" ] || die "$target doesn't exist"
    mkdir -p "$target"
    for arg; do
        [ -d "$target/${arg##*/}" ] && die "$target/${arg##*/} is a directory"
        cp "$arg" "$target/${arg##*/}"

        # Most implementations set the mode to 0755 by default when -t is set.
        chmod "${mode:=0755}" "$target/${arg##*/}"
    done
else
    case "$2" in */*) [ "$mkdirp" ] || [ -d "${2%/*}" ] || die "${2%/*} doesn't exist"
                      mkdir -p "${2%/*}"
    esac
    [ -d "$2" ] && die "$2 is a directory"
    cp "$1" "$2"
    chmod "${mode:=0755}" "$2"
fi
