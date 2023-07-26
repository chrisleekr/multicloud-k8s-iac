#!/bin/bash

log() {
    local message=$1

    COLOR='\033[0;32m' # Green
    NC='\033[0m'       # No Color
    echo -e "${COLOR}$message${NC}"
}
