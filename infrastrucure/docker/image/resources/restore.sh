#!/bin/bash

set -Eeo pipefail

function main() {

    #Start maintenance mode
    #/usr/local/bin/start-maintenance.sh

    file_env AWS_ACCESS_KEY_ID
    file_env AWS_SECRET_ACCESS_KEY

    file_env POSTGRES_DB
    file_env POSTGRES_PASSWORD
    file_env POSTGRES_USER

    file_env RESTIC_PASSWORD

    # create new db
    psql -d template1 -h ${POSTGRES_SERVICE} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} \
        --no-password -c "DROP DATABASE \"${POSTGRES_DB}\";"
    psql -d template1 -h ${POSTGRES_SERVICE} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} \
        --no-password -c "CREATE DATABASE \"${POSTGRES_DB}\";"

    # init restic
    restic -v -r ${RESTIC_REPOSITORY}/pg-role snapshots     

    # restore roles
    restic -r ${RESTIC_REPOSITORY}/pg-role dump latest stdin | \
        psql -d template1 -h ${POSTGRES_SERVICE} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} \
        --no-password

    # restore db
    restic -r ${RESTIC_REPOSITORY}/pg-database dump latest stdin | \
        psql -d ${POSTGRES_DB} -h ${POSTGRES_SERVICE} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} \
        --no-password

    # files
    rm -rf /var/backups/*
    restic -v -r $RESTIC_REPOSITORY/files restore latest --target /var/backups/

    # adjust trusted domains
    php /var/www/html/occ config:system:set trusted_domains 1 --value=cloud.test.meissa-gmbh.de

    #End maintenance mode
    #/usr/local/bin/end-maintenance.sh
}

source /usr/local/lib/functions.sh
main

