# Install MicroK8s via snap
sudo snap install microk8s --classic

# Add your user to the microk8s group for permission-free access
sudo usermod -a -G microk8s $USER
mkdir -p ~/.kube
sudo chown -f -R $USER ~/.kube

# Re-log or run this to apply group changes
newgrp microk8s

# Enable essential add-ons (DNS and local storage are required for DBs)
microk8s enable dns storage
