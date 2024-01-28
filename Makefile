.PHONY: check_config_file display_config_file create_helm_repo index_helm_file helm_packages publish_ghcr clean_helm_packages

# Define the path to env.json
ENV_FILE := ./configs/env.json

all: build test deploy

check_config_file:
	@source ./lib/validation.sh && check_config_file

display_config_file:
	@source ./lib/validation.sh && display_config_file "$(ENV_FILE)"

create_helm_repo:
	@source ./lib/helm_functions.sh && create_helm_repo

index_helm_file:
	@source ./lib/helm_functions.sh && update_helm_repo_index

helm_packages:
	@source ./lib/helm_functions.sh && helm_package "$(ENV_FILE)"

publish_ghcr:
	@source ./lib/helm_artifacts.sh && publish_to_ghcr "$(ENV_FILE)"

clean_helm_packages:
	@source ./lib/helm_artifacts.sh && clean_helm_packages "$(ENV_FILE)"

.DEFAULT_GOAL := help
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  - all:          		Build, test, and deploy"
	@echo "  - check_config_file: 		Validate env.json file existence"
	@echo "  - display_config_file: 	Display env.json file content"
	@echo "  - create_helm_repo: 		Create Helm repository"
	@echo "  - index_helm_file: 		Update Helm repository index"
	@echo "  - helm_packages: 		Package Helm charts"
	@echo "  - publish_ghcr: 		Publish Helm packages to GitHub Container Registry"
	@echo "  - clean_helm_packages: 	Clean Helm packages directory"
	@echo "  - help:         		Display this help message"
