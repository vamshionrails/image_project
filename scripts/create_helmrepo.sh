#!/bin/bash

# Define your GitHub repository name
REPO_NAME=image_project
GITHUB_USERNAME=vamshionrails

# Create a new directory for the Helm charts and navigate into it


# Check if the repository already exists
if [ -d helmcharts ]; then
    # Repository does not exist, initialize a new Helm chart repository
     
    
    # Push the changes to the GitHub repository
    helm create helloworld
    helm package helloworld/ -d pkgs/
    helm repo index helmcharts --merge index.yaml
    helm package helloworld/ -d pkgs/
    
    
fi

# 
