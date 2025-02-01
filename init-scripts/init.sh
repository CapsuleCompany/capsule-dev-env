#!/bin/bash
set -e  # Exit on error

echo "Waiting for PostgreSQL to start..."
until pg_isready -U "$POSTGRES_USER" -d "$POSTGRES_DB"; do
    sleep 1
done

# Ensure envsubst is installed
if ! command -v envsubst &> /dev/null; then
    apt-get update && apt-get install -y gettext
fi

echo "Initializing PostgreSQL Replication..."

# Substitute variables in SQL file
envsubst < /docker-entrypoint-initdb.d/init-replication-template.sql > /docker-entrypoint-initdb.d/init-replication.sql

# Debugging: Print the processed SQL file
echo "Processed SQL file content:"
cat /docker-entrypoint-initdb.d/init-replication.sql

# Run the script and handle errors gracefully
if ! psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" -f /docker-entrypoint-initdb.d/init-replication.sql; then
    echo "Error running replication SQL script. Exiting..."
    exit 1
fi

echo "Replication user and settings applied successfully."
exec "$@"