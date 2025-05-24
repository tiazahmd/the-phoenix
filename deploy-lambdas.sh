#!/bin/bash

# Ensure we're in the correct project directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR" || exit 1

REGION="us-west-2"
SHARP_LAYER_ARN="arn:aws:lambda:us-west-2:175033217214:layer:sharp:2"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to log messages
log() {
    local level=$1
    local message=$2
    local color=$NC
    
    case $level in
        "INFO") color=$GREEN ;;
        "WARN") color=$YELLOW ;;
        "ERROR") color=$RED ;;
    esac
    
    echo -e "${color}[$level] $message${NC}"
}

# Function to check AWS CLI command status
check_command() {
    if [ $? -ne 0 ]; then
        log "ERROR" "$1"
        return 1
    fi
    return 0
}

# Function to deploy a Lambda function
deploy_lambda() {
    local function_name=$1
    local source_dir=$2
    local use_sharp_layer=$3
    
    log "INFO" "Deploying $function_name..."
    
    # Store original directory
    local original_dir="$PWD"
    
    # Change to source directory
    cd "$source_dir" || {
        log "ERROR" "Failed to change to directory: $source_dir"
        return 1
    }
    
    # Install dependencies
    log "INFO" "Installing dependencies..."
    npm install --production
    check_command "Failed to install dependencies" || return 1
    
    # Create deployment package
    log "INFO" "Creating deployment package..."
    zip -r function.zip . -x "node_modules/*" "package-lock.json"
    check_command "Failed to create initial zip file" || return 1
    
    cd node_modules || {
        log "ERROR" "Failed to change to node_modules directory"
        return 1
    }
    zip -r ../function.zip .
    check_command "Failed to add node_modules to zip file" || return 1
    cd ..
    
    # Update Lambda function code
    log "INFO" "Updating function code..."
    aws lambda update-function-code \
        --function-name "$function_name" \
        --zip-file fileb://function.zip \
        --region "$REGION"
    check_command "Failed to update function code" || return 1
    
    # Update configuration if using sharp layer
    if [ "$use_sharp_layer" = true ]; then
        log "INFO" "Updating function configuration with sharp layer..."
        aws lambda update-function-configuration \
            --function-name "$function_name" \
            --layers "$SHARP_LAYER_ARN" \
            --region "$REGION"
        check_command "Failed to update function configuration" || return 1
    fi
    
    # Clean up
    rm function.zip
    check_command "Failed to clean up deployment package" || return 1
    
    # Return to original directory
    cd "$original_dir" || {
        log "ERROR" "Failed to return to original directory"
        return 1
    }
    
    log "INFO" "$function_name deployed successfully"
}

# Main deployment process
log "INFO" "Starting deployment process..."

# Deploy image processor functions
log "INFO" "Deploying image processor functions..."
deploy_lambda "phoenix-image-processor-dev" "$SCRIPT_DIR/lambda/image-processor" true
deploy_lambda "phoenix-image-processor-prod" "$SCRIPT_DIR/lambda/image-processor" true

# Deploy notification handler functions
log "INFO" "Deploying notification handler functions..."
deploy_lambda "phoenix-notification-handler-dev" "$SCRIPT_DIR/lambda/notification-handler" false
deploy_lambda "phoenix-notification-handler-prod" "$SCRIPT_DIR/lambda/notification-handler" false

log "INFO" "All functions deployed successfully" 