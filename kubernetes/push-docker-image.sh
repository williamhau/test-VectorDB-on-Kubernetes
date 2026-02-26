# Enable the built-in registry
microk8s enable registry

# Tag your existing local images for the MicroK8s registry (port 32000)
docker tag pgvector/pgvector:pg17 localhost:32000/my-pgvector:v1
docker tag qdrant/qdrant:latest localhost:32000/my-qdrant:v1

# Push them into the cluster
docker push localhost:32000/my-pgvector:v1
docker push localhost:32000/my-qdrant:v1
