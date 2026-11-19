#!/bin/sh
set -e

if [ "$RAILS_ENV" = "production" ]; then
  echo "Running database migrations..."
  bundle exec rails db:migrate
fi

echo "Starting Rails server..."

exec "$@"