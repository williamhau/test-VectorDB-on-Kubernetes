#!/bin/bash
# Create Kubernetes secret for PostgreSQL credentials
# This script reads from .env file and creates a Kubernetes secret

# Load environment variables from .env file
if [ -f ../.env ]; then
    export $(cat ../.env | grep -v '^#' | xargs)
else
    echo "Error: .env file not found. Please create one from .env.example"
    exit 1
fi

# Create Kubernetes secret
microk8s kubectl create secret generic postgres-secret \
    --from-literal=username="${POSTGRES_USER:-postgres}" \
    --from-literal=password="${POSTGRES_PASSWORD}" \
    --from-literal=database="${POSTGRES_DB:-vectordb}" \
    --dry-run=client -o yaml | microk8s kubectl apply -f -

echo "Kubernetes secret 'postgres-secret' created successfully"
