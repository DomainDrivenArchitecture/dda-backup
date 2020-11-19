#!/bin/bash

echo "${POSTGRES_HOST}:$(cat ${POSTGRES_DB_FILE}):$(cat ${POSTGRES_USER_FILE}):$(cat ${DB_PASSWORD_FILE})" > /root/.pg_pass
echo "${POSTGRES_HOST}:template1:$(cat ${POSTGRES_USER_FILE}):$(cat ${DB_PASSWORD_FILE})" >> /root/.pg_pass
chmod 0600 /root/.pg_pass
