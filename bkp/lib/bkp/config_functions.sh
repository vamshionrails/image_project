#!/bin/bash

# Define constants
CONFIG_FILE="../configs/env.json"

# Function to load variables from the env.json file
load_config() {
    # Use the constant
    if ! jq empty "$CONFIG_FILE" &> /dev/null; then
        echo "Error: Invalid JSON format in the config file."
        exit 1
    fi

    if [ -f "$CONFIG_FILE" ]; then
        # Load variables from the env.json file
        GITHUB_REGISTRY=$(jq -r '.GITHUB_REGISTRY' "$CONFIG_FILE")
        GITHUB_USERNAME=$(jq -r '.GITHUB_USERNAME' "$CONFIG_FILE")
        GITHUB_TOKEN=$(jq -r '.GITHUB_TOKEN' "$CONFIG_FILE")
        HELM_CHARTS_FOLDER=$(jq -r '.HELM_CHARTS_DIR' "$CONFIG_FILE")
        HELM_CHARTS_FOLDER=$(jq -r '.HELM_CHARTS_DIR' "$CONFIG_FILE")
        INDEX_FILE=$(jq -r '.INDEX_FILE' "$CONFIG_FILE")
        REPO_URL=$(jq -r '.HELM_REPO_URL' "$CONFIG_FILE")
        if [ -z "$GITHUB_REGISTRY" ] || [ -z "$GITHUB_USERNAME" ] || [ -z "$GITHUB_TOKEN" ]; then
            echo "Error: Required fields (GITHUB_REGISTRY, GITHUB_USERNAME, GITHUB_TOKEN) missing in the config file."
            echo "Contents of loaded variables:"
            echo "GITHUB_REGISTRY: $GITHUB_REGISTRY"
            echo "GITHUB_USERNAME: $GITHUB_USERNAME"
            echo "GITHUB_TOKEN: $GITHUB_TOKEN"
            exit 1
        fi
    else
        echo "Error: Config file not found."
        exit 1
    fi
}

# Function to validate the presence of required fields in the JSON file
validate_json() {
    load_config
}

# Function to display the content of the config.json file
display_config_content() {
    echo "Displaying content of the config file..."
    CONFIG_FILE="../configs/env.json"
    if [ -f "$CONFIG_FILE" ]; then
        jq '.' "$CONFIG_FILE"
    else
        echo "Error: Config file not found."
        exit 1
    fi
}
