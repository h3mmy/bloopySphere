#!/bin/bash
set -e

dt=$(date '+%d/%m/%Y %H:%M:%S');
echo "$dt - Running init script the 1st time Primary PostgreSql container is created...";

customDatabaseName="$HASS_DB_NAME"
customUserName="$HASS_DB_USER"

echo "$dt - Running: psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER --dbname $POSTGRES_DB ...";

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
CREATE DATABASE $customDatabaseName;
CREATE USER $customUserName WITH PASSWORD '$HASS_DB_PASSWORD';
GRANT ALL PRIVILEGES ON DATABASE "$customDatabaseName" to $customUserName;
# Home Assistant has a superiority complex
ALTER DATABASE $customDatabaseName OWNER TO $customUserName;
ALTER USER $customUserName WITH SUPERUSER;
EOSQL

echo "$dt - Init script is completed";
