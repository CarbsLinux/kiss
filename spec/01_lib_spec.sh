# shellcheck disable=2091,2034

Describe 'CPT Library'
    export CPT_COLOR=0
    Include ./src/cpt-lib
    Describe '--help'
        It 'prints usage information when called as a standalone script'
            When run script src/cpt-lib --help
            The word 1 of output should eq "usage:"
        End
    End
    Describe 'version()'
        VERSION=$(sed -n '/VERSION/s/.* //gp' config.mk)
        It 'prints version information'
            When run script src/cpt-lib version
            The stderr should eq "-> Carbs Packaging Tools $VERSION"
        End
    End
    Describe 'text functions'
        Describe 'out()'
            It 'outputs a message with every argument triggering a newline'
                When call out Line1 Line2
                The output should eq "$(printf 'Line1\nLine2\n')"
            End
        End

        Describe 'log()'
            Parameters
                "#1" "-> hello " hello
                "#2" "-> hello world" hello world
                "#3" "hello test world" test world hello
            End
            It "prints a message prettily ($1)"
                When call log "$3" "$4" "$5"
                The stderr should eq "$2"
            End
        End

        Describe 'die()'
            It "exits the script by printing the given message"
                When run script src/cpt-lib die "Exiting"
                The stderr should eq "!> Exiting "
                The status should be failure
            End
        End

        Describe 'warn()'
            Parameters
                "#1" "WARNING notice " "notice"
                "#2" "WARNING package not found" "package" "not found"
                "#3" "!!! package not found" "package" "not found" "!!!"
            End
            It "displays a warning message ($1)"
                When call warn "$3" "$4" "$5"
                The stderr should eq "$2"
            End
        End

        Describe 'contains()'
            Parameters
                "#1" "foo bar" baz failure
                "#2" "foo bar baz" baz success
            End
            It "checks whether the given string list contains a word ($1)"
                When call contains "$2" "$3"
                The status should be "$4"
            End
        End

        Describe 'pop()'
            It "removes the first item from the following items"
                When call pop baz from foo bar baz
                The output should eq " foo  bar "
            End
        End

        Describe 'regesc()'
            Parameters
                "#1" '^[\\test$' '\^\[\\\\test\$'
                "#2" '\.*$' '\\\.\*\$'
            End
            It "escapes POSIX BRE sequences ($1)"
                When call regesc "$2"
                The output should eq "$3"
            End
        End

        Describe 'sepchar()'
            It 'seperates the output of given string'
                When call sepchar test
                The output should eq "$(printf 't\ne\ns\nt\n')"
            End
        End
    End


    Describe 'helper functions'
        Describe '_seq()'
            It 'counts to the given number'
                When call _seq 3
                The output should eq " 1  2  3 "
            End
        End

        Describe '_stat()'
            It 'outputs the owner of the given file'
               When call _stat README
               The output should eq "$(id -un)"
            End
        End

        Describe '_readlinkf()'
            mklink() { :> tests/testfile; ln -s testfile tests/testfile2 ;}
            rmlink() { rm -f tests/testfile tests/testfile2 ;}
            RPWD=$(cd -P .||:; printf %s "$PWD")
            Before mklink
            After  rmlink
            Parameters
                "#1" . "$RPWD"
                "#2" "$PWD/tests/testfile2" "$RPWD/tests/testfile"
            End
            It "outputs the real location of the given file ($1)"
               When call _readlinkf "$2"
               The output should eq "$3"
            End
        End

        Describe 'sh256()'
            It 'outputs an sha256 digest of the given file using any valid system tool'
                # This should cover our bases for a long time.
                When call sh256 .editorconfig
                The output should eq "da42265df733ca05a08d77405c35aa3dd5b8b7fefcc2da915f508067a49351da  .editorconfig"
            End
        End
    End

    Describe 'system functions'
        Describe 'as_root()'
            as_root_env() { user=$1 as_root env ;}
            Parameters
                root
                "$(id -un)"
            End
            It "runs the given command as user: '$1'"
                When call as_root_env "$1"
                The output should not eq ""
                The stderr should not eq ""
                The status should be success
            End
        End
    End

    Describe 'package functions'
        Describe 'run_hook()'
            CPT_HOOK=$PWD/tests/hook-file
            CPT_ROOT=$PWD/tests
            It "runs the given hook file"
                When call run_hook 1 test-package destination
                The stderr should eq "-> test-package Running 1 hook"
                The output should eq "$CPT_HOOK 1 test-package destination"
            End
            It "doesn't log 'running hook' if no package is given"
                When call run_hook 2 '' destination
                The stderr should eq ""
                The output should eq "$CPT_HOOK 2 null destination"
            End
            It "uses the /etc/cpt-hook file of the root when called with a fourth arg"
                When call run_hook 3 cpt destdir root
                The stderr should eq "-> cpt Running 3 hook"
                The output should eq "$CPT_ROOT/etc/cpt-hook 3 cpt destdir"
                The variable CPT_HOOK should eq "$PWD/tests/hook-file"
            End
            It "returns with success even when the file doesn't exist"
                CPT_HOOK=$PWD/some-non-existent-file
                When call run_hook 4 thiswillnotrun
                The variable CPT_HOOK should not be exist
                The stderr should eq ""
                The status should be success
            End
            It "restores the \$CPT_HOOK variable when called with root"
                CPT_ROOT=$PWD/nonexistentdir
                When call run_hook 5 cpt dest root
                The variable CPT_ROOT should not be exist
                The stderr should eq ""
                The status should be success
                The variable CPT_HOOK should eq "$PWD/tests/hook-file"
            End
        End
        Describe 'create_cache()'
            After pkg_clean
            It 'creates cache directories'
                When call create_cache
                The variable mak_dir should be a directory
            End
            It "doesn't create build directories if an argument is passed"
                When call create_cache nobuild
                The variable mak_dir should be undefined
            End
        End
        Describe 'pkg_get_base()'
        CPT_ROOT=$PWD/tests
        CPT_PATH=$PWD/tests/repository
            It 'returns packages defined in base'
                When call pkg_get_base nonl
                The output should eq "dummy-pkg contrib-dummy-pkg "
            End
        End
    End
End
