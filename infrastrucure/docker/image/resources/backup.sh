#!/bin/bash

set -o pipefail

function main() {
    file_env AWS_ACCESS_KEY_ID
    file_env AWS_SECRET_ACCESS_KEY

    file_env POSTGRES_DB
    file_env POSTGRES_PASSWORD
    file_env POSTGRES_USER

    file_env RESTIC_PASSWORD
    file_env RESTIC_DAYS_TO_KEEP 14

    # backup roles
    restic -v -r ${RESTIC_REPOSITORY}/pg-role unlock --cleanup-cache

    pg_dumpall -h ${POSTGRES_SERVICE} -p ${POSTGRES_PORT} -U${POSTGRES_USER} --no-password --roles-only |
        grep 'oc_' |
        restic -v -r ${RESTIC_REPOSITORY}/pg-role backup --stdin

    restic -v -r ${RESTIC_REPOSITORY}/pg-role forget --keep-last 1 --keep-within ${RESTIC_DAYS_TO_KEEP}d --prune

    # backup database dump
    restic -v -r ${RESTIC_REPOSITORY}/pg-database unlock --cleanup-cache

    pg_dump -d ${POSTGRES_DB} -h ${POSTGRES_SERVICE} -p ${POSTGRES_PORT} \
        -U ${POSTGRES_USER} --no-password --serializable-deferrable |
        restic -v -r ${RESTIC_REPOSITORY}/pg-database backup --stdin

    restic -v -r ${RESTIC_REPOSITORY}/pg-database forget --keep-last 1 --keep-within ${RESTIC_DAYS_TO_KEEP}d --prune

    # backup nextcloud filesystem
    restic -v -r ${RESTIC_REPOSITORY}/files unlock --cleanup-cache

    cd /var/backups/ && restic -v -r ${RESTIC_REPOSITORY}/files backup .

    restic -v -r ${RESTIC_REPOSITORY}/files forget --keep-last 1 --keep-within ${RESTIC_DAYS_TO_KEEP}d --prune
}

source /usr/local/lib/functions.sh
main
