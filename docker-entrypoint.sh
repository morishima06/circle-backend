#!/bin/sh
set -e

if [ "$RAILS_ENV" = "production" ]; then
  echo "Resetting production database..."
  DISABLE_DATABASE_ENVIRONMENT_CHECK=1 bundle exec rails db:reset
fi

echo "Starting Rails server..."

exec "$@"

# set -e

# if [ "$RAILS_ENV" = "production" ]; then
#   echo "Running database migrations..."
#   bundle exec rails db:migrate
# fi

# echo "Starting Rails server..."

# exec "$@"

