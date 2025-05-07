#!/bin/bash
# Ensure environment variables are set
if [ -z "$POSTGRES_USER" ] || [ -z "$POSTGRES_PASSWORD" ] || [ -z "$POSTGRES_DB" ] || [ -z "$POSTGRES_HOST" ]; then
    echo "One or more required environment variables are not set."
    # Stop the container
    exit 1
fi

# Wait until /usr/src/app/shared/mmar/mmar-database/init.sql is available
while [ ! -f /usr/src/app/shared/mmar/mmar-database/init.sql ]; do
    echo "Waiting for init.sql to be available..."
    sleep 5
done

# Wait until the database is available
until PGPASSWORD="${POSTGRES_PASSWORD}" psql -h "${POSTGRES_HOST}" -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" -c '\q'; do
    echo "Waiting for PostgreSQL to be available at host ${POSTGRES_HOST}..."
    sleep 5
done

# Execute the SQL script
PGPASSWORD="${POSTGRES_PASSWORD}" psql -h "${POSTGRES_HOST}" -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --dbname "${POSTGRES_DB}" < /usr/src/app/shared/mmar/mmar-database/init.sql

# Log the completion of the script
echo "--------------------------------------------------------"
echo "Database initialization script executed successfully."
echo "--------------------------------------------------------"

