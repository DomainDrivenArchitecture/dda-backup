# Restore Nextcloud Filesystem
# turn on maintenance mode
su -s /bin/bash -c 'php occ maintenance:mode --on' www-data
# Reads restore snapshot_ID from first CLI Argument
restic -r $RESTIC_REPOSITORY restore $1 --target /

# Delete DB 
psql -d template1 -h $POSTGRES_SERVICE -p $POSTGRES_PORT -U $(cat ${POSTGRES_USER_FILE}) --no-password -c "DROP DATABASE \"cloud\";"
# Create DB again
psql -d template1 -h $POSTGRES_SERVICE -p $POSTGRES_PORT -U $(cat ${POSTGRES_USER_FILE}) --no-password -c "CREATE DATABASE \"cloud\";"
# create folder from db backup
restic -r $RESTIC_REPOSITORY restore $2 --target test-stdin-$2
# read folder and restore db entries
psql -d $(cat ${POSTGRES_DB_FILE}) -h $POSTGRES_SERVICE -p $POSTGRES_PORT -U $(cat ${POSTGRES_USER_FILE}) --no-password < test-stdin-$2
# turn off maintenance mode
su -s /bin/bash -c 'php occ maintenance:mode --off' www-data
