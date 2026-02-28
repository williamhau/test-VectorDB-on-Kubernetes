#!/bin/bash

set -a
source ../.env
set +a
# This script sets up a PostgreSQL database with the pgvector extension using Docker Compose.
# 1. Start in background
docker  compose -f docker-pgvectorscale-compose.yml up -d

# 2. Look at logs
docker compose -f docker-pgvectorscale-compose.yml logs -f

# 3. Stop and remove containers
docker  compose -f docker-pgvectorscale-compose.yml down
