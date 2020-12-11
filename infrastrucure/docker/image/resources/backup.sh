#!/bin/bash

set -o pipefail

# backup database dump
pg_dump -d $(cat ${POSTGRES_DB_FILE}) -h  $POSTGRES_SERVICE -p $POSTGRES_PORT -U $(cat ${POSTGRES_USER_FILE}) --no-password --serializable-deferrable --clean --no-privileges | \
restic -r $RESTIC_REPOSITORY/db backup --stdin

# backup nextcloud filesystem
restic -r $RESTIC_REPOSITORY/files backup /var/backups/
