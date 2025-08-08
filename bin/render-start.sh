#!/usr/bin/env bash
# exit on error
set -o errexit

# Wait for PostgreSQL using pg_isready
echo "Waiting for PostgreSQL to become available..."
if [ -z "${DATABASE_URL}" ]; then
  echo "Error: DATABASE_URL is not set"
  exit 1
fi

# Extract host and port from DATABASE_URL
db_host=$(echo $DATABASE_URL | sed -n 's/.*@\([^:]*\).*/\1/p')
db_port=$(echo $DATABASE_URL | sed -n 's/.*:\([0-9]*\)\/.*/\1/p')

echo "Checking PostgreSQL connection at host $db_host port ${db_port:-5432}..."
timeout 30s bash -c "until pg_isready -h $db_host -p ${db_port:-5432}; do sleep 1; done"
echo "PostgreSQL is available"

# Set up database
echo "Setting up database..."
echo "Running database migrations..."

# Try to run migrations with better error handling
if bundle exec rails db:migrate; then
  echo "Database migration completed successfully"
else
  echo "Migration failed, trying to create database first..."
  bundle exec rails db:create
  bundle exec rails db:migrate
  echo "Database migration completed after create"
fi

# Check if tables exist
echo "Checking if users table exists..."
if bundle exec rails runner "puts 'Users table exists: ' + ActiveRecord::Base.connection.table_exists?('users').to_s"; then
  echo "Database setup verification completed"
else
  echo "Warning: Could not verify database tables"
fi

# Start the application
bundle exec puma -C config/puma.rb