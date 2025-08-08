#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
bundle install

# Cleanup any assets from development
rm -rf public/assets tmp/cache

# Create storage directory for uploads
mkdir -p storage

# Compile assets
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Wait for PostgreSQL using pg_isready
echo "Waiting for PostgreSQL to become available..."

# Check for DATABASE_URL with increased timeout and better error handling
max_attempts=60  # Increased from 30 to 60
attempt=1

check_database_url() {
  if [ -n "${DATABASE_URL}" ]; then
    echo "DATABASE_URL is set, extracting connection details..."
    db_host=$(echo $DATABASE_URL | sed -n 's/.*@\([^:]*\).*/\1/p')
    db_port=$(echo $DATABASE_URL | sed -n 's/.*:\([0-9]*\)\/.*/\1/p')
    return 0
  fi
  return 1
}

while [ $attempt -le $max_attempts ]; do
  if check_database_url; then
    break
  fi
  echo "Attempt $attempt/$max_attempts: Waiting for DATABASE_URL to be set..."
  sleep 5  # Increased from 2 to 5 seconds
  attempt=$((attempt + 1))
done

if [ -z "${DATABASE_URL}" ]; then
  echo "Error: DATABASE_URL is not set after $max_attempts attempts"
  echo "Please ensure the database is properly provisioned in Render"
  echo "Check the database status in your Render dashboard"
  exit 1
fi

echo "Checking PostgreSQL connection at host $db_host port ${db_port:-5432}..."
timeout 60s bash -c "until pg_isready -h $db_host -p ${db_port:-5432}; do sleep 2; done"
echo "PostgreSQL is available"

# Set up database
echo "Setting up database..."
bundle exec rails db:schema:load
bundle exec rails db:migrate

# Ensure tmp directories exist
mkdir -p tmp/pids
mkdir -p tmp/sockets