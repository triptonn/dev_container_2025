#!/usr/bin/env bash

# Script to create a new Love2D project

if [ $# -eq 0 ]; then
    echo "Usage: create-love2d-project.sh <project_name>"
    exit 1
fi

PROJECT_NAME=$1
TEMPLATE_DIR=$HOME/.config/love2d-templates
PROJECT_DIR=$PWD/$PROJECT_NAME

# Create project directory
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR" || exit

# Copy template files
cp "$TEMPLATE_DIR/main.lua" ./
cp "$TEMPLATE_DIR/conf.lua" ./

# Create additional directories
mkdir -p assets/{images,sounds,fonts}
mkdir -p src/{entities,states,utils}

# Create additional files
touch README.md
echo "# $PROJECT_NAME" > README.md
echo "A Love2D game project." >> README.md

# Create .gitignore
cat > .gitignore << EOF
# Love2D build files
*.love

# NPM packages
node_modules/
package-lock.json

# Compiled Lua sources
luac.out

# System files
.DS_Store
Thumbs.db
EOF

# Create a basic package.json for npm
cat > package.json << EOF
{
  "name": "$PROJECT_NAME",
  "version": "0.1.0",
  "description": "A Love2D game project",
  "main": "index.js",
  "scripts": {
    "build": "npm run build:love && npm run build:web",
    "build:love": "zip -9 -r ${PROJECT_NAME}.love .",
    "build:web": "love.js ${PROJECT_NAME}.love ./web",
    "serve": "cd web && npx http-server -p 8080"
  },
  "keywords": [
    "love2d",
    "lua",
    "game"
  ],
  "devDependencies": {
    "http-server": "^14.1.0"
  }
}
EOF

# Initialize npm
npm install

echo "Love2D project '$PROJECT_NAME' created successfully!"
echo "To run your game: love $PROJECT_DIR"
echo "To build for web: npm run build && npm run serve" 