#!/bin/bash

# This script sets up a Qdrant vector database using Docker Compose.
docker compose -f docker-qdrant-compose.yml up -d

#   Wait for the database to be ready
docker compose -f docker-qdrant-compose.yml logs -f

# To stop and remove the containers, you can run:
docker compose -f docker-qdrant-compose.yml down

# Check the status of the containers
curl http://localhost:6333/healthz