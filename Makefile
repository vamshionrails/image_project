.PHONY: all build test deploy backup check_config_file display_config_file create_helm_repo index_helm_file helm_packages

# Define the path to env.json
ENV_FILE := ./configs/env.json

all: build test deploy

build:
    # Add commands for building your project

test:
    # Add commands for testing your project

deploy: check_config_file create_helm_repo
	./scripts/deploy.sh

backup: check_config_file
	./scripts/backup.sh

check_config_file:
	@source ./lib/validation.sh && check_config_file

display_config_file:
	@source ./lib/display.sh && display_config_file

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

help:
	@echo "Available targets:"
	@echo "  - all:          Build, test, and deploy"
	@echo "  - build:        Build your project"
	@echo "  - test:         Run tests for your project"
	@echo "  - deploy:       Deploy your project"
	@echo "  - backup:       Run backup script"
	@echo "  - check_config_file: Validate env.json file existence"
	@echo "  - display_config_file: Display env.json file content"
	@echo "  - create_helm_repo: Create Helm repository"
	@echo "  - index_helm_file: Update Helm repository index"
	@echo "  - helm_packages: Package Helm charts"
	@echo "  - publish_ghcr: Publish Helm packages to GitHub Container Registry"
	@echo "  - clean_helm_packages: Clean Helm packages directory"
	@echo "  - help:         Display this help message"
