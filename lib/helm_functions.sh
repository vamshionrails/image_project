#!/bin/bash

update_helm_repo_index() {
    local HELM_CHARTS_DIR="./helmcharts"

    # Check if the index.yaml file exists
    if [ ! -f "$HELM_CHARTS_DIR/index.yaml" ]; then
        # Create the index.yaml file if it doesn't exist
        touch "$HELM_CHARTS_DIR/index.yaml"
        echo "index.yaml created: $HELM_CHARTS_DIR/index.yaml"
    else
        echo "index.yaml already exists: $HELM_CHARTS_DIR/index.yaml"
    fi

    # Create or update the Helm repository index
    helm repo index "$HELM_CHARTS_DIR" --url "file://$HELM_CHARTS_DIR"
    echo "Helm repository index updated in $HELM_CHARTS_DIR."
}


helm_package() {
    local ENV_FILE="$1"

    # Read variables from env.json
    HELM_CHARTS_DIR=$(jq -r '.HELM_CHARTS_DIR' "$ENV_FILE")
    HELM_PACKAGE_DIR=$(jq -r '.HELM_PACKAGE_DIR' "$ENV_FILE")

    echo "Helm charts Directory: ${HELM_CHARTS_DIR}"
    echo "Helm package Directory: ${HELM_PACKAGE_DIR}"

    # Create the Helm packages directory if it doesn't exist
    mkdir -p "$HELM_PACKAGE_DIR"

    # Package all Helm charts in the helmcharts folder
    for chart_dir in "${HELM_CHARTS_DIR}"/*/; do
        if [ -f "$chart_dir/Chart.yaml" ]; then
            chart_name=$(basename "$chart_dir")
            echo "Helm chart found: $chart_name"


            helm package "$chart_dir" -d "$HELM_PACKAGE_DIR"
            echo "Helm chart packaged: $chart_dir"



        fi
    done
}





create_helm_repo() {
    local HELM_CHARTS_DIR="./helmcharts"

    # Check if the helmcharts folder exists
    if [ ! -d "$HELM_CHARTS_DIR" ]; then
        # Create the helmcharts folder if it doesn't exist
        mkdir -p "$HELM_CHARTS_DIR"
        echo "Helm charts directory created: $HELM_CHARTS_DIR"
    else
        echo "Helm charts directory already exists: $HELM_CHARTS_DIR"
    fi

    # Update the Helm repository index
    update_helm_repo_index
    echo "Helm repository created successfully in $HELM_CHARTS_DIR."
}

# Source the helm_artifacts.sh file
source ./lib/helm_artifacts.sh
