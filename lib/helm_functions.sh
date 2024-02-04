#!/bin/bash



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

            #cr upload --config config.yaml
             cr package "$chart_dir" -p "$HELM_PACKAGE_DIR"
            #helm package "$chart_dir" -d "$HELM_PACKAGE_DIR"
            echo "Helm chart packaged: $chart_dir"
            
        fi
    done
}


helm_repo_function() {
    local ENV_FILE="$1"
    HELM_CHARTS_DIR=$(jq -r '.HELM_CHARTS_DIR' "$ENV_FILE")

    echo "Helm charts Directory: ${HELM_CHARTS_DIR}"

    # Check if the helmcharts folder exists
    if [ ! -d "$HELM_CHARTS_DIR" ]; then
        # Create the helmcharts folder if it doesn't exist
        mkdir -p "$HELM_CHARTS_DIR"
        echo "Helm charts directory created: $HELM_CHARTS_DIR"
    else
        echo "Helm charts directory already exists: $HELM_CHARTS_DIR"
    fi

    # Check if the index.yaml file exists
    if [ ! -f "$HELM_CHARTS_DIR/index.yaml" ]; then
        # Create the index.yaml file if it doesn't exist
        touch "$HELM_CHARTS_DIR/index.yaml"
        echo "index.yaml created: $HELM_CHARTS_DIR/index.yaml"
    else
        echo "index.yaml already exists: $HELM_CHARTS_DIR/index.yaml"
    fi

    # Read variables from env.json
    CR_TOKEN=$(jq -r '.GHCR_TOKEN' "$ENV_FILE")

    # Create or update the Helm repository index using Chart Releaser
    cr index --config "configs/cr_config.yaml" --packages-with-index --index-path "$HELM_CHARTS_DIR"
    echo "Chart Releaser index updated in $HELM_CHARTS_DIR."

    # Display a message based on whether the directory was created or updated
    action_message="Helm charts directory created"
    [ -d "$HELM_CHARTS_DIR" ] && action_message="Helm repository updated"

    echo "$action_message successfully in $HELM_CHARTS_DIR."
}

