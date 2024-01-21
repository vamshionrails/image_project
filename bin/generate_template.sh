# Function to generate config.json
generate_config_json() {
    cat <<-EOF > config.json
{
  "python_version": "3.8",
  "app_directory": "/app",
  "container_name": "kubernetes-container",
  "ports": ["10001:10001", "8081:8081", "10002:10002", "81:81", "80:80"],
  "volumes": ["./app_data:/app", "/var/run/docker.sock:/var/run/docker.sock"],
  "command": ["sh", "-c", "while :; do sleep 10; done"],
  "image": "vamshionrails/kubernetes:v1"
}
EOF
}
generate_config_json