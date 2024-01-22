#!/bin/bash

# Define your GitHub repository name
REPO_NAME=image_project
GITHUB_USERNAME=vamshionrails

# Create a new directory for the Helm charts and navigate into it


# Check if the repository already exists
if [ ! -d .git ]; then
    # Repository does not exist, initialize a new Helm chart repository
    helm repo index --url https://$GITHUB_USERNAME.github.io/$REPO_NAME .
    
    # Initialize a new Git repository
    git init
    
    # Add all files to the Git repository
    git add .
    
    # Commit the changes
    git commit -m "Initialize Helm chart repository"
    
    # Create a new GitHub repository (if not created already)
    # You can automate this step using the GitHub API or create it manually via the GitHub website
    
    # Add a remote to your local Git repository pointing to the GitHub repository
    #git remote add origin https://github.com/$GITHUB_USERNAME/$REPO_NAME.git
    
    # Push the changes to the GitHub repository
    git push -u origin master
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
 
