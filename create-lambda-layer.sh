#!/bin/bash

# Ensure we're in the correct project directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR" || exit 1

REGION="us-west-2"
LAYER_NAME="phoenix-image-processing"
LAYER_DIR="$SCRIPT_DIR/lambda-layer"

# Create a temporary directory for the layer
mkdir -p "$LAYER_DIR/nodejs"

# Create package.json for the layer
cat > "$LAYER_DIR/nodejs/package.json" << EOL
{
  "name": "phoenix-image-processing-layer",
  "version": "1.0.0",
  "dependencies": {
    "sharp": "^0.32.6"
  }
}
EOL

# Install dependencies
cd "$LAYER_DIR/nodejs" || exit 1
npm install --production
cd "$SCRIPT_DIR" || exit 1

# Create ZIP file
cd "$LAYER_DIR" || exit 1
zip -r "$SCRIPT_DIR/layer.zip" *
cd "$SCRIPT_DIR" || exit 1

# Publish layer
aws lambda publish-layer-version \
    --layer-name $LAYER_NAME \
    --description "Image processing dependencies including sharp" \
    --license-info "MIT" \
    --zip-file fileb://layer.zip \
    --compatible-runtimes nodejs20.x \
    --region $REGION

# Clean up
rm -rf "$LAYER_DIR" layer.zip

echo "Lambda layer created successfully" 