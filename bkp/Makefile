SHELL := /bin/bash

.DEFAULT_GOAL := help

# Variables
ENV_FILE := configs/env.json

# Include variables from env.json using a script
export $(shell cat $(ENV_FILE) | jq -r "to_entries|map(\"\(.key)=\(.value|tostring)\")|.[]")

# Directories
LIB_DIR := lib
SCRIPTS_DIR := scripts
CONFIGS_DIR := configs

# Source function files
include lib/bkp/config_functions.sh
include $(SCRIPTS_DIR)/main_script.sh

# Main targets
.PHONY: all
all: validate_json display_json_content create-helmcharts-folder
#create-helmcharts-folder create-helmfile update-helm-index create-file ## Build all targets

.PHONY: create-helmcharts-folder
create-helmcharts-folder:
	@create_helmcharts_folder "helmcharts"

.PHONY: create-helmfile
create-helmfile: load-config
	@create_helmfile "$(HELMFILE_FOLDER)"

.PHONY: update-helm-index
update-helm-index: load-config
	@update_helm_index "$(HELM_CHARTS_DIR)" "$(HELM_REPO_URL)"

.PHONY: create-file
create-file: load-config
	@create_file "$(HELM_CHARTS_DIR)" "$(INDEX_FILE)"

.PHONY: load-config
load-config:
	@echo "Loading variables from env.json..."

.PHONY: validate_json
validate_json:
	@echo "Validating JSON file..."
	@if jq empty "$(ENV_FILE)" &> /dev/null; then \
		echo "JSON file is valid."; \
	else \
		echo "Error: Invalid JSON format in the JSON file."; \
		exit 1; \
	fi

.PHONY: display_json_content
display_json_content:
	@echo "Displaying content of JSON file..."
	@cat "$(ENV_FILE)"

.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all                    Build all targets"
	@echo "  create-helmcharts-folder   Create Helm charts folder"
	@echo "  create-helmfile         Create Helmfile folder"
	@echo "  update-helm-index       Update Helm index"
	@echo "  create-file             Create file"
	@echo "  load-config             Load variables from env.json"
	@echo "  help                   Display this help message"
