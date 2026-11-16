
#!/bin/sh
set -e

echo "Running database migrations..."

RAILS_ENV=production bundle exec rails db:migrate

echo "Starting Rails server..."

exec bundle exec rails server -b 0.0.0.0 -p 5001
