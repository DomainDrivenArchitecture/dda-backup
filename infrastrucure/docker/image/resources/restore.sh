#!/bin/bash


function main() {
    file_env AWS_ACCESS_KEY_ID
    file_env AWS_SECRET_ACCESS_KEY

    file_env POSTGRES_DB
    file_env POSTGRES_PASSWORD
    file_env POSTGRES_USER

    file_env RESTIC_PASSWORD_FILE

    # files
    rm -rf /var/backups/*
    restic -r $RESTIC_REPOSITORY/files restore latest --target /var/backups/

    # db
    psql -d template1 -h ${POSTGRES_SERVICE} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} \
        --no-password -c "DROP DATABASE \"${POSTGRES_DB}\";"
    psql -d template1 -h ${POSTGRES_SERVICE} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} \
        --no-password -c "CREATE DATABASE \"${POSTGRES_DB}\";"
    restic -r ${RESTIC_REPOSITORY}/db restore latest --target test-stdin
    psql -d ${POSTGRES_DB} -h ${POSTGRES_SERVICE} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} \
        --no-password < test-stdin/stdin

}

source /usr/local/lib/functions.sh
main

