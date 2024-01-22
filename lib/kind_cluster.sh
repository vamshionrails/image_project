# Function to install kind
install_kind() {
    KIND_VERSION="v0.20.0" # Specify the desired KinD version
    echo "Installing kind version $KIND_VERSION..."
    curl -Lo ./kind "https://kind.sigs.k8s.io/dl/$KIND_VERSION/kind-linux-amd64"
    chmod +x kind
    mv kind /usr/local/bin/
    echo "kind installed successfully."
}

# Function to create a KinD cluster
create_kind_cluster() {
    CLUSTER_NAME="my-kind-cluster"
    K8S_VERSION="v1.28.0"  # Specify the desired Kubernetes version
    KIND_VERSION="v0.20.0" # Specify the desired KinD version
    CLUSTER_CONFIG_FILE="cluster.yaml"  # Specify the path to your cluster configuration file 
     # Create KinD cluster using the specified configuration file
    kind create cluster --config $CLUSTER_CONFIG_FILE
    echo "KinD cluster created successfully."

    # Update kubectl configuration
    echo "Updating kubectl configuration..."
    kind export kubeconfig --name my-kind-cluster
}

# Call the function
install_kind
#create_kind_cluster