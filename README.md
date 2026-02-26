# Test Vector Database on Kubernetes

A comprehensive testing environment for comparing vector database solutions (pgvector, Qdrant, and ChromaDB) deployed on Kubernetes using MicroK8s.

## Overview

This project demonstrates how to deploy and test multiple vector database solutions for semantic search and document retrieval applications. It includes Docker Compose configurations for local development and Kubernetes manifests for production-like deployments.

## Supported Vector Databases

- **pgvector** - PostgreSQL extension for vector similarity search
- **Qdrant** - Purpose-built vector search engine
- **ChromaDB** - AI-native embedding database

## Project Structure

```
testVectorDB/
├── docker/                          # Docker configurations
│   ├── docker-compose.yaml          # Combined setup (pgvector + Qdrant)
│   ├── docker-pgvector-compose.yml  # pgvector standalone
│   └── docker-qdrant-compose.yml    # Qdrant standalone
├── kubernetes/                      # Kubernetes deployment files
│   ├── vector-deploy.yaml           # K8s deployment manifests
│   ├── install-microk8s.sh          # MicroK8s installation script
│   ├── push-docker-image.sh         # Push images to local registry
│   ├── deploy-docker.sh             # Deploy to Kubernetes
│   └── monitor-kube.sh              # Monitoring utilities
├── data/                            # Sample PDF documents
├── testpgvector.ipynb               # pgvector test notebook
├── testQdrant.ipynb                 # Qdrant test notebook
└── testChroma.ipynb                 # ChromaDB test notebook
```

## Prerequisites

- Python 3.12+
- Docker & Docker Compose
- MicroK8s (for Kubernetes deployment)
- 4GB+ RAM recommended

## Quick Start

### 0. Environment Setup

**Create environment file:**
```bash
cp .env.example .env
# Edit .env and set your secure password
```

**Example .env file:**
```bash
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_secure_password_here
POSTGRES_DB=vectordb
```

### 1. Local Development with Docker

**Start all databases:**
```bash
cd docker
docker-compose up -d
```

**Or start individually:**
```bash
# pgvector only
docker-compose -f docker-pgvector-compose.yml up -d

# Qdrant only
docker-compose -f docker-qdrant-compose.yml up -d
```

**Access endpoints:**
- pgvector: `localhost:5432`
- Qdrant: `localhost:6333` (HTTP), `localhost:6334` (gRPC)

### 2. Kubernetes Deployment

**Install MicroK8s:**
```bash
cd kubernetes
bash install-microk8s.sh
```

**Create Kubernetes secrets:**
```bash
bash create-secrets.sh
```

**Push images to local registry:**
```bash
bash push-docker-image.sh
```

**Deploy to Kubernetes:**
```bash
bash deploy-docker.sh
```

**Verify deployment:**
```bash
microk8s kubectl get pods
microk8s kubectl get services
```

## Python Environment Setup

```bash
# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install langchain-postgres langchain-qdrant langchain-chroma \
            pypdf sentence-transformers psycopg[binary] \
            qdrant-client chromadb python-dotenv
```

## Usage Examples

### pgvector Example

```python
import os
from dotenv import load_dotenv
from langchain_postgres import PGVector
from langchain_community.embeddings import SentenceTransformerEmbeddings

# Load environment variables
load_dotenv()

embeddings = SentenceTransformerEmbeddings(model_name="all-MiniLM-L6-v2")
connection_string = f"postgresql://{os.getenv('POSTGRES_USER')}:{os.getenv('POSTGRES_PASSWORD')}@localhost:5432/{os.getenv('POSTGRES_DB')}"

vector_store = PGVector(
    connection_string=connection_string,
    embedding_function=embeddings
)
```
```

### Qdrant Example

```python
from qdrant_client import QdrantClient
from langchain_qdrant import QdrantVectorStore

client = QdrantClient(url="http://localhost:6333")
vector_store = QdrantVectorStore(
    client=client,
    collection_name="documents",
    embedding=embeddings
)
```

### ChromaDB Example

```python
from langchain_chroma import Chroma

vector_db = Chroma(
    persist_directory="./chroma_db_store",
    embedding_function=embeddings
)
```

## Test Notebooks

Each notebook demonstrates:
1. Database connection setup
2. PDF document loading and chunking
3. Vector embedding generation
4. Document ingestion
5. Semantic similarity search

Run notebooks:
```bash
jupyter notebook testpgvector.ipynb
jupyter notebook testQdrant.ipynb
jupyter notebook testChroma.ipynb
```

## Kubernetes Services

The deployment creates the following services:

| Service | Type | Port | Target |
|---------|------|------|--------|
| pgvector-service | ClusterIP | 5432 | pgvector pod |
| qdrant-service | ClusterIP | 6333 | Qdrant pod |

## Configuration

### Environment Variables
Create a `.env` file in the project root with:
```bash
POSTGRES_USER=postgres
POSTGRES_PASSWORD=your_secure_password_here
POSTGRES_DB=vectordb
```

### pgvector
- **User:** Set via `POSTGRES_USER` env variable
- **Password:** Set via `POSTGRES_PASSWORD` env variable
- **Database:** Set via `POSTGRES_DB` env variable
- **Port:** 5432

### Qdrant
- **HTTP Port:** 6333
- **gRPC Port:** 6334
- **Storage:** Persistent volume

### ChromaDB
- **Storage:** Local directory (`./chroma_db_store`)
- **Mode:** Embedded (no server required)

## Monitoring

Monitor Kubernetes resources:
```bash
# Watch pods
microk8s kubectl get pods -w

# Check logs
microk8s kubectl logs -f <pod-name>

# Service status
microk8s kubectl get svc
```

## Troubleshooting

**MicroK8s issues:**
```bash
# Restart MicroK8s
bash kubernetes/microk8s-restart.sh

# Check status
microk8s status
```

**Connection issues:**
```bash
# Port forwarding for local access
microk8s kubectl port-forward svc/pgvector-service 5432:5432
microk8s kubectl port-forward svc/qdrant-service 6333:6333
```

**Fix common issues:**
```bash
bash kubernetes/fix-issue.sh
```

## Performance Comparison

Each notebook includes semantic search examples. Compare:
- Query response time
- Relevance of results
- Memory usage
- Ease of deployment

## Contributing

Feel free to submit issues or pull requests for improvements.

## License

MIT License

## Repository

https://github.com/williamhau/test-VectorDB-on-Kubernetes
