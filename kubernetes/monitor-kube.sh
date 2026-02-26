#!/bin/bash
# This script is intended to monitor the Kubernetes cluster in MicroK8s.
# It will continuously check the status of the pods and print their logs if they are not running properly.
microk8s kubectl get pods

# Continuously monitor the pods and print logs if they are not running properly
microk8s kubectl get pods -A -w

# If you want to check the logs of a specific pod, you can use the following command:
# Replace <pod-name> and <namespace> with the actual pod name and namespace
# microk8s kubectl logs <pod-name> -n <namespace>
microk8s kubectl logs -l app=qdrant

microk8s enable dashboard
microk8s kubectl get deployments -A | grep dashboard
microk8s dashboard-proxy
microk8s disable dashboard