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

# Wait for PostgreSQL
echo "Waiting for PostgreSQL to become available..."
while ! nc -z $POSTGRES_HOST 5432; do
  sleep 0.1
done
echo "PostgreSQL is available"

# Set up database
echo "Setting up database..."
bundle exec rails db:schema:load
bundle exec rails db:migrate

# Ensure tmp directories exist
mkdir -p tmp/pids
mkdir -p tmp/sockets