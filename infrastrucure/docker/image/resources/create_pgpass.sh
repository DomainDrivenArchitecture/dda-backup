#!/bin/bash

echo "${POSTGRES_HOST}:$(cat ${POSTGRES_DB_FILE}):$(cat ${POSTGRES_USER_FILE}):$(cat ${POSTGRES_PASSWORD_FILE})" > /root/.pgpass
echo "${POSTGRES_HOST}:template1:$(cat ${POSTGRES_USER_FILE}):$(cat ${POSTGRES_PASSWORD_FILE})" >> /root/.pgpass
chmod 0600 /root/.pgpass
