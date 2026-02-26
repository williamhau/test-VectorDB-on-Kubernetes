#!/bin/bash
# This script is intended to deploy the Qdrant vector database in a MicroK8s cluster using a Kubernetes manifest file (vector-deploy.yaml).
# It will apply the manifest to create the necessary resources for Qdrant, such as Deployments, Services, and PersistentVolumeClaims.
# Make sure you have MicroK8s installed and running before executing this script.
# Also, ensure that the vector-deploy.yaml file is in the same directory as this script or provide the correct path to it.
microk8s kubectl apply -f vector-deploy.yaml
