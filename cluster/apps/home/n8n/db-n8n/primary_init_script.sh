#!/bin/bash
set -e

dt=$(date '+%d/%m/%Y %H:%M:%S');
echo "$dt - Running init script the 1st time Primary PostgreSql container is created...";

customDatabaseName="$N8N_DB_NAME"
customUserName="$N8N_DB_USER"

echo "$dt - Running: psql -v ON_ERROR_STOP=1 --username $POSTGRES_USER --dbname $POSTGRES_DB ...";

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
CREATE DATABASE $customDatabaseName;
CREATE USER $customUserName WITH PASSWORD '$N8N_DB_PASSWORD';
GRANT ALL PRIVILEGES ON DATABASE "$customDatabaseName" to $customUserName;
EOSQL

echo "$dt - Init script is completed";
