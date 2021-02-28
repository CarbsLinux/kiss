Carbs Packaging Tools
--------------------------------------------------------------------------------

Package management toolset for Carbs Linux. Forked from [KISS]. All usage
information can be obtained from the manual page. For changes please refer to
the `CHANGELOG.md` file.

[KISS]: https://github.com/kisslinux/kiss


Dependencies
--------------------------------------------------------------------------------

To build and use cpt, you need the following software:

- `rsync`
- `curl`
- POSIX base utilities [`coreutils`, `busybox`, `sbase`, etc.]
- `pax` or `tar` [GNU tar, busybox, toybox, libarchive, etc.]
- Common compression utilities such as `gzip`, `bzip2`, `xz`, etc.


In order to build the documentation, you will need the following software:

- `texinfo` (for generating `.info` pages)
- `Emacs`   (for generating `.texi` and `.txt` pages)

However, distributed tarballs come with info pages, and `.texi` and `.txt` files
are committed directly into the repository, meaning that you don't need
`texinfo` if you are using a tarball, and you don't need Emacs as long as you
don't edit the documentation.

You can also completely disable the build/installation of the documentation by
either passing `DOCS=no` to `make` or editing `config.mk` to disable it.


Directory Structure
--------------------------------------------------------------------------------

    /         -- README, LICENSE, CHANGELOG
    contrib/  -- for Shell scripts that wrap around cpt.
    docs/     -- for documentation.
    man/      -- for manual pages.
    src/      -- for the tools that make up the package manager.


Defining Base
--------------------------------------------------------------------------------

Tools such as cpt-orphans and cpt-reset define the base from the file
`/etc/cpt-base`. An example cpt-base file can be found from the root directory
of the repository, which is the default base for Carbs Linux. A user can modify
this file to fit their needs and redefine their base for the system. For
example, a user can decide that they want `sbase` instead of `busybox` for their
base, so if they reset their system, busybox will be removed instead of sbase.

This file is used to ship a predefined base, while leaving the base to a user's
choice. However, it isn't installed by the Makefile so that the packagers may
define their own base, or so that a user can install cpt without using it as
their main package manager.
