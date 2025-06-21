#!/bin/bash

ROLE=$1
HOSTNAME=$(hostname)

# Install Docker
sudo apt-get update && sudo apt-get install -y docker.io
sudo systemctl enable docker && sudo systemctl start docker

# Install Kubernetes tools
sudo apt-get install -y apt-transport-https curl gpg # apt-transport-https enables secure connections for the package manager
sudo mkdir -p /etc/apt/keyrings

sudo rm -f /etc/apt/keyrings/kubernetes-archive-keyring.gpg
# These two lines allow to trust the Kubernetes packages and know where to download them from.
    curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
    echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# kubeadm: the command to bootstrap the cluster.
# kubelet: the component that runs on all of the machines in your cluster and does things like starting pods and containers.
# kubectl: the command line util to talk to your cluster.
sudo apt-get update && sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl

# Disable swap (MUST be disable in order for the kubelet to work properly)
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# Master configuration
# 192.168.56.10 - IP address that the API Server will advertise to other nodes and clients 
# 10.244.0.0 - IP address range for the Pod network, especially when using Flannel as the Container Network Interface (CNI)
if [ "$ROLE" = "master" ]; then
# 10.244.0.0/16 range typically forms a network overlay on top of the existing host network (192.168.56.x)
  kubeadm init --apiserver-advertise-address=192.168.56.10 --pod-network-cidr=10.244.0.0/16 

  mkdir -p /home/vagrant/.kube
  sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config # Allowing the vagrant user to interact with the Kubernetes cluster
  sudo chown vagrant:vagrant /home/vagrant/.kube/config

# Install Flannel CNI(Container Network Interface) plugin in Kubernetes cluster
  su - vagrant -c "kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml"

# Save the join command (generate and securely share the command that worker nodes will use to join the cluster)
  kubeadm token create --print-join-command > /vagrant/join.sh

elif [ "$ROLE" = "node" ]; then
  while [ ! -f /vagrant/join.sh ]; do sleep 5; done
  cp /vagrant/join.sh /tmp/join.sh
  chmod +x /tmp/join.sh
  /tmp/join.sh # Allow to connect to and join the Kubernetes cluster
fi
