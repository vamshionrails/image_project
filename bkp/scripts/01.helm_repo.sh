#!/bin/bash

# Define the folder and file
folder="../helmcharts"
file="../helmcharts/index.yaml"

# Function to create the folder
create_folder() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
        echo "Folder '$1' created."
    else
        echo "Folder '$1' already exists."
    fi
}

# Function to create the file
create_file() {
    cd "$1" || exit
    if [ ! -f "$2" ]; then
        touch "$2"
        echo "File '$2' created."
    else
        echo "File '$2' already exists."
    fi
}


# Function to update Helm index
update_helm_index() {
    helm repo index "$1" --url "$2"
    echo "Helm index updated for '$1'."
}

# Create the helmcharts folder
create_folder "$folder"

# Navigate to the helmcharts folder and create the file
create_file "$folder" "$file"

# Update Helm index
update_helm_index "$folder" "https://example.com/helmcharts"
