echo "${POSTGRES_HOST}:${POSTGRES_DB}:${POSTGRES_USER}:${DB_PASSWORD}" > /root/.pg_pass
echo "${POSTGRES_HOST}:template1:${POSTGRES_USER}:${DB_PASSWORD}" >> /root/.pg_pass
chmod 0600 /root/.pg_pass
