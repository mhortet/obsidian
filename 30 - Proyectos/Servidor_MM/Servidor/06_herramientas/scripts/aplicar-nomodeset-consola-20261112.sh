#!/usr/bin/env bash
set -Eeuo pipefail

export LC_ALL=C

CFG=/etc/default/grub
GRUB_CFG=/boot/grub/grub.cfg
EXPECTED_HASH=3bfb893728053e0a1dcc45b81b460473c50f98e85541db8d8b9ba719bad2c4fc
BACKUP=/etc/default/grub.pre-nomodeset-20261112T1325
TMP=""
CHANGED=0

cleanup() {
    if [[ -n "${TMP}" && -e "${TMP}" ]]; then
        rm -f -- "${TMP}"
    fi
}

rollback() {
    local rc=$?
    trap - ERR
    printf 'ERROR: fallo durante la aplicacion; iniciando reversion.\n' >&2
    if [[ "${CHANGED}" -eq 1 && -f "${BACKUP}" ]]; then
        cp -a -- "${BACKUP}" "${CFG}"
        update-grub || true
        grub-script-check "${GRUB_CFG}" || true
        printf 'REVERSION: restaurado %s desde %s.\n' "${CFG}" "${BACKUP}" >&2
    fi
    cleanup
    exit "${rc}"
}

trap cleanup EXIT
trap rollback ERR

if [[ "${EUID}" -ne 0 ]]; then
    printf 'ERROR: ejecutar mediante sudo.\n' >&2
    exit 1
fi

if [[ "$(hostname)" != "srv-mm-01" ]]; then
    printf 'ERROR: host inesperado: %s\n' "$(hostname)" >&2
    exit 1
fi

command -v update-grub >/dev/null
command -v grub-script-check >/dev/null
command -v sha256sum >/dev/null

for unit in mysql sftpgo cloudflared; do
    if systemctl is-active --quiet "${unit}"; then
        printf 'ERROR: %s esta activo; se aborta sin cambios.\n' "${unit}" >&2
        exit 1
    fi
done

current_hash="$(sha256sum "${CFG}" | awk '{print $1}')"
if [[ "${current_hash}" != "${EXPECTED_HASH}" ]]; then
    printf 'ERROR: hash inesperado de %s: %s\n' "${CFG}" "${current_hash}" >&2
    exit 1
fi

if [[ "$(grep -c '^GRUB_CMDLINE_LINUX_DEFAULT=""$' "${CFG}")" -ne 1 ]]; then
    printf 'ERROR: no existe una unica linea GRUB_CMDLINE_LINUX_DEFAULT vacia.\n' >&2
    exit 1
fi

if [[ -e "${BACKUP}" ]]; then
    printf 'ERROR: la copia prevista ya existe: %s\n' "${BACKUP}" >&2
    exit 1
fi

cp -a -- "${CFG}" "${BACKUP}"
chmod 0600 "${BACKUP}"

TMP="$(mktemp /etc/default/.grub.nomodeset.XXXXXX)"
sed 's/^GRUB_CMDLINE_LINUX_DEFAULT=""$/GRUB_CMDLINE_LINUX_DEFAULT="nomodeset"/' \
    "${CFG}" >"${TMP}"

if [[ "$(grep -c '^GRUB_CMDLINE_LINUX_DEFAULT="nomodeset"$' "${TMP}")" -ne 1 ]]; then
    printf 'ERROR: la configuracion temporal no contiene exactamente nomodeset.\n' >&2
    exit 1
fi

install -o root -g root -m 0644 "${TMP}" "${CFG}"
CHANGED=1

update-grub
grub-script-check "${GRUB_CFG}"

if ! grep -Eq '^[[:space:]]*linux[[:space:]].*[[:space:]]nomodeset([[:space:]]|$)' "${GRUB_CFG}"; then
    printf 'ERROR: grub.cfg no contiene nomodeset en las entradas Linux.\n' >&2
    exit 1
fi

new_hash="$(sha256sum "${CFG}" | awk '{print $1}')"
generated_hash="$(sha256sum "${GRUB_CFG}" | awk '{print $1}')"

CHANGED=0
trap - ERR

printf 'RESULTADO=OK\n'
printf 'HOST=%s\n' "$(hostname)"
printf 'BACKUP=%s\n' "${BACKUP}"
printf 'GRUB_DEFAULT_SHA256=%s\n' "${new_hash}"
printf 'GRUB_CFG_SHA256=%s\n' "${generated_hash}"
printf 'PARAMETRO=nomodeset\n'
