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

# Create database if it doesn't exist
bundle exec rails db:prepare

# Run database migrations
bundle exec rails db:migrate

# Ensure tmp directories exist
mkdir -p tmp/pids
mkdir -p tmp/sockets