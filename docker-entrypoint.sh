#!/bin/sh
set -e

echo "Running database migrations..."

RAILS_ENV=production bundle exec rails db:migrate

echo "Starting Rails server..."

exec "$@"