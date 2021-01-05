#!/bin/bash

function main() {
    file_env POSTGRES_DB
    file_env POSTGRES_PASSWORD
    file_env POSTGRES_USER

    create-pg-pass

	# Idle process
	while true; do 
		sleep 500000
	done
}

source /usr/local/lib/functions.sh
source /usr/local/lib/pg-functions.sh
main
