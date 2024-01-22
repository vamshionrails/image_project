#!/bin/bash

# Define your GitHub repository name
REPO_NAME=image_project
GITHUB_USERNAME=vamshionrails

# Create a new directory for the Helm charts and navigate into it


# Check if the repository already exists
if [ ! -d helmcharts ]; then
    # Repository does not exist, initialize a new Helm chart repository
     
    
    # Push the changes to the GitHub repository
    helm create helloworld
    helm package helloworld/ -d pkgs/
    helm repo index .  --merge index.yaml
    helm package helloworld/ -d pkgs/
    
else


    mkdir ../helm-charts
    cd ../helm-charts
    

    # Repository exists, update Helm chart repository and Git repository
    helm repo index --url https://$GITHUB_USERNAME.github.io/$REPO_NAME --merge index.yaml .
    
    # Commit and push the changes to the existing GitHub repository
    
fi

# Enable GitHub Pages for the repository:
# - Go to your GitHub repository settings.
# - Scroll down to the "GitHub Pages" section.
# - Choose the "master branch" as the source.

# Once GitHub Pages is enabled, your Helm chart repository will be accessible at:
# https://$GITHUB_USERNAME.github.io/$REPO_NAME
 
