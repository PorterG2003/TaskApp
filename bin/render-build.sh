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

# Check for DATABASE_URL
max_attempts=30
attempt=1
while [ -z "${DATABASE_URL}" ] && [ $attempt -le $max_attempts ]; do
  echo "Attempt $attempt/$max_attempts: Waiting for DATABASE_URL to be set..."
  sleep 2
  attempt=$((attempt + 1))
done

if [ -z "${DATABASE_URL}" ]; then
  echo "Error: DATABASE_URL is not set after $max_attempts attempts"
  echo "Please ensure the database is properly provisioned in Render"
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
bundle exec rails db:schema:load
bundle exec rails db:migrate

# Ensure tmp directories exist
mkdir -p tmp/pids
mkdir -p tmp/sockets