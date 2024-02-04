#!/bin/sh

GITHUB_REPO="https://vamshionrails.github.io/image_project/helmcharts"
INDEX_FILE="./index.yaml"

# Fetch the list of releases from the GitHub Pages site
RELEASES=$(curl -s "$GITHUB_REPO/index.yaml")

# Print the raw response for debugging
echo "Raw GitHub Pages response:"
echo "$RELEASES"

# Create the initial index.yaml content
echo "apiVersion: v1" > "$INDEX_FILE"
echo "entries:" >> "$INDEX_FILE"

# Loop through each chart entry and add it to the index.yaml
echo "$RELEASES" | yq eval '.entries' - | while IFS= read -r CHART_ENTRY; do
    # Check if CHART_ENTRY is not empty or null
    if [ -n "$CHART_ENTRY" ]; then
        # Extract keys dynamically
        KEYS=$(echo "$CHART_ENTRY" | yq eval 'keys_unsorted | .[]' -)

        # Loop through each key in the entry
        for CHART_NAME in $KEYS; do
            CHART_VERSION=$(echo "$CHART_ENTRY" | yq eval ".$CHART_NAME[].version" -)

            # Check if CHART_NAME and CHART_VERSION are not empty or null
            if [ -n "$CHART_NAME" ] && [ -n "$CHART_VERSION" ]; then
                CHART_URL="$GITHUB_REPO/$CHART_NAME-$CHART_VERSION.tgz"

                # Calculate SHA256 checksum using sha256sum
                DIGEST=$(curl -sSL "$CHART_URL" | sha256sum | cut -d' ' -f1)

                # Append to index.yaml
                echo "- name: $CHART_NAME" >> "$INDEX_FILE"
                echo "  version: $CHART_VERSION" >> "$INDEX_FILE"
                echo "  created: $(date -u +"%Y-%m-%dT%H:%M:%SZ")" >> "$INDEX_FILE"
                echo "  url: $CHART_URL" >> "$INDEX_FILE"
                echo "  digest: $DIGEST" >> "$INDEX_FILE"
            fi
        done
    fi
done

echo "Index file generated successfully at $INDEX_FILE"
