#!/bin/bash

# Define constants
CONFIG_FILE="configs/env.json"

# Source functions from the lib folder
source "$(dirname "${BASH_SOURCE[0]}")/../lib/config_functions.sh"
#source "$(dirname "${BASH_SOURCE[0]}")/../lib/helm_functions.sh"
source "$(dirname "${BASH_SOURCE[0]}")/../lib/config_helm_repo.sh"

# Main script

# Validate json and display content

display_config_content
validate_json

#create a helm chart if you want to test helm chart
#create_helloworld



# Call the functions from the lib/helm_functions.sh file
# Call the new function to create the Helm charts folder
create_helmcharts_folder "$HELM_CHARTS_FOLDER"
create_helmfile "$HELM_CHARTS_FOLDER" "$INDEX_FILE"
update_helm_index "$HELM_CHARTS_FOLDER" "$REPO_URL"
