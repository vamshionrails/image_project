#!/bin/bash

# Function to create Helm charts folder
create_helmcharts_folder() {
    HELM_CHARTS_DIR=$1

    if [ ! -d "$HELM_CHARTS_DIR" ]; then
        mkdir -p "$HELM_CHARTS_DIR"
        echo "Helm charts folder created at '$HELM_CHARTS_DIR'."
    else
        echo "Helm charts folder already exists at '$HELM_CHARTS_DIR'."
    fi
}
