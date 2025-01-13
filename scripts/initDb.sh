# Ensure environment variables are set
if [ -z "$POSTGRES_USER" ] || [ -z "$POSTGRES_PASSWORD" ] || [ -z "$POSTGRES_DB" ]; then
    echo "One or more required environment variables are not set."
    #stop the container
    exit 1
fi

# Create PostgreSQL cluster if none exists
if [ ! -d "/var/lib/postgresql/16/main" ]; then
    echo "No PostgreSQL cluster found. Creating a new cluster..."
    pg_createcluster 16 main --start
else
    echo "----------------------------------------"
    echo "PostgreSQL cluster already exists."
fi

# Start PostgreSQL server
service postgresql start

# Wait for postgres to start
sleep 5

# Check if the database named 'api' already exists
if gosu postgres psql -lqt | cut -d \| -f 1 | grep -qw api; then
    echo "----------------------------------------"
    echo "Database 'api' already exists."

    # Stop PostgreSQL server
    echo "Stopping PostgreSQL server..."
    service postgresql stop

    # Initialize npm installs
    echo "----------------------------------------"
    echo "Initializing npm installs..."
    bash /usr/src/app/npm_installation.sh
    echo "----------------------------------------"
else
    # Change ownership of the data directory to the postgres user
    chown -R postgres:postgres /var/lib/postgresql/data

    # Update PostgreSQL configuration to allow connections from all IP addresses
    echo "Updating PostgreSQL configuration..."
    echo "listen_addresses = '*'" >> /etc/postgresql/16/main/postgresql.conf

    # Allow connections from all IP addresses
    echo "host all all 0.0.0.0/0 md5" >> /etc/postgresql/16/main/pg_hba.conf

    # Create PostgreSQL user and database
    echo "Creating PostgreSQL user and database..."
    gosu postgres psql -c "ALTER USER postgres PASSWORD '$POSTGRES_PASSWORD';"
    gosu postgres psql -c "CREATE USER $POSTGRES_USER WITH PASSWORD '$POSTGRES_PASSWORD';"
    gosu postgres psql -c "ALTER USER $POSTGRES_USER WITH SUPERUSER;"
    gosu postgres psql -c "CREATE DATABASE $POSTGRES_DB OWNER $POSTGRES_USER;"
    gosu postgres psql -d $POSTGRES_DB -f /usr/src/app/mmar/mmar-database/init.sql

    # Stop PostgreSQL server
    echo "Stopping PostgreSQL server..."
    service postgresql stop

    # Initialize npm installs
    echo "database installation done -> ----------"
    echo "Initializing npm installs..."
    echo "----------------------------------------"
    bash /usr/src/app/npm_installation.sh
fi
