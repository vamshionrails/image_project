#!/bin/bash

HELM_CHARTS_DIR="../helmcharts"
HELLOWORLD_CHART_DIR="${HELM_CHARTS_DIR}/helloworld"
INDEX_FILE="${HELM_CHARTS_DIR}/index.yaml"
GHCR_REGISTRY="ghcr.io/vamshionrails"
GHCR_USERNAME="vamshionrails"
GHCR_TOKEN="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"

# Function to create Hello World application
create_helloworld() {
    echo "Creating Hello World application..."
    
    # Check if helloworld Helm chart directory exists
    if [ -d "$HELLOWORLD_CHART_DIR" ]; then
        echo "Helloworld Helm chart already exists. Skipping creation."
    else
        # Create the helloworld Helm chart
        helm create "$HELLOWORLD_CHART_DIR"
        echo "Hello World application created!"
    fi
}

# Package Hello World application using Helm
helm_package_helloworld() {
    echo "Packaging Hello World application using Helm..."
    
    # Package the helloworld Helm chart
    helm package "$HELLOWORLD_CHART_DIR" -d "$HELM_CHARTS_DIR"

    echo "Hello World application packaged using Helm!"
}
# Update Helm chart index
update_helm_chart_index() {
    echo "Updating Helm chart index..."
    
    # Use helm index to update the Helm chart index
    helm repo index "$HELM_CHARTS_DIR" --url "https://${GHCR_REGISTRY}/helm-charts"

    echo "Helm chart index updated!"
}

# Push Helm packages to ghcr.io using helm push
push_to_ghcr() {
    echo "Pushing Helm packages to ghcr.io..."
    
    # Authenticate with GitHub Container Registry
    echo "${GHCR_TOKEN}" | docker login ghcr.io -u "${GHCR_USERNAME}" --password-stdin

    # Check if any .tgz files exist in the specified directory
    if [ -n "$(find "${HELM_CHARTS_DIR}" -maxdepth 1 -name '*.tgz' -print -quit)" ]; then
        # Iterate over each packaged Helm chart and push to ghcr.io using helm push
        for chart in "${HELM_CHARTS_DIR}"/*.tgz; do
          helm push "${chart}" oci://ghcr.io/vamshionrails/image_project
        done

        echo "Helm packages pushed to ghcr.io!"
    else
        echo "No .tgz files found in ${HELM_CHARTS_DIR}. Check the packaging step."
    fi
}

# Function to list Helm chart packages in helmcharts folder
list_helm_packages() {
    echo "Listing Helm chart packages in ${HELM_CHARTS_DIR}..."
    
    # Check if any .tgz files exist in the specified directory
    if [ -n "$(find "${HELM_CHARTS_DIR}" -maxdepth 1 -name '*.tgz' -print -quit)" ]; then
        # List all .tgz files in the specified directory
        for chart in "${HELM_CHARTS_DIR}"/*.tgz; do
            echo "$(basename "${chart}")"
        done
    else
        echo "No Helm chart packages found in ${HELM_CHARTS_DIR}."
    fi
}




# Function to dynamically create Helmfile with charts from ghcr.io in helmcharts folder
create_dynamic_helmfile_ghcr() {
    echo "Creating dynamic Helmfile with charts from ghcr.io in ${HELM_CHARTS_DIR}..."
    
    # Check if Helmfile already exists
    if [ -f "${HELM_CHARTS_DIR}/helmfile.yaml" ]; then
        echo "Helmfile already exists. Skipping creation."
    else
        # Create a dynamic Helmfile including charts from ghcr.io
        cat <<EOF > "${HELM_CHARTS_DIR}/helmfile.yaml"
releases:
EOF

        # Fetch a list of charts from ghcr.io (replace 'your-ghcr-username' with your actual username)
        GHCR_USERNAME="vamshionrails"
        GHCR_REGISTRY="ghcr.io"

        ghcr_charts=$(curl -s "https://api.github.com/users/${GHCR_USERNAME}/packages/container/helm/ghcr.io?per_page=100" | jq -r '.[] | .name')

        # Iterate over each ghcr.io chart and add it to Helmfile
        for ghcr_chart in ${ghcr_charts}; do
            cat <<EOF >> "${HELM_CHARTS_DIR}/helmfile.yaml"
  - name: ${ghcr_chart}
    repository: ghcr.io/${GHCR_USERNAME}
    chart: ${ghcr_chart}
    version: "0.1.0" # replace with the desired version
EOF
        done

        echo "Dynamic Helmfile created with charts from ghcr.io in ${HELM_CHARTS_DIR}."
    fi
}


delete_helm_packages() {
    echo "Deleting Helm chart packages in ${HELM_CHARTS_DIR}..."

    # Check if any .tgz files exist in the specified directory
    if [ -n "$(find "${HELM_CHARTS_DIR}" -maxdepth 1 -name '*.tgz' -print -quit)" ]; then
        # List all .tgz files in the specified directory
        for chart in "${HELM_CHARTS_DIR}"/*.tgz; do
            rm -f "${chart}"
            echo "Deleted: $(basename "${chart}")"
        done

        echo "All Helm chart packages deleted in ${HELM_CHARTS_DIR}."
    else
        echo "No Helm chart packages found in ${HELM_CHARTS_DIR}."
    fi
}

 





# Main script
create_helloworld
helm_package_helloworld
update_helm_chart_index
push_to_ghcr
list_helm_packages
#delete_helm_packages
# Call the function to create dynamic Helmfile
create_dynamic_helmfile_ghcr
