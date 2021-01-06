Describe 'Main toolchain'
    export PATH=$PWD/src:$PATH
    export CPT_ROOT=$PWD/tests
    export CPT_PATH=$PWD/tests/repository
    install_dummy() { CPT_HOOK='' ./src/cpt bi dummy-pkg >/dev/null 2>&1 ;}
    remove_dummy() { rm -rf "${CPT_ROOT:?}/var" ;}
    BeforeAll install_dummy
    AfterAll  remove_dummy

    Describe 'cpt'

        Describe '--version'
            VERSION=$(grep VERSION config.rc | sed 's/.* //g')
            It 'outputs cpt version'
                When run script src/cpt --version
                The stderr should eq "-> Carbs Packaging Tools $VERSION"
            End
        End

        Describe '--help'
            It 'outputs usage information'
                When run script src/cpt --help
                The line 1 of stderr should eq "-> Carbs Packaging Tool "
            End
        End

        Describe 'prefix completion'
            Describe 'single key expansion'
                Parameters
                    a alternatives
                    b build
                    c checksum
                    d download
                    i install
                    l list
                    r remove
                    s search
                    u update
                End
                It "completes '$1' single key prefix to '$2'"
                    When run script src/cpt "$1" --help
                    The status should eq 0
                    The word 1 of line 1 should eq "usage:"
                    The word 2 of line 1 should eq "cpt-$2"
                End
            End
            Describe 'shortcut expansion'
                Parameters
                    bi "build install"
                    cbi "checksum build install"
                End
                It "expands the '$1' shortcut to '$2'"
                    When run script src/cpt "$1" --help
                    The status should be success
                    The word 2 of line 1 should eq "cpt-${2%% *}"
                End
            End
        End


        It 'fails when a given subcommand is not valid'
            When run script src/cpt somerandomcommand
            The stderr should eq "!> 'cpt somerandomcommand' is not a valid command "
            The status should be failure
        End
    End

   Describe 'cpt-list'
       no_db_dir() {
           # Return 0 if database directory is empty (or doesn't exist)
           # shellcheck disable=2012
           count=$(ls -1 "$CPT_ROOT/var/db/cpt/installed" 2>/dev/null | wc -l)
           [ "$count" -eq 0 ]
       }
       Skip if "there are no installed packages" no_db_dir
       It 'lists all packages when called without arguments'
           When run script src/cpt-list
           The lines of output should eq "$(ls -1 "$CPT_ROOT/var/db/cpt/installed" 2>/dev/null | wc -l)"
       End
           for firstpkg in "$CPT_ROOT/var/db/cpt/installed/"*; do firstpkg=${firstpkg##*/}; break; done
       It 'only lists the packages given in the arguments'
           When run script src/cpt-list "$firstpkg"
           The word 1 of stdout should eq "$firstpkg"
       End
       It 'fails when the package supplied in the arguments does not exist'
           When run script src/cpt-list somerandompackage
           The stderr should eq "-> somerandompackage not installed"
           The status should be failure
       End
       Parameters
           "$firstpkg" success
           somerandompackage failure
       End
       It "can print a $2 message with 'cpt-list --check PKG TRUE FALSE'"
           When run script src/cpt-list --check "$1" success failure
           The output should eq "$2"
       End
   End
End
