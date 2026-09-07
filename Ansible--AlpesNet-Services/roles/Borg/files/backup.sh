#!/usr/bin/env bash
set -euo pipefail

# --- required env vars (see .env.example) ---
: "${BORG_REPO:?Set BORG_REPO, e.g. /repo}"
: "${BORG_PASSPHRASE:?Set BORG_PASSPHRASE (passphrase that unlocks repo.key)}"

export BORG_KEY_FILE="${BORG_KEY_FILE:-/keys/repo.key}"
export BORG_PASSPHRASE
export BORG_RELOCATED_REPO_ACCESS_IS_FINE=yes
export BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_FINE=no

if [ ! -f "${BORG_KEY_FILE}" ]; then
    echo "ERROR: key file not found at ${BORG_KEY_FILE}" >&2
    exit 1
fi

ARCHIVE_NAME="${ARCHIVE_NAME_PREFIX:-backup}-{now:%Y-%m-%d_%H-%M-%S}"
CA_ARCHIVE_NAME="CA-{now:%Y-%m-%d_%H-%M-%S}"

echo "=== $(date -Iseconds) : starting backup ==="

# --- LDAP: dump fresh LDIF via slapcat before backing up /data ---
# Only runs if LDAP_CONTAINER_NAME is set (see .env.example). Skips
# cleanly if unset, so this script still works for setups without LDAP.
if [ -n "${LDAP_CONTAINER_NAME:-}" ]; then
    echo "=== $(date -Iseconds) : dumping LDAP (${LDAP_CONTAINER_NAME}) ==="
    mkdir -p /data/ldap-dumps

    # cn=config backend (slapd.d config-style setup, osixia default)
    if ! docker exec "${LDAP_CONTAINER_NAME}" slapcat -n 0 > /data/ldap-dumps/config.ldif; then
        echo "ERROR: slapcat -n 0 (config) failed against ${LDAP_CONTAINER_NAME}" >&2
        exit 1
    fi

    # Directory data backend. osixia's default single-suffix setup uses
    # index 1; if you have multiple suffixes/databases, adjust or add
    # more `-n N` dumps here (check with: docker exec <ldap> slapcat -n 0
    # | grep olcDatabase to see how many backends exist).
    if ! docker exec "${LDAP_CONTAINER_NAME}" slapcat -n 1 > /data/ldap-dumps/data.ldif; then
        echo "ERROR: slapcat -n 1 (data) failed against ${LDAP_CONTAINER_NAME}" >&2
        exit 1
    fi

    # Sanity check: a near-empty dump usually means the wrong -n index
    # was used, or the container name is wrong, more than it means an
    # actually-empty directory. Fail loudly rather than silently backing
    # up a bad dump.
    if [ ! -s /data/ldap-dumps/data.ldif ]; then
        echo "ERROR: data.ldif is empty — check LDAP_CONTAINER_NAME and slapcat -n index" >&2
        exit 1
    fi

    echo "=== $(date -Iseconds) : LDAP dump complete ==="
fi

EXCLUDE_ARGS=()
if [ -f "${BORG_EXCLUDE_FILE:-/etc/borg-excludes.txt}" ]; then
    EXCLUDE_ARGS=(--exclude-from "${BORG_EXCLUDE_FILE:-/etc/borg-excludes.txt}")
fi

# Backs up everything mounted under /data (including ldap-dumps/ and
# ldap-raw/ if you added those volumes). Add/remove what's included by
# editing the volumes section of docker-compose.yml, not this script.
echo "=== $(date -Iseconds) : starting ldap backup ==="

borg create \
    --stats \
    --compression lz4 \
    --exclude-caches \
    "${EXCLUDE_ARGS[@]}" \
    "${BORG_REPO}::${ARCHIVE_NAME}" \
    /data

echo "=== $(date -Iseconds) : starting CA backup ==="

borg create \
    --stats \
    --compression lz4 \
    --exclude-caches \
    --exclude '/data/dockersConfig/ca/data' \
    "${BORG_REPO}::${CA_ARCHIVE_NAME}" \
    /data/dockersConfig/ca

echo "=== $(date -Iseconds) : CA backup complete ==="


#echo "=== $(date -Iseconds) : pruning old archives ==="

#borg prune \
#    --list \
#    --keep-daily="${KEEP_DAILY:-7}" \
#    --keep-weekly="${KEEP_WEEKLY:-4}" \
#    --keep-monthly="${KEEP_MONTHLY:-6}" \
#    "${BORG_REPO}"

echo "=== $(date -Iseconds) : compacting repo ==="
borg compact "${BORG_REPO}"

echo "=== $(date -Iseconds) : backup finished ==="
