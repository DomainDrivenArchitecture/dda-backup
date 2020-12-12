#!/bin/bash

apt-get update > /dev/null;
apt-get install -qqy ca-certificates curl wget gnupg > /dev/null
sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt focal-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

apt-get update > /dev/null;
apt-get -qqy install wget postgresql-client-13 restic > /dev/null;

update-ca-certificates

install -m 0700 /tmp/entrypoint.sh /
install -m 0700 /tmp/init.sh /usr/local/bin/
install -m 0700 /tmp/backup.sh /usr/local/bin/
install -m 0700 /tmp/restore.sh /usr/local/bin/
