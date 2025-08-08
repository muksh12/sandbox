FROM python:3.10-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app
COPY . /app

# Install required system packages: curl, unzip, netcat; install Cloud SQL Proxy; install Python deps
RUN apt-get update && apt-get install -y curl unzip netcat-traditional jq && \
    curl -sSL -o /usr/local/bin/cloud-sql-proxy https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.10.0/cloud-sql-proxy.linux.amd64 && \
    chmod +x /usr/local/bin/cloud-sql-proxy && \
    pip install --upgrade pip && \
    pip install flask requests gunicorn psycopg2-binary && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 8080
CMD ["/entrypoint.sh"]