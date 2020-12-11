#!/bin/bash

# Restore Nextcloud Filesystem
# TODO: describe input params

# Reads restore snapshot_ID from first CLI Argument
restic -r $RESTIC_REPOSITORY/files restore latest --target /var/backups/

# Delete DB 
psql -d template1 -h $POSTGRES_SERVICE -p $POSTGRES_PORT -U $(cat ${POSTGRES_USER_FILE}) --no-password -c "DROP DATABASE \"cloud\";"
# Create DB again
psql -d template1 -h $POSTGRES_SERVICE -p $POSTGRES_PORT -U $(cat ${POSTGRES_USER_FILE}) --no-password -c "CREATE DATABASE \"cloud\";"
# create folder from db backup
restic -r $RESTIC_REPOSITORY/db restore latest --target test-stdin
# read folder and restore db entries
psql -d $(cat ${POSTGRES_DB_FILE}) -h $POSTGRES_SERVICE -p $POSTGRES_PORT -U $(cat ${POSTGRES_USER_FILE}) --no-password < test-stdin/stdin
