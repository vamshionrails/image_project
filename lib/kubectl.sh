#!/bin/bash

# Function to install kubectl
install_kubectl() {
    KUBECTL_VERSION="v1.22.2"
    echo "Installing kubectl version $KUBECTL_VERSION..."
    curl -LO "https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl"
    chmod +x kubectl
    mv kubectl /usr/local/bin/
    echo "kubectl installed successfully."
}

# Function to install kind
install_kind() {
    KIND_VERSION="v0.11.1"
    echo "Installing kind version $KIND_VERSION..."
    curl -Lo ./kind "https://kind.sigs.k8s.io/dl/$KIND_VERSION/kind-linux-amd64"
    chmod +x kind
    mv kind /usr/local/bin/
    echo "kind installed successfully."
}

# Install kubectl
install_kubectl

# Install kind
install_kind

echo "kubectl and kind have been installed."