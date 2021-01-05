Describe 'contrib scripts'
    no_db_dir() {
        # Return 0 if database directory is empty (or doesn't exist)
        # shellcheck disable=2012
        count=$(ls -1 "$CPT_ROOT/var/db/cpt/installed" 2>/dev/null | wc -l)
        [ "$count" -eq 0 ]
    }
    Skip if "there are no installed packages" no_db_dir

    for firstpkg in "$CPT_ROOT/var/db/cpt/installed/"*; do
        firstpkg=${firstpkg##*/}; break
    done

    Describe 'cpt-cat'
        It 'outputs the file contents in the given package directory'
            When run script ./contrib/cpt-cat "$firstpkg"
            The stdout should not eq ""
            The line 1 of stderr should eq "$(printf '\033[1mbuild:\033[m\n')"
        End
        It "uses the current directory for the package name if none is supplied (${PWD##*/})"
            When run script ./contrib/cpt-cat
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
        It "outputs the given file contents for the name of the current directory (${PWD##*/} - $1)"
            When run script ./contrib/cpt-cat "" "$1"
            The stdout should eq "$(cat "$CPT_ROOT/var/db/cpt/installed/${PWD##*/}/$1")"
            The stderr should eq "$(printf '\033[1m%s:\033[m\n' "$1")"
        End
    End
    Describe 'cpt-depends'
        It "outputs the dependencies of the given package"
            When run script ./contrib/cpt-depends "$firstpkg"
            The status should be success
        End
        It "uses the current directory for the package name if none is supplied (${PWD##*/})"
            When run script ./contrib/cpt-depends
            The stdout should eq "$(cat "$CPT_ROOT/var/db/cpt/installed/${PWD##*/}/depends" 2>/dev/null ||:)"
            The status should be success
        End
        It "prints usage information when called with --help"
            When run script ./contrib/cpt-depends --help
            The word 1 of stdout should eq usage:
        End
    End
End
