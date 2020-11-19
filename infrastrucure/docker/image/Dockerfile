FROM ubuntu:focal

# https://stackoverflow.com/questions/59299133/how-to-silent-install-postgresql-in-ubuntu-via-dockerfile
ARG DEBIAN_FRONTEND=noninteractive


RUN apt-get update > /dev/null; \
    apt-get install restic ca-certificates -y > /dev/null; \
    update-ca-certificates


# This will install the latest postgresql version
# Taken from https://www.postgresql.org/download/linux/ubuntu/
RUN apt-get -y install vim bash-completion wget lsb-release gnupg 
# Create the file repository configuration:
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
# Import the repository signing key:
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
# Update the package lists:
RUN apt-get update
# Install the latest version of PostgreSQL.
# If you want a specific version, use 'postgresql-12' or similar instead of 'postgresql':
RUN apt-get -y install postgresql


# Prepare Entrypoint Script
ADD resources /tmp/resources
RUN chmod 700 /tmp/resources/entrypoint.sh /tmp/resources/create_pgpass.sh