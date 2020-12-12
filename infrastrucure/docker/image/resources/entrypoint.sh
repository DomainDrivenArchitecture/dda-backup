#!/bin/bash

function main() {
    file_env POSTGRES_DB
    file_env POSTGRES_PASSWORD
    file_env POSTGRES_USER

    echo "${POSTGRES_HOST}:${POSTGRES_DB}:${POSTGRES_USER}:${POSTGRES_PASSWORD}" > /root/.pgpass
	echo "${POSTGRES_HOST}:template1:${POSTGRES_USER}:${POSTGRES_PASSWORD}" >> /root/.pgpass
	chmod 0600 /root/.pgpass

	# Idle process
	while true; do 
		sleep 500000
	done
}

source /usr/local/lib/functions.sh
main
