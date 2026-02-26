#!/bin/bash
# This script is intended to fix the issue with the Kubernetes dashboard in MicroK8s. 
# It will uninstall the existing dashboard and then reinstall it using Helm, 
# which should resolve any issues with the dashboard not working properly.
microk8s helm3 repo add kubernetes-dashboard https://kubernetes-retired.github.io/dashboard/
microk8s helm3 repo update
microk8s helm3 repo list
microk8s helm3 search repo kubernetes-dashboard
# Uninstall the existing dashboard
# Note: This will remove the dashboard and all its resources, so use with caution.
microk8s helm3 uninstall kubernetes-dashboard -n kubernetes-dashboard
microk8s kubectl delete namespace kubernetes-dashboard  

# Reinstall the dashboard using Helm
microk8s helm3 upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard \
  --create-namespace \
  --namespace kubernetes-dashboard
microk8s enable dashboard
microk8s kubectl get pods -A | grep dashboard
journalctl -u snap.microk8s.daemon-cluster-agent
microk8s disable dashboard

# Reinstalling the dashboard using kubectl
microk8s kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v2.7.0/aio/deploy/recommended.yaml
microk8s kubectl get pods -n kubernetes-dashboard

# Create a ServiceAccount and ClusterRoleBinding for dashboard access
cat <<EOF | microk8s kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-user
  namespace: kubernetes-dashboard
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: admin-user
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: admin-user
  namespace: kubernetes-dashboard
EOF

# Get the token for the admin-user
microk8s kubectl -n kubernetes-dashboard create token admin-user

# create a "Long-lived" token. This creates a Secret that stays valid until you manually delete it.
cat <<EOF | microk8s kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: admin-user-token
  namespace: kubernetes-dashboard
  annotations:
    kubernetes.io/service-account.name: admin-user
type: kubernetes.io/service-account-token
EOF

# Get the token value from the Secret
microk8s kubectl -n kubernetes-dashboard get secret admin-user-token -o jsonpath={".data.token"} | base64 -d

microk8s kubectl port-forward -n kubernetes-dashboard service/kubernetes-dashboard 8443:443
# open your browser to: https://localhost:8443

