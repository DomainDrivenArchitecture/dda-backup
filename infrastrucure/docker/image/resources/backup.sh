#!/bin/bash

set -o pipefail

function main() {
    file_env AWS_ACCESS_KEY_ID
    file_env AWS_SECRET_ACCESS_KEY

    file_env POSTGRES_DB
    file_env POSTGRES_PASSWORD
    file_env POSTGRES_USER

    file_env RESTIC_PASSWORD_FILE

    # backup database dump
    pg_dump -d ${POSTGRES_DB} -h  ${POSTGRES_SERVICE} -p ${POSTGRES_PORT} \
        -U ${POSTGRES_USER_FILE} --no-password --serializable-deferrable \
        --clean --no-privileges | \
        restic -r ${RESTIC_REPOSITORY}/db backup --stdin

    # backup nextcloud filesystem
    cd /var/backups/ && restic -r ${RESTIC_REPOSITORY}/files backup .
}

source /usr/local/lib/functions.sh
main
