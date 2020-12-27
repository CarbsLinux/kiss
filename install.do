. ./config.rc
redo all
PHONY

INSTALLSH=./tools/install.sh

# Install executables.
"$INSTALLSH" -Dm755 -t "$DESTDIR$BINDIR" $(getbin)

# Install manual pages.
"$INSTALLSH" -Dm644 -t "$DESTDIR$MAN1" man/*.1

# Install the documentation info page.
# We don't want to bother if the info page wasn't created, just exit without an
# error.
[ -f docs/cpt.info ] || exit 0
"$INSTALLSH" -Dm644 docs/cpt.info "$DESTDIR$INFODIR/cpt.info"
