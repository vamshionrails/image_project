#!/bin/bash

check_config_file() {
    local ENV_FILE="./configs/env.json"

    if [ ! -f "$ENV_FILE" ]; then
        echo "Error: The env.json file does not exist in the configs folder."
        exit 1
    else
        echo "Config file exists."
    fi
}


display_config_file() {
    local ENV_FILE="./configs/env.json"

    if [ ! -f "$ENV_FILE" ]; then
        echo "Error: The env.json file does not exist in the configs folder."
        exit 1
    else
        echo "Config file contents:"
        cat "$ENV_FILE"
    fi
}
