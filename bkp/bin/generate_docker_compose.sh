#!/bin/bash

# Function to generate docker-compose.yaml
generate_docker_compose() {

  # Read Variables from JSON file
  container_name=$(jq -r '.container_name' config.json)
  ports=$(jq -r '.ports | join(",")' config.json)
  volumes=$(jq -r '.volumes | join(",")' config.json)
  command=$(jq -r '.command | @sh' config.json)
  image=$(jq -r '.image' config.json)


# Create docker-compose.yaml file
cat <<-EOF > docker-compose.yaml

version: '3.9' 
services:
  ${container_name}:
    build:
      context: .
      dockerfile: Dockerfile
    container_name: ${container_name}
    tty: true
    ports:
      - "10001:10001"
      - "8081:8081"
      - "10002:10002"
      - "81:81"
      - "80:80"
      - "8001:8001"
    volumes: 
      - /var/run/docker.sock:/var/run/docker.sock 
    command: ["sh", "-c", "while :; do sleep 10; done"]
    image: ${image}  # Specify the image version 
networks:
  host:
    name: host
    external: true
# networks:
#   default:
#     external:
#       name: bridge

EOF
}

# Delete existing docker-compose.yaml if it exists
rm -f docker-compose.yaml

# Call the function
generate_docker_compose

echo "Dockerfile and docker-compose.yaml have been recreated."
