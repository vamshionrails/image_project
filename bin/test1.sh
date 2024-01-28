#!/bin/bash

# GitHub username, repository, and package name
USERNAME="vamshionrails"
REPO="ghcr.io/vamshionrails"
PACKAGE="gh_2.42.1_linux_amd64.tar.gz"

# Personal access token with write:packages scope
TOKEN="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"

# Version number (e.g., 1.0.0)
VERSION="1.0.0"

# Path to the tar.gz file
TAR_FILE="${PACKAGE}"

# GitHub API URL
API_URL="https://api.github.com"

# Authenticate with GitHub using the token
AUTH_HEADER="Authorization: token $TOKEN"

# Create a new release
RELEASE_ID=$(curl -s -H "$AUTH_HEADER" -X POST "$API_URL/repos/$USERNAME/$REPO/releases" -d '{"tag_name": "v'$VERSION'", "name": "Release '$VERSION'", "draft": false, "prerelease": false}' | jq -r '.id')

# Upload the tar.gz file to the release
curl -s -H "$AUTH_HEADER" -H "Content-Type: application/gzip" --data-binary @"$TAR_FILE" "$API_URL/repos/$USERNAME/$REPO/releases/$RELEASE_ID/assets?name=$(basename $TAR_FILE)"
