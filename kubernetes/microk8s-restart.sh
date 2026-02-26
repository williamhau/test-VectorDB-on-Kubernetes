#!/bin/bash
# This script is intended to restart the MicroK8s cluster.
# It will stop the cluster, start it again, and check its status to ensure it's running properly.
microk8s stop
microk8s start
# Check the status of MicroK8s
microk8s status --wait-ready
# Running the Dashboard in the Background
microk8s kubectl port-forward -n kubernetes-dashboard service/kubernetes-dashboard 8443:443 &