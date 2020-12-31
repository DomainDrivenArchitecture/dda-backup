function init-role-repo() {
  restic -r ${RESTIC_REPOSITORY}/pg-role -v init
}

function init-database-repo() {
  restic -r ${RESTIC_REPOSITORY}/pg-database -v init
}

function drop-create-db() {
  psql -d template1 -h ${POSTGRES_SERVICE} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} \
      --no-password -c "DROP DATABASE \"${POSTGRES_DB}\";"
  psql -d template1 -h ${POSTGRES_SERVICE} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} \
      --no-password -c "CREATE DATABASE \"${POSTGRES_DB}\";"
}

function create-pg-pass() {
  local pg_host=${POSTGRES_HOST:-localhost}

  echo "${pg_host}:${POSTGRES_DB}:${POSTGRES_USER}:${POSTGRES_PASSWORD}" > /root/.pgpass
	echo "${POSTGRES_HOST}:template1:${POSTGRES_USER}:${POSTGRES_PASSWORD}" >> /root/.pgpass
	chmod 0600 /root/.pgpass
}

function backup-roles() {
  local role_prefix="$1"; shift

  restic -v -r ${RESTIC_REPOSITORY}/pg-role unlock --cleanup-cache

  pg_dumpall -h ${POSTGRES_SERVICE} -p ${POSTGRES_PORT} -U${POSTGRES_USER} --no-password --roles-only | \
      grep "${role_prefix}" | \
      restic -v -r ${RESTIC_REPOSITORY}/pg-role backup --stdin

  restic -v -r ${RESTIC_REPOSITORY}/pg-role forget --keep-last 1 --keep-within ${RESTIC_DAYS_TO_KEEP}d --prune
}

function backup-db-dump() {
  restic -v -r ${RESTIC_REPOSITORY}/pg-database unlock --cleanup-cache

  pg_dump -d ${POSTGRES_DB} -h ${POSTGRES_SERVICE} -p ${POSTGRES_PORT} \
      -U ${POSTGRES_USER} --no-password --serializable-deferrable | \
      restic -v -r ${RESTIC_REPOSITORY}/pg-database backup --stdin

  restic -v -r ${RESTIC_REPOSITORY}/pg-database forget --keep-last 1 --keep-within ${RESTIC_DAYS_TO_KEEP}d --prune
}

function restore-roles() {
  restic -v -r ${RESTIC_REPOSITORY}/pg-role unlock --cleanup-cache

  restic -r ${RESTIC_REPOSITORY}/pg-role dump latest stdin | \
      psql -d template1 -h ${POSTGRES_SERVICE} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} \
      --no-password
}

function restore-db() {
  restic -v -r ${RESTIC_REPOSITORY}/pg-database unlock --cleanup-cache

  restic -r ${RESTIC_REPOSITORY}/pg-database dump latest stdin | \
      psql -d ${POSTGRES_DB} -h ${POSTGRES_SERVICE} -p ${POSTGRES_PORT} -U ${POSTGRES_USER} \
      --no-password
}