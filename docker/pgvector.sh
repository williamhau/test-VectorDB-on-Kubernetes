#!/bin/bash

# This script sets up a PostgreSQL database with the pgvector extension using Docker Compose.
docker compose -f docker-pgvector-compose.yml up -d

#   Wait for the database to be ready
docker compose -f docker-pgvector-compose.yml logs -f

# To stop and remove the containers, you can run:
docker compose -f docker-pgvector-compose.yml down

# After the database is up and running, you can connect to it and create the pgvector extension:
docker exec -it pgvector-db psql -U postgres -d vectordb -c "CREATE EXTENSION IF NOT EXISTS vector;"
docker exec -it pgvector-db psql -U postgres -d vectordb -c "SELECT '[1,2,3]'::vector <-> '[1,2,4]'::vector AS distance;"

# Check the status of the containers
docker ps

