#!/usr/bin/env bash

# Script to run a Love2D game in the web browser

if [ $# -eq 0 ]; then
    echo "Usage: run-love2d-web.sh <love_file_or_directory>"
    exit 1
fi

LOVE_PATH=$1
WEB_DIR="./web"

# Check if input is a directory or a .love file
if [ -d "$LOVE_PATH" ]; then
    # It's a directory, create a temporary .love file
    PROJECT_NAME=$(basename "$LOVE_PATH")
    echo "Creating temporary .love file from directory..."
    cd "$LOVE_PATH" || exit
    zip -9 -r "../${PROJECT_NAME}.love" .
    cd ..
    LOVE_FILE="${PROJECT_NAME}.love"
    CLEANUP_NEEDED=true
elif [[ "$LOVE_PATH" == *.love ]]; then
    # It's already a .love file
    LOVE_FILE=$LOVE_PATH
    PROJECT_NAME=$(basename "$LOVE_PATH" .love)
    CLEANUP_NEEDED=false
else
    echo "Error: Input must be a directory or a .love file"
    exit 1
fi

# Create web directory if it doesn't exist
mkdir -p "$WEB_DIR"

# Use love.js to convert the .love file to browser-runnable format
echo "Converting to web format..."
love.js "$LOVE_FILE" "$WEB_DIR"

# Start a simple HTTP server
echo "Starting HTTP server on port 8080..."
cd "$WEB_DIR" || exit
npx http-server -p 8080 --cors

# Clean up temporary file if needed
if [ "$CLEANUP_NEEDED" = true ]; then
    cd ..
    echo "Cleaning up temporary files..."
    rm "$LOVE_FILE"
fi 