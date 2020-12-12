#!/bin/bash

set -o pipefail

function main() {
    file_env AWS_ACCESS_KEY_ID
    file_env AWS_SECRET_ACCESS_KEY

    file_env POSTGRES_DB
    file_env POSTGRES_PASSWORD
    file_env POSTGRES_USER

    file_env RESTIC_PASSWORD

    # files
    rm -rf /var/backups/*
    restic -v -r $RESTIC_REPOSITORY/files restore latest --target /var/backups/

    # db
    psql -d template1 -h ${POSTGRES_SERVICE} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} \
        --no-password -c "DROP DATABASE \"${POSTGRES_DB}\";"
    psql -d template1 -h ${POSTGRES_SERVICE} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} \
        --no-password -c "CREATE DATABASE \"${POSTGRES_DB}\";"

    # TODO: restore roles
    psql -d template1 -h ${POSTGRES_SERVICE} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} \
        --no-password -c "CREATE ROLE oc_...;"
    psql -d template1 -h ${POSTGRES_SERVICE} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} \
        --no-password -c "ALTER ROLE oc_... WITH NOSUPERUSER INHERIT NOCREATEROLE CREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'md5...';"

    restic -v -r ${RESTIC_REPOSITORY}/db restore latest --target test-stdin
    psql -d ${POSTGRES_DB} -h ${POSTGRES_SERVICE} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} \
        --no-password < test-stdin/stdin

}

source /usr/local/lib/functions.sh
main

