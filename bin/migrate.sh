#!/usr/bin/env bash
# exit on error
set -o errexit

echo "Starting database migration..."

# Check if DATABASE_URL is set
if [ -z "${DATABASE_URL}" ]; then
  echo "Error: DATABASE_URL is not set"
  exit 1
fi

echo "DATABASE_URL is set, running migrations..."

# Run migrations
bundle exec rails db:migrate

echo "Migrations completed successfully!"

# Verify tables exist
echo "Verifying tables..."
bundle exec rails runner "
  puts 'Users table exists: ' + ActiveRecord::Base.connection.table_exists?('users').to_s
  puts 'Tasks table exists: ' + ActiveRecord::Base.connection.table_exists?('tasks').to_s
" 