# lib/helm_artifacts.sh

#!/bin/bash

publish_to_ghcr() {
    local ENV_FILE="$1"

    echo "Pushing Helm packages to ghcr.io..."

    # Read variables from env.json
    GHCR_USERNAME=$(jq -r '.GHCR_USERNAME' "$ENV_FILE")
    GHCR_TOKEN=$(jq -r '.GHCR_TOKEN' "$ENV_FILE")
    HELM_CHARTS_DIR=$(jq -r '.HELM_CHARTS_DIR' "$ENV_FILE")

     # Authenticate with GitHub Container Registry
    echo "${GHCR_TOKEN}" | docker login ghcr.io -u "${GHCR_USERNAME}" --password-stdin

    # Check if any .tgz files exist in the specified directory
    if [ -n "$(find "${HELM_CHARTS_DIR}/helm_packages" -maxdepth 1 -name '*.tgz' -print -quit)" ]; then
        # Iterate over each packaged Helm chart and push to ghcr.io using helm push
        for chart in "${HELM_CHARTS_DIR}"/helm_packages/*.tgz; do
          helm push "${chart}" oci://ghcr.io/vamshionrails/image_project
        done

        echo "Helm packages pushed to ghcr.io!"
    else
        echo "No .tgz files found in ${HELM_CHARTS_DIR}. Check the packaging step."
    fi


}

clean_helm_packages() {
    local ENV_FILE="$1"
   HELM_CHARTS_DIR=$(jq -r '.HELM_CHARTS_DIR' "$ENV_FILE")
     # Check if any .tgz files exist in the specified directory
    if [ -n "$(find "${HELM_CHARTS_DIR}/helm_packages" -maxdepth 1 -name '*.tgz' -print -quit)" ]; then
        # Iterate over each packaged Helm chart and push to ghcr.io using helm push
        for chart in "${HELM_CHARTS_DIR}"/helm_packages/*.tgz; do
          rm -rf "${HELM_CHARTS_DIR}"/helm_packages/*.tgz
        done

        echo "Helm packages cleaned"
    else
        echo "No .tgz files found in ${HELM_CHARTS_DIR}. Check the packaging step."
    fi
}

generate_helmfile() {
   local ENV_FILE="$1"
   HELM_CHARTS_DIR=$(jq -r '.HELM_CHARTS_DIR' "$ENV_FILE")
   HELMFILE_PATH="./helmcharts/helmfile.yaml"   

  if [ -e "$HELMFILE_PATH" ]; then
        echo "Helmfile already exists at: $HELMFILE_PATH"
    else
        touch $HELMFILE_PATH
	echo "Helmfile generated at: $HELMFILE_PATH"
  fi


   echo "repositories:" > "$HELMFILE_PATH"

    for chart_dir in "$HELM_CHARTS_DIR"/*; do
        if [ -d "$chart_dir" ]; then
            chart_name=$(basename "$chart_dir")
            chart_url="https://ghcr.io/vamshionrails/image_project/$chart_name"

            echo "  - name: $chart_name" >> "$HELMFILE_PATH"
            echo "    url: $chart_url" >> "$HELMFILE_PATH"
        fi
    done

}
