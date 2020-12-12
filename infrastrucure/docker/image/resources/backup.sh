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

    # TODO: add a restic unlock stmt.
    # backup roles
    pg_dumpall -h ${POSTGRES_SERVICE} -p ${POSTGRES_PORT} -U${POSTGRES_USER} --no-password --roles-only > roles.sql
    # TODO: remove all without oc_
    restic -v -r ${RESTIC_REPOSITORY}/db-role backup --stdin
    
    # backup database dump
    pg_dump -d ${POSTGRES_DB} -h ${POSTGRES_SERVICE} -p ${POSTGRES_PORT} \
        -U ${POSTGRES_USER} --no-password --serializable-deferrable | \
        restic -v -r ${RESTIC_REPOSITORY}/db backup --stdin

    restic -r ${RESTIC_REPOSITORY}/db forget --keep-last 1 --keep-within ${RESTIC_DAYS_TO_KEEP}d --prune

    # backup nextcloud filesystem
    cd /var/backups/ && restic -r ${RESTIC_REPOSITORY}/files backup .

    restic -v -r ${RESTIC_REPOSITORY}/files forget --keep-last 1 --keep-within ${RESTIC_DAYS_TO_KEEP}d --prune
}

source /usr/local/lib/functions.sh
main
