# lib/helm_functions.sh

#!/bin/bash


# Function to create the Helm charts folder
create_helmcharts_folder() {
    HELM_CHARTS_FOLDER="$1"
    
    if [ -z "$HELM_CHARTS_FOLDER" ]; then
        echo "Error: HELM_CHARTS_FOLDER is not set. Check your variable assignment in env.json."
        exit 1
    fi

    if [ ! -d "$HELM_CHARTS_FOLDER" ]; then
        mkdir -p "$HELM_CHARTS_FOLDER"
        echo "Helm charts folder '$HELM_CHARTS_FOLDER' created."
    else
        echo "Helm charts folder '$HELM_CHARTS_FOLDER' already exists."
    fi
}


# Function to create the Helmfile
create_helmfile() {
    HELMFILE_FOLDER="$1"
    
    if [ -z "$HELMFILE_FOLDER" ]; then
        echo "Error: HELMFILE_FOLDER is not set. Check your variable assignment in env.json."
        exit 1
    fi

    if [ ! -d "$HELMFILE_FOLDER" ]; then
        mkdir -p "$HELMFILE_FOLDER"
        echo "Helmfile folder '$HELMFILE_FOLDER' created."
    else
        echo "Helmfile folder '$HELMFILE_FOLDER' already exists."
    fi
}

# Function to update Helm index
update_helm_index() {
    HELM_CHARTS_FOLDER="$1"
    REPO_URL="$2"

    if [ -z "$HELM_CHARTS_FOLDER" ] || [ -z "$REPO_URL" ]; then
        echo "Error: HELM_CHARTS_FOLDER or REPO_URL is not set. Check your variable assignment in env.json."
        exit 1
    fi

    helm repo index "$HELM_CHARTS_FOLDER" --url "$REPO_URL"
    echo "Helm index updated for '$HELM_CHARTS_FOLDER'."
}
