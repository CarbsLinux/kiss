Describe 'contrib scripts'
    export PATH=$PWD/src:$PWD/contrib:$PATH
    export CPT_ROOT=$PWD/tests/03
    export CPT_PATH=$PWD/tests/repository
    export CPT_COMPRESS=''
    install_tmp() {
        CPT_HOOK='' ./src/cpt b -y contrib-dummy-pkg >/dev/null 2>&1
        CPT_HOOK='' ./src/cpt-install -y contrib-dummy-pkg >/dev/null 2>&1
        mkdir -p "$CPT_ROOT/tmp"
    }
    remove_tmp() { rm -rf "${CPT_ROOT:?}/var" "$CPT_ROOT/tmp" ;}
    BeforeAll install_tmp
    AfterAll remove_tmp

    Describe 'cpt-cat'
        firstpkg=$(getfirstpkg)
        It 'outputs the file contents in the given package directory'
            When run script ./contrib/cpt-cat "$firstpkg"
            The stdout should not eq ""
            The line 1 of stderr should eq "$(printf '\033[1mbuild:\033[m\n')"
        End
        It "uses the current directory for the package name if none is supplied (contrib-dummy-pkg)"
            cd "$CPT_PATH/contrib-dummy-pkg" || return 1
            When run script "$(command -v cpt-cat)"
            The stdout should not eq ""
            The line 1 of stderr should eq "$(printf '\033[1mbuild:\033[m\n')"
        End
        It "exits with error if the package isn't installed"
            When run script ./contrib/cpt-cat somerandompackage
            The stderr should eq "-> somerandompackage not installed"
            The status should be failure
        End
        It "prints usage information when called with --help"
            When run script ./contrib/cpt-cat --help
            The word 1 of stdout should eq "usage:"
            The status should be success
        End
        Parameters
            build
            checksums
            manifest
            version
        End
        It "outputs the given file contents in the given package directory ($1)"
            When run script ./contrib/cpt-cat "$firstpkg" "$1"
            The stdout should eq "$(cat "$CPT_ROOT/var/db/cpt/installed/$firstpkg/$1")"
            The stderr should eq "$(printf '\033[1m%s:\033[m\n' "$1")"
        End
        It "outputs the given file contents for the name of the current directory (contrib-dummy-pkg - $1)"
            cd "$CPT_PATH/contrib-dummy-pkg" || return 1
            When run script "$(command -v cpt-cat)" "" "$1"
            The stdout should eq "$(cat "$CPT_ROOT/var/db/cpt/installed/${PWD##*/}/$1")"
            The stderr should eq "$(printf '\033[1m%s:\033[m\n' "$1")"
        End
    End
    Describe 'cpt-depends'
        firstpkg=$(getfirstpkg)
        It "outputs the dependencies of the given package"
            When run script ./contrib/cpt-depends "$firstpkg"
            The stdout should eq "$(cat "$CPT_ROOT/var/db/cpt/installed/$firstpkg/depends" 2>/dev/null ||:)"
            The status should be success
        End
        It "uses the current directory for the package name if none is supplied (contrib-dummy-pkg)"
            cd "$CPT_PATH/contrib-dummy-pkg" || return 1
            When run script "$(command -v cpt-depends)"
            The stdout should eq "$(cat "$CPT_ROOT/var/db/cpt/installed/contrib-dummy-pkg/depends" 2>/dev/null ||:)"
            The status should be success
        End
        It "prints usage information when called with --help"
            When run script ./contrib/cpt-depends --help
            The word 1 of stdout should eq usage:
        End
    End
    Describe 'cpt-export'
        chtmp() { cd "$CPT_ROOT/tmp" || return 1 ;}
        cleanpkg() { rm -f "$CPT_PATH/contrib-dummy-pkg/contrib-dummy-pkg#1-1.tar.gz" ;}
        Before chtmp
        AfterAll cleanpkg
        firstpkg=$(getfirstpkg)
        It "exports a tarball of the given package"
            When run script "$(command -v cpt-export)" contrib-dummy-pkg
            The stdout should eq "tarball created in $CPT_ROOT/tmp/contrib-dummy-pkg#1-1.tar.gz"
        End
        It "exports the package of the current directory when called without arguments"
            cd "$CPT_PATH/contrib-dummy-pkg" || return 1
            When run script "$(command -v cpt-export)"
            The stdout should eq "tarball created in $CPT_PATH/contrib-dummy-pkg/contrib-dummy-pkg#1-1.tar.gz"
        End
        It "prints usage information when called with --help"
            When run script "$(command -v cpt-export)" --help
            The word 1 of stdout should eq usage:
        End
        It "fallbacks to gz when CPT_COMPRESS has a typo"
            export CPT_COMPRESS=typo
            When run script "$(command -v cpt-export)" contrib-dummy-pkg
            The stdout should eq "tarball created in $CPT_ROOT/tmp/contrib-dummy-pkg#1-1.tar.gz"
        End
        Parameters
            bz2 bzip2
            gz  gzip
            xz  xz
            zst zstd
        End
        Mock bzip2
            cat
        End
        Mock gzip
            cat
        End
        Mock xz
            cat
        End
        Mock zstd
            cat
        End
        It "uses the given CPT_COMPRESS value ($1)"
            export "CPT_COMPRESS=$1"
            When run script "$(command -v cpt-export)" contrib-dummy-pkg
            The stdout should eq "tarball created in $CPT_ROOT/tmp/contrib-dummy-pkg#1-1.tar.$1"
        End
    End
End
