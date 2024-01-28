#!/bin/bash

# Read variables from env.json
ENV_VARS_FILE="../configs/env.json"
GITHUB_USERNAME=$(jq -r .GITHUB_USERNAME ${ENV_VARS_FILE})
GITHUB_TOKEN=$(jq -r .GITHUB_TOKEN ${ENV_VARS_FILE})
SECRET_NAME=$(jq -r .SECRET_NAME ${ENV_VARS_FILE})
K8S_NAMESPACE=$(jq -r .K8S_NAMESPACE ${ENV_VARS_FILE})
RELEASE_NAME=$(jq -r .RELEASE_NAME ${ENV_VARS_FILE})
CHART_REPO=$(jq -r .CHART_REPO ${ENV_VARS_FILE})
HELM_REPO_FOLDER=$(jq -r .HELM_REPO_FOLDER ${ENV_VARS_FILE})
HELMFILE_FOLDER=$(jq -r .HELMFILE_FOLDER ${ENV_VARS_FILE})
HELM_REPO_URL=$(jq -r .HELM_REPO_URL ${ENV_VARS_FILE})


# Step1:Check if the secret already exists
if kubectl get secret ${SECRET_NAME} --namespace=${K8S_NAMESPACE} &>/dev/null; then
  echo "Secret ${SECRET_NAME} already exists. Skipping creation."
else
  # Step 1: Create GitHub Token Kubernetes Secret
  kubectl create secret docker-registry ${SECRET_NAME} \
    --docker-server=docker.pkg.github.com \
    --docker-username=${GITHUB_USERNAME} \
    --docker-password=${GITHUB_TOKEN} \
    --namespace=${K8S_NAMESPACE}
fi

# Step 4: Create or Update Helmfile
cd ../configs/ || exit

# If Helmfile doesn't exist, create it
if [ ! -f "helmfile.yaml" ]; then
  cat <<EOF > helmfile.yaml
releases:
- name: ${RELEASE_NAME}
  chart: ${CHART_REPO}
  version: latest
  values:
    - my-values.yaml
EOF
else
  echo "Helmfile already exists. Skipping creation."
fi
