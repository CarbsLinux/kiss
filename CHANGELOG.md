CHANGELOG
================================================================================

This is the CHANGELOG for the Carbs Packaging Tools, initially a customized fork
of the `kiss` package manager. The format is based on [Keep a Changelog], and
this project _somewhat_ adheres to [Semantic Versioning].

[Keep a Changelog]:    https://keepachangelog.com/en/1.0.0/
[Semantic Versioning]: https://semver.org/spec/v2.0.0.html


5.1.2 - 2021-01-04
--------------------------------------------------------------------------------

### Fixed
- Fixed the `Makefile` installing files other than `cpt-*` files.
- Fixed `pkg_swap()` bug where swapping a prefix file would change the following
  file locations on the manifest as well.


5.1.1 - 2020-12-20
--------------------------------------------------------------------------------

### Fixed
- Fixed an issue where the package build is continued even when it failed when
  `$CPT_DEBUG` was set


5.1.0 - 2020-11-25
--------------------------------------------------------------------------------

### IMPORTANT
- The `pkg_fixdeps()` function has been renmaed to `pkg_fix_deps()`.
- `cpt-lib` now parses options for you if `parser_definition()` is defined
  before being called.

### Changed
- `cpt-fork` can now take full path for packages.
- `cpt-size` can now display the total size of multiple packages.
- Updated `getoptions()` parser to version `2.0.1`
- Added `git` to the default `cpt-base`.
- Temporary cache creation scheme is changed from `build-$pid/` to
  `proc/$pid/build/`

### Fixed
- Moved option parsing to cpt-lib if `parser_definition` exists. This shouldn't
  affect existing scripts where `cpt-lib` is called before the `p


5.0.0 - 2020-10-06
--------------------------------------------------------------------------------

### IMPORTANT
- `cpt-fetch` has been removed. `cpt-update -o` can be used instead.

### Added
- Added an `/etc/cpt-base` file to define a base. It can be used in order to
  ship a default base, but to make it redefinable by the user. This file isn't
  installed by default, it serves as a template.
- Added `cpt-orphans` to view orphaned packages. This tool uses `/etc/cpt-base`
  and doesn't output any packages in the defined base.
- Added a `global_options()` function in order to add into the option parser.
- Added `cpt-update -o` flag to replace the functionality of `cpt-fetch`.
- Added `cpt-list -c` to use the current directory as the argument string.

### Changed
- `pkg_build()` now notifies the user if the build file was modified inside a
  hook (the `pre-build` hook to be precise).
- In git repository sources, `@` can now be used to specify tags.
  E.g. `git+git://git.carbslinux.org/cpt@4.2.0`
- `cpt-fork` now removes `manifest` and `etcsums` files.
- `cpt-fork` can now be used to fork multiple packages.
- `cpt-reset` now uses `/etc/cpt-base` when removing packages.
- `cpt-build` now exports the `CPT_TEST` variable, so some tests that can't be
  done in a `test` script can be done from the build itself.


4.1.1 - 2020-09-25
--------------------------------------------------------------------------------

### Changed
- Git clones now fetch tags if commits are specified. This makes the operation
  longer, but not as long as cloning the whole repository while building a
  package.
- `pkg_fixdeps()` now outputs to `stderr` instead of `/dev/tty`. You can now
  have fully silent builds.

### Fixed
- Fixed the `as_root()` function when using `su`.


4.1.0 - 2020-09-11
--------------------------------------------------------------------------------

### Added
- Added `bi` action to cpt for building and installing packages at the same time

### Fixed
- Fixed `as_root()` call on `cpt-chbuild`.


4.0.1 - 2020-09-10
--------------------------------------------------------------------------------

### Fixed
- Fixed flags starting with `--no-`


4.0.0 - 2020-09-09
--------------------------------------------------------------------------------

With this update, all the documentation was moved to the `docs` repository,
which can be accessed from the following sources:

- [Docs Repository](https://github.com/carbslinux/docs)
- [Online User Manual](https://carbslinux.org/docs)
- `carbs-docs` package

### Added
- Added the ability to test packages using a new executable file `test`.
- Added `$CPT_TEST` variable for testing packages.
- Added `--test|-t` option to build.
- Added support for `mercurial` repositories.
- Added options to install the tools "static" so they don't depend on cpt-lib.
- Added basic unit tests. See `make test`.

### Changed
- Most contrib scripts now use the current directory as the package name.

### Removed
- Removed the `docs/` folder.

### Fixed
- Fixed `getoptions` parsers while declaring initial variables.
- Fixed build `cpt-stat` on the Makefile.

3.3.1 - 2020-08-31
--------------------------------------------------------------------------------

### Changed
- Reverted `sh256()` to the previous way.


3.3.0 - 2020-08-31
--------------------------------------------------------------------------------

### Added
- Added `trap_set()` in order to manage traps.

### Changed
- Moved from `getopt` to a shell implementation of option parsing. This ensures
  portability, and doesn't depend on a C program with GNU extensions. That was
  a mistake. The new implementation is taken from the public domain library,
  `getoptions`.
- `warn()` function was modified to use `log "$1" "$2" "${3:-WARNING}"` instead.
- Made `cpt` checksum method compatible with the KISS Community repository.


3.2.0 - 2020-08-22
--------------------------------------------------------------------------------

### Added
- A `.build.cpt` file can be edited during the pre-build hook, so that a build
  script can be modified. If the build is modified, a diff file will be
  generated to the package database.
- Some of the tools now use getopt. Since getopt isn't a POSIX utility,
  util-linux implementation has been added to the `getopt-ul` directory. It
  consists only of files required for the tool to be built.
- Added `pre-chroot` hook for the `cpt-chbuild` utility.

### Changed
- `cpt-chbuild` now uses library functions such `sh256()`, and `as_root()`.
- `cpt` programs no longer exit if `$CPT_PATH` is unset.


3.1.1 - 2020-08-11
--------------------------------------------------------------------------------

### Changed
- `as_root()` now sets package manager variables with env.


3.1.0 - 2020-08-07
--------------------------------------------------------------------------------

### Changed
- `cpt-lib` no longer creates temporary directories. This will need manual
  adjustments for scripts that make use of the cache directories. Those
  directories can now be created by calling the `create_cache()` function.
- Dropping libtool's `*.la` library files from packages.


3.0.0 - 2020-07-24
--------------------------------------------------------------------------------

This is the 3.0.0 release. This will make `kiss` (now renamed as `cpt`) a
toolchain for package management rather than a single script program. The main
functionality is moved into a `lib.sh` file which the tools will source. This
comes with nice benefits such as:

- Easier option parsing for each tool.
- Easier to extend the package manager as it is only a library. It no longer
  requires dirty hacks to source the package manager functions and variables.
- Clearer usage information is outputted, so the user doesn't have to delve into
  documents to see the syntax/options of a tool.

### Added
- `$CPT_CACHE` to change the cache directory.
- Added a bunch of flags, here is a table:

| Flag       | Function                                  | Added tool             |
|------------|-------------------------------------------|------------------------|
| --force    | Force removal/installation                | cpt-remove/cpt-install |
| --root     | Specify root directory                    | lots of tools          |
| --download | Only download packages                    | cpt-update             |
| --no-fetch | Do not fetch repositories before update   | cpt-update             |
| --single   | Only show the first instance of a package | cpt-search             |


### Changed

- Renamed all variables from `KISS-*` to `CPT-*`
- Moved database to `/var/db/cpt`
- Changed the code style and did some minor nitpicks for the C programs.

### Removed
- Removed the ability to control color output (for now).
- Removed `kiss-outdated` and `kiss-which`.


2.3.0 - 2020-07-16
--------------------------------------------------------------------------------

### Added
- Added `KISS_FETCH` to optionally disable repository fetches while performing
  a system update. You can now run `KISS_FETCH=0 kiss u` in order to update
  your system without syncing repositories.

### Changed
- Changed usage outputs for kiss and contrib utilities.
- `rsync` repositories are now synced based on checksums rather than timestamps.
- `kiss-chroot` now uses system flags if available.
- `kiss-chbuild` now installs extra packages if specified.
- hooks now default to `null` if no arguments are given
- `*-pull` hooks have been renamed to `*-fetch` and is run only once instead of
  for every single git repository.

### Fixed
- Fixed an issue where using `su` to install packages resulted in a wrong
  package ownership.


2.2.1 - 2020-06-11
--------------------------------------------------------------------------------

### Fixed
- Fixed directory checking on package removal


2.2.0 - 2020-06-10
--------------------------------------------------------------------------------

### Added
- Makefile configurations were moved to config.mk.

### Changed
- `kiss` no longer ignores musl and gcc on `fixdeps()`. This will result in an
  influx of musl dependencies. But you will be needing the C library to be
  installed anyway if you want your programs to work. If your program links
  to `libgcc`, you will need the gcc package for that given program to function.
- Makefile now properly accepts `LIBS`, `LDFLAGS`, and `CFLAGS`.
- Updated documentation.

### Fixed
- `C89` compatibility on C programs.
- Fixed an alternatives issue where a file containing special regular expression
  characters (such as `/usr/bin/[`) would result in a manifest deletion.


2.1.2 - 2020-06-03
--------------------------------------------------------------------------------

### Fixed
- Fixed a segmentation fault on `kiss-stat` when a file didn't have on owner on
  the `passwd` database.


2.1.1 - 2020-06-03
--------------------------------------------------------------------------------

### Fixed
- Fixed 'No message in queue' message being outputted for every single package.
- Fixed CFLAGS for x86_64 on `kiss-chroot`.
- Fixed setting binary packages as dependencies.


2.1.0 - 2020-05-29
--------------------------------------------------------------------------------

### Added
- Added '$2' '$3' for build scripts which specifies version and architecture
  information.

### Changed
- `kiss-chroot` now sets architecture based on the system
- Updated documentation

### Removed
- Removed strip messages


2.0.0 - 2020-05-28
--------------------------------------------------------------------------------

### Added
- Rsync repository support.
- pre/post hooks for package removal (pre-remove, post-remove).
- pre/post hooks for git pulls (pre-pull, post-pull).

### Changed
- `kiss` no longer removes empty directories if they are defined on a different
  package.
- `$KISS_NOPROMPT` has been renamed to `$KISS_PROMPT` and must be set to 0 in
  order to disable prompts.
- `kiss-chbuild` now checks tarball digest.
- `kiss-chbuild` now downloads tarballs according to arch (x86_64 or i686
  currently).
- Submodule repository fetching has been modified to match compatibility.

### Removed
- Removed `kiss-maintainer` and moved it to [kiss-extra]

[kiss-extra]: https://github.com/carbslinux/kiss-extra


1.22.4 - 2020-05-26
--------------------------------------------------------------------------------

**NOTE:** `1.22.x` is the last minor version before `2.0.0`, meaning I will not
be doing any releases except for patches and fixes. My attention is now on
implementing binary repositories. I will be doing some 'release candidates'
before release, as binary repositories will need user feedback.

### Added
- Added new documents.
- Added `post-package` hook.

### Changed
- Renamed the `hashcheck` function to `sh256` for compatibility.
- Enabled the usage of glob characters for `kiss-bin`.


1.22.3 - 2020-05-18
--------------------------------------------------------------------------------

### SECURITY
- Fixed a bug regarding privilege escalation using `$KISS_HOOK`. `kiss` will now
  use `$KISS_ROOT/etc/kiss-hook` on installation operations (which are run by
  root) so that the hooks are defined by the system administrator rather than the
  user. See [related proof-of-concept]

[related proof-of-concept]: https://github.com/kisslinux/kiss/pull/157#issuecomment-629880775


1.22.2 - 2020-05-16
--------------------------------------------------------------------------------

### Fixed
- Fixed an issue where `pkg_conflicts` would abort if `kiss-readlink` failed due
  to missing components. It now fallbacks to the original directory name.



1.22.1 - 2020-05-15
--------------------------------------------------------------------------------

### REMOVED
- Removed some contrib scripts and moved them to [kiss-extra]
- `kiss-cargo-urlgen`
- `kiss-cargolock-urlgen`
- `kiss-changelog`
- `kiss-depends-finder`
- `kiss-exec`
- `kiss-message`
- `kiss-orphans`
- `kiss-reporevdepends`


### Fixed
- Fixed a `kiss-owns` typo that caused it to fail.
- Fixed a `kiss-readlink` bug where it would fail if the last component wouldn't
  exist.
- Fixed an error on tarball extraction where a file name containing spaces would
  be parsed as two files.


[kiss-extra]: https://github.com/carbslinux/kiss-extra


1.22.0 - 2020-05-14
--------------------------------------------------------------------------------

### Added
- Added `kiss-exec`, a tool to execute commands inside the alternatives system.

### Changed
- Replaced `KISS_COLOUR` with `KISS_COLOR` to match upstream.
- Renamed `colour` variable to `color` for consistency.
- The package manager no longer needs root privileges if the `KISS_ROOT` is
  writable by the user.
- `kiss` now uses the host cache regardless of `KISS_ROOT`.

### Fixed
- Fixed an issue where `kiss-owns` would output the wrong package because of
  symbolic links. The script now reads the link of the directory instead of the
  full file.


1.21.1 - 2020-05-14
--------------------------------------------------------------------------------

### Changed
- All contrib messages now output usage information when called with `--help`
  and `-h`.
- `hashcheck` function now uses `$1` instead of `${file#\*}`.

### Fixed
- Fixed a non-POSIX `find` call. Thanks to @illiliti.


1.21.0 - 2020-05-12
--------------------------------------------------------------------------------

### Added
- Added a `d|download` option to acquire the sources of given packages. If no
  packages are given, it acquires the sources of outdated packages. This can be
  used to acquire a package's sources to build it later, or periodically
  downloading outdated package sources, so the user doesn't wait for the download
  when updating the system.
- kiss now understands `.txz` tarballs. (BSD `src.txz` wink wink)
- `KISS_TMPDIR` can now be used to specify a temporary build directory. This
  will be useful for those of you who would want to build on ram or a different
  file system.

### Changed
- Simplified tarball extraction method.
- Removed the 'esc' function inside kiss.
- Added a 'warn' function to standardise warnings inside kiss

### Fixed
- Removed the `sys_db` usage on `pkg_find()` where directories could clash with
  external utilities.


1.20.3 - 2020-05-09
--------------------------------------------------------------------------------

### Fixed
- Fixed an alternatives bug caused by the previous patch, where the package
  moving to `/var/db/kiss/choices` would take the name of the preferred package.


1.20.2 - 2020-05-09
--------------------------------------------------------------------------------

### Fixed
- Fixed an issue regarding manifest format when using pkg_swap (alternatives).


1.20.1 - 2020-05-08
--------------------------------------------------------------------------------

### Changed
- Faster conflict resolution by using a conflict cache file.
- Standardised `kiss-readlink` usage output.


1.20.0 - 2020-05-07
--------------------------------------------------------------------------------

### Added
- `KISS_NOPROMPT` can be specified in order to skip prompts.


1.19.1 - 2020-05-07
--------------------------------------------------------------------------------

### Added
- Added `e|extension` to `kiss` which can be used to output kiss-extensions.

### Changed
- `kiss` no longer outputs the extensions when called with `kiss help`. The
  output was too large for an average terminal, and a user had to scroll up
  for actual package manager options. These can now be retrieved with `kiss e`.
- When called from a subshell, `kiss` disables colour escape sequences. This
  behaviour can be overridden by setting `KISS_COLOUR` environment variable.
  If set to 1, it will be enabled globally, if set to 0 it will be disabled
  globally.


1.19.0 - 2020-05-06
--------------------------------------------------------------------------------

### Added
- Added `kiss-reporevdepends` for finding all the packages on the repository
  that depends on the specified package.

### Changed
- Removed the `-p` flag from tar while installing packages. busybox ignores it
  and we don't need it.
- Replaced tar flags with keys for historical compatibility.
- `kiss` now decompresses a tarball once and uses the decompressed tarball for
  listing and extraction.

### Fixed
- Fixed the output of doc-strings in contrib scripts.
- `kiss` now ignores the binary programs in the repository for
  `kiss extensions`.


1.18.0 - 2020-05-04
--------------------------------------------------------------------------------

### Added
- Added editorconfig file since we now have 4 languages (roff, Makefile, sh, C)
  in the repository.
- Added `kiss-readlink` as a `readlink -f` replacement.
- Added `kiss-message` for checking package messages.
- Added this CHANGELOG

### Changed
- Made tar calls portable. `kiss` is no longer limited to busybox, bsdtar, or
  gnu tar!

### Removed
- Dropped the usage of `readlink` in `kiss`.


1.17.0 - 2020-05-03
--------------------------------------------------------------------------------

### Added
- Added `kiss-stat`, a simple C program for getting the owner name of a
  file/directory.

### Removed
- Removed the usage of `stat` calls, as they are not standardised.

### Changed
- `kiss` now doesn't report `Generating etcsums` if there isn't an `/etc`
  directory in the package

### Fixed
- `kiss` now uses `sys_db` instead of `pkg_db` when removing packages from the
  system.
- `kiss` now explicitly exits if prompt returns with a status of 1. This is for
  `ksh` compatibility.


1.16.3 - 2020-05-03
--------------------------------------------------------------------------------

### Fixed
- Fixed etcsum location.


1.16.2 - 2020-05-03
--------------------------------------------------------------------------------

### Added
- Added fallbacks for sha256sum. `kiss` now fallbacks to `sha256`, and `openssl`
  for hash checking, respectively.
- Added `kiss-changelog` and `kiss-which` entries to the `kiss-contrib.1` manual
  page.

### Fixed
- Fixed `kiss` not using the preferred `tar` program on decompression.
- Fixed `pkg_conflicts()` getting stuck when you reinstall the same single
  package on a system.
- Fixed `pkg_conflicts()` giving an error if no packages are installed on a
  system.


1.16.1 - 2020-05-01
--------------------------------------------------------------------------------

### Fixed
- Fixed `ksh` Ctrl+C interrupt signals.


1.16.0 - 2020-05-01
--------------------------------------------------------------------------------

### Added
- New message queue system implementation. If a package includes a file named
  `message` it will output its contents in a pretty way.
- Added `kiss-which`, a tool like `which` but for `kiss` packages.
- Added `kiss-changelog`, a tool for outputting the git log of a given package.

### Fixed
- Fixed colour outputting on `OpenBSD ksh`.
- Made compatibility fixes on the Makefile
- Fixed an installation issue where `kiss` would look for the manifest with the
  `$KISS_ROOT` variable


1.15.0 - 2020-04-30
--------------------------------------------------------------------------------

I have decided to revert to rsync installation method as it is faster and safer.
Now, rsync is not a huge dependency. Saving 500Kb is not worth it when you look
at the trade-off.

### REMOVED
- Removed the new installation method.

### Changed
- Reverted to `rsync` for installation.
- We are now forcing decompression to standard output while using `decompress()`
- `kiss` now accepts decompressed tar archives for package installation as well.


1.14.2/1.14.3 - 2020-04-27
--------------------------------------------------------------------------------

### Fixed
- The new installation method now complies to the `$KISS_ROOT` value.


1.14.1 - 2020-04-27
--------------------------------------------------------------------------------

### Removed
- Removed the unnecessary `[ -d ]` from the path query.

### Fixed
- Fixed directory permissions in the new installation method.
- Added support for `$KISS_ROOT` to the new installation method.
- Added a check for symlinks that could overwrite a directory during
  installation.
- Whitespace cleanup.


1.14.0 - 2020-04-25
--------------------------------------------------------------------------------

This release removes `rsync` from `kiss` and implements its own installation
method.

### Added
- `kiss` now implements user scripts available in the `$PATH`. This can be used
  to call `kiss manifest` from `kiss` itself.
- `kiss` now displays a warning if the user has a `$KISS_ROOT` that ends with
  a `/`.
- `kiss` now uses its own new package installation method.

### Removed
- usage of rsync as an installation method.
- usage of `old_ifs`


1.13.1 - 2020-04-19
--------------------------------------------------------------------------------

### Removed
- Reverted and removed `kiss ss` changes.


1.13.0 - 2020-04-19
--------------------------------------------------------------------------------

### Added
- `kiss ss` for outputting a single location for scripting.

### Changed
- `kiss` now elevates permissions during checksum if the file isn't owned by us.
- Hide read error messages when `version` file cannot be found.
- Made the `pkg_fixdeps()` usage of `diff` portable.

### Fixed
- Fixed a shellcheck error.


1.12.3 - 2020-04-17
--------------------------------------------------------------------------------

### Changed
- Changed indentation style on decompression.

### Fixed
- `kiss-export` fallbacks to gzip if the compression method is unknown.
- `kiss-repodepends` now outputs the proper depends file.


1.12.2 - 2020-04-15
--------------------------------------------------------------------------------

### Added
- `kiss` can now decompress zip files.

### Changed
- `checksum`, `build`, `install`, and `remove` operations can now be done on the
  current package directory without arguments. So you can `cd` into a package an
  type `kiss b` to build that package.

### Fixed
- `kiss-export` now honours your `KISS_COMPRESS` value


1.12.1 - 2020-04-12
--------------------------------------------------------------------------------

### Fixed
- Fixed printing empty arguments in `kiss-outdated`.


1.12.0 - 2020-04-05
--------------------------------------------------------------------------------

### Added
- `kiss-cargolock-urlgen`: a tool that can read a Cargo.lock file to generate a
  list of urls.
- `kiss-cat`: a tool to concatenate package build files.
- Manual page for `kiss-contrib`.

### Changed
- `kiss-owns` now gives an error on directories.
- `kiss-link` can now take multiple file names and will create symbolic links
  of them all.
- Simplified `kiss-link`

### Fixed
- `kiss-cargo-urlgen`: Fixed an issue where if a package version contained a '-'
  it could lead to wrong url generation.


1.9.0 - 1.11.2 - 2020-04-04
--------------------------------------------------------------------------------

### Added
- `kiss f` to fetch repositories without an update prompt.
- Support for submodules in the repository.
- Added a Makefile to standardise the installation.
- Zstd compression method.

### Changed
- Modified `kiss-chbuild` to fit Carbs Linux.
- Changed README to notify about forking status.
- `pkg_find()` now also checks for symlinks instead of just directories.
- `pkg_find()` now uses a `for` loop instead of `find`.
- Force C locale for faster grepping.
- Easily readable manual page.

### Fixed
- Compression method now fallbacks to gzip if unknown.
