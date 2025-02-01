-- Check if the replication user already exists, and create it if it doesn't
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '${REPLICATION_USER}') THEN
        EXECUTE format('CREATE ROLE %I WITH REPLICATION PASSWORD %L LOGIN;', '${REPLICATION_USER}', '${REPLICATION_PASSWORD}');
    END IF;
END $$;

-- Grant privileges to the replication user
GRANT ALL PRIVILEGES ON DATABASE ${POSTGRES_DB} TO ${REPLICATION_USER};