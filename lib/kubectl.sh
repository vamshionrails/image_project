#!/bin/bash

# Function to install kubectl
install_kubectl() {
    KUBECTL_VERSION="v1.28.0"
    echo "Installing kubectl version $KUBECTL_VERSION..."
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl"
    chmod +x kubectl
    mv kubectl /usr/local/bin/
    echo "kubectl installed successfully."
}

 
# Function to install Helm
install_helm() {
    HELM_VERSION="v3.8.0"  # Specify the Helm version you want to install
    echo "Installing Helm version $HELM_VERSION..."
    
    # Download Helm binary
    curl -LO "https://get.helm.sh/helm-$HELM_VERSION-linux-amd64.tar.gz"
    tar -zxvf helm-$HELM_VERSION-linux-amd64.tar.gz
    
    # Move Helm binary to a directory in your PATH
    mv linux-amd64/helm /usr/local/bin/
    
    # Cleanup
    rm -rf linux-amd64 helm-$HELM_VERSION-linux-amd64.tar.gz
    
    echo "Helm installed successfully."

    # Install helm packages
    kubectl delete ns kubernetes-dashboard 
    helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
    helm install dashboard kubernetes-dashboard/kubernetes-dashboard -n kubernetes-dashboard --create-namespace
    cd /tmp
    kubectl apply -f serviceaccount.yaml
    touch /tmp/token
    kubectl -n kubernetes-dashboard create token admin-user > /tmp/token
    nohup kubectl proxy --address='0.0.0.0' --accept-hosts='^*$' > /tmp/out.log 2>&1 &
}

install_karpenter() {
    KARPENTER_VERSION="v0.22.0"  # Specify the Karpenter version you want to install
    echo "Installing Karpenter version $KARPENTER_VERSION..."

    # Download Karpenter binary
    curl -Lo karpenter https://github.com/awslabs/karpenter/releases/download/${KARPENTER_VERSION}/karpenter-linux-amd64

    # Make Karpenter executable
    chmod +x karpenter

    # Move Karpenter binary to a directory in your PATH
     mv karpenter /usr/local/bin/

    echo "Karpenter installed successfully."
}
 

# Install kubectl
install_kubectl

# Install kind
install_kind

install_helm
install_karpenter
 

echo "kubectl and kind have been installed."