-- Check if the replication user already exists, and create it if it doesn't
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'replication_user') THEN
        EXECUTE format('CREATE ROLE %I WITH REPLICATION PASSWORD %L LOGIN;', 'replication_user', 'Camille+Dallas');
    END IF;
END $$;

-- Grant privileges to the replication user
GRANT ALL PRIVILEGES ON DATABASE postgres TO replication_user;