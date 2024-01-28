 Define your GitHub username, repository, and package name
USERNAME="vamshionrails"
REPO="image_project"
PACKAGE="gh_2.42.1_linux_amd64.tar.gz"

# Define the version number (e.g., 1.0.0)
VERSION="1.0.0"

# Path to the tar.gz file
TAR_FILE="gh_2.42.1_linux_amd64.tar.gz"

# Authenticate with GitHub (use a personal access token with write:packages scope)
#gh auth login

# Create a new package version
gh pkg version -y "${VERSION}" -f "${TAR_FILE}" --owner "${USERNAME}" --repo "${REPO}" --package "${PACKAGE}"

# Publish the package version
gh pkg publish --owner "${USERNAME}" --repo "${REPO}" --package "${PACKAGE}" "${TAR_FILE}" --target "tarball"
