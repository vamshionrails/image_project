.PHONY: check_config_file display_config_file create_helm_repo index_helm_file helm_packages publish_ghcr clean_helm_packages

# Define the path to env.json
ENV_FILE := ./configs/env.json
CR_CONFIG_FILE := ./configs/cr_config.yaml
all: build test deploy

check_config_file:
	@source ./lib/validation.sh && check_config_file

display_config_file:
	@source ./lib/validation.sh && display_config_file "$(ENV_FILE)"

create_helm_repo:
	@source ./lib/helm_functions.sh && helm_repo_function "$(ENV_FILE)"

index_helm_file:
	@source ./lib/helm_functions.sh && update_helm_repo_index

helm_packages:
	@source ./lib/helm_functions.sh && helm_package "$(ENV_FILE)"

publish_ghcr:
	@source ./lib/helm_artifacts.sh && publish_to_ghcr "$(ENV_FILE)"

generate_helmfile:
	@source ./lib/helm_artifacts.sh && generate_helmfile "$(ENV_FILE)"

clean_helm_packages:
	@source ./lib/helm_artifacts.sh && clean_helm_packages "$(ENV_FILE)"


.DEFAULT_GOAL := help
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  - check_config_file: 		Validate env.json config file existence"
	@echo "  - display_config_file: 	Display env.json config file content"
	@echo "  - create_helm_repo: 		Create Helm repository"
	@echo "  - index_helm_file: 		Update Helm repository index"
	@echo "  - helm_packages: 		Package Helm charts"
	@echo "  - publish_ghcr: 		Publish Helm packages to GitHub Container Registry"
	@echo "  - clean_helm_packages: 	Clean Helm packages directory"
	@echo "  - generate_helmfile		Generate Helmfile"
	@echo "  - help:         		Display this help message"
