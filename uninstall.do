. ./config.rc

# Remove executables.
getbin | while read -r file; do
    rm -f "${DESTDIR}${BINDIR}/${file##*/}"
done

# Remove manual pages.
for man in man/*.1; do
    rm -f "${DESTDIR}${MAN1}/${man##*/}"
done

# Remove the info page.
rm -f "${DESTDIR}${INFODIR}/cpt.info"
