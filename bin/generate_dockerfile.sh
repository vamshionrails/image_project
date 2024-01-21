#!/bin/bash

# Function to generate Dockerfile
generate_dockerfile() {

   python_version=$(jq.exe -r '.python_version' config.json)
   app_directory=$(jq.exe -r '.app_directory' config.json)


    cat <<-EOF > Dockerfile
FROM alpine:edge

WORKDIR ${app_directory}

# Install Python and other dependencies
RUN apk add --no-cache docker curl wget bash
# Install kubectl
COPY ./lib/kubectl.sh /tmp/
RUN bash /tmp/kubectl.sh  


COPY . /app
EOF
}

# Delete existing Dockerfile if it exists
rm -f Dockerfile

# Call the function
generate_dockerfile
