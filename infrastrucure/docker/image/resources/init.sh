#!/bin/bash

function main() {
    file_env AWS_ACCESS_KEY_ID
    file_env AWS_SECRET_ACCESS_KEY

    file_env RESTIC_PASSWORD_FILE

    restic -r ${RESTIC_REPOSITORY}/db --verbose init
    restic -r ${RESTIC_REPOSITORY}/files --verbose init
}

source /usr/local/lib/funtions.sh
main
