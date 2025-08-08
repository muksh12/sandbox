#!/bin/bash
set -e

# Get access token from metadata service
ACCESS_TOKEN=$(curl -s -H "Metadata-Flavor: Google" \
  "http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token" \
  | jq -r .access_token)
  
export PGPASSWORD="$ACCESS_TOKEN"

# Start Cloud SQL Proxy with token
echo "Starting Cloud SQL Proxy for instance: $CLOUD_SQL_INSTANCE"
cloud-sql-proxy "$CLOUD_SQL_INSTANCE" --psc --port=5432 --token="$ACCESS_TOKEN" &
PROXY_PID=$!

# Wait for proxy to be ready
echo "Waiting for Cloud SQL Proxy to be ready..."
for i in {1..10}; do
    if nc -z 127.0.0.1 5432; then
        echo "Cloud SQL Proxy is ready."
        break
    fi
    echo "Waiting for proxy (attempt $i)..."
    sleep 2
done

PORT=${PORT:-8080}
echo "Starting Gunicorn..."
exec gunicorn --bind 0.0.0.0:$PORT --timeout 1800 handler:app