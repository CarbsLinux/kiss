. ./config.rc
redo all

# Install executables.
mkdir -p "${DESTDIR}${BINDIR}"
getbin | while read -r file; do
    cp "$file" "${DESTDIR}${BINDIR}/${file##*/}"
    chmod 755 "${DESTDIR}${BINDIR}/${file##*/}"
done

# Install manual pages.
mkdir -p "${DESTDIR}${MAN1}"
for man in man/*.1; do
    cp "$man" "${DESTDIR}${MAN1}/${man##*/}"
    chmod 644 "${DESTDIR}${MAN1}/${man##*/}"
done

# Install the documentation info page.
# We don't want to bother if the info page wasn't created, just exit without an
# error.
[ -f docs/cpt.info ] || exit 0

mkdir -p "${DESTDIR}${INFODIR}"
cp docs/cpt.info "${DESTDIR}${INFODIR}/cpt.info"
chmod 644 "${DESTDIR}${INFODIR}/cpt.info"
