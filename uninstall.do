. ./config.rc

getbin | while read -r file; do
    rm -f "${DESTDIR}${BINDIR}/${file##*/}"
done

for man in man/*.1; do
    rm -f "${DESTDIR}${MAN1}/${man##*/}"
done
